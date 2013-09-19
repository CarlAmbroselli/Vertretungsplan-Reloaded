//
//  TableViewController.m
//  Vertretungsplan
//
//  Created by Carl Ambroselli on 03.09.13.
//  Copyright (c) 2013 carlambroselli. All rights reserved.
//

#import "TableViewController.h"
#import "Cell.h"
#import "Database.h"
#import "Vertretung.h"
#import "DetailViewController.h"
#import "GTMNSString+HTML.h"
#import "Nachrichten.h"

@interface TableViewController ()

@end

@implementation TableViewController

bool isRefreshing = NO;

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    if(managedObjectContext) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Vertretung"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"stunde" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"klasse" ascending:YES]];
        if(![self.klasse isEqualToString:@"komplett"]) request.predicate = [NSPredicate predicateWithFormat:@"klasse == %@ AND datum > %@", self.klasse, [NSDate dateWithTimeIntervalSinceNow:-60*60*24]];
        else request.predicate = [NSPredicate predicateWithFormat:@"TRUEPREDICATE"];
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:@"stunde" cacheName:nil];
        
    }else {
        self.fetchedResultsController = nil;
    }
    
    if([[self.fetchedResultsController sections] count] == 0){
        [self.view addSubview:self.noChangesView];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    else {
        if (self.noChangesView) {
            [self.noChangesView removeFromSuperview];
            self.noChangesView = nil;
        }
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
}

- (IBAction)refresh
{
    if(!isRefreshing){
        [self.refreshControl beginRefreshing];
        [self refreshData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Set the top left Button
    UIButton* btton = [UIButton buttonWithType:UIButtonTypeCustom];
    [btton setFrame:CGRectMake(15, 0, 15, 15)];
    [btton addTarget:self action:@selector(menuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [btton setImage:[UIImage imageNamed:@"btn.png"] forState:UIControlStateNormal];
    UIBarButtonItem* barButton = [[UIBarButtonItem alloc] initWithCustomView:btton];
    
    self.navigationItem.leftBarButtonItem = barButton;
    
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
	[self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.0/255 green:120.0/255 blue:197.0/255 alpha:1.0]];
    [self updateTableHeaderView];
    if(!self.klasse) self.klasse = @"5.1";
    if(!isRefreshing) [self refreshData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(!self.klasse){
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        self.klasse = [userDefaults objectForKey:@"class"];
    }
    else
        self.managedObjectContext = [[Database sharedInstance] managedObjectContext];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)setKlasse:(NSString *)klasse
{
    _klasse = klasse;
    self.managedObjectContext = [[Database sharedInstance] managedObjectContext];
    if(klasse) self.title = [@"Vertretungen - " stringByAppendingString:klasse];
}

- (void)updateTableHeaderView{
    NSString *headerText = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Nachrichten"];
    request.predicate = [NSPredicate predicateWithFormat:@"TRUEPREDICATE"];
    
    NSError *error;
    NSArray *matches = [[[Database sharedInstance] managedObjectContext] executeFetchRequest:request error:&error];
    if(error) NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    else{
        headerText = ((Nachrichten *)[matches lastObject]).nachricht;
        
        if([matches count]>0){
            CGSize size = [headerText sizeWithFont:[UIFont fontWithName:@"AvenirNext-Medium" size:15.0] constrainedToSize:CGSizeMake(self.tableView.frame.size.width-20, 200000) lineBreakMode:NSLineBreakByWordWrapping];
            
            UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.origin.x, size.height+15)];
            UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 5.0, self.tableView.frame.size.width-40, size.height+5)];
            labelView.text = headerText;
            labelView.font = [UIFont fontWithName:@"AvenirNext-Medium" size:15.0];
            labelView.lineBreakMode = NSLineBreakByWordWrapping;
            labelView.numberOfLines = 0;
            labelView.textAlignment = NSTextAlignmentCenter;
            [headerView addSubview:labelView];
            self.tableView.tableHeaderView = headerView;
        }
        else{
            self.tableView.tableHeaderView = nil;
        }
    }
    
    if([[self.fetchedResultsController sections] count] == 0){
            [self.view addSubview:self.noChangesView];
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
    else {
        if (self.noChangesView) {
            [self.noChangesView removeFromSuperview];
            self.noChangesView = nil;
        }
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self updateTableHeaderView];
}


#pragma mark - Table view data source


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    cell.textLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:15.0];
    
    Vertretung *vertretung = ((Vertretung *)[self.fetchedResultsController objectAtIndexPath:indexPath]);
    if([vertretung.art isEqualToString:@"Vertretung"]){
        cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@) → %@ (%@) %@", vertretung.fachAlt, vertretung.lehrerAlt, vertretung.fachNeu, vertretung.vertreter, vertretung.raumNeu];
    } else if ([vertretung.art isEqualToString:@"Betreuung"]){
        cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@) → %@ (%@) %@", vertretung.fachAlt, vertretung.lehrerAlt, vertretung.fachNeu, vertretung.vertreter, vertretung.raumNeu];
    }else if ([vertretung.art isEqualToString:@"Entfall"]){
        cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@) entfällt", vertretung.fachAlt, vertretung.lehrerAlt];
    }
    else
        cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@) → %@ (%@) %@", vertretung.fachAlt, vertretung.lehrerAlt, vertretung.fachNeu, vertretung.vertreter, vertretung.raumNeu];
    
    if([vertretung.vertretungstext length]>1){
        cell.textLabel.text = [cell.textLabel.text stringByAppendingString:@" 📄"];
    }
    
    if([self.klasse isEqualToString:@"komplett"])
        cell.textLabel.text = [NSString stringWithFormat:@"%@: (%@)", vertretung.klasse, cell.textLabel.text];
    
    return cell;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView * header = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(8, 3, 310, 20)];
    
    label.text = [[self tableView:tableView titleForHeaderInSection:section] stringByAppendingString:@". Stunde"];
    label.font = [UIFont fontWithName:@"Futura" size:12.0f];
    label.backgroundColor = [UIColor clearColor];
    [header addSubview:label];
    header.backgroundColor = [UIColor colorWithRed:0.0/255 green:120.0/255 blue:197.0/255 alpha:0.1];
    return header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25.f;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int ret = [super tableView:tableView numberOfRowsInSection:section];
    
    if (ret == 0 && section == 0) {
        [self.view addSubview:self.noChangesView];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    else {
        if (self.noChangesView) {
            [self.noChangesView removeFromSuperview];
            self.noChangesView = nil;
        }
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return ret;
}


#pragma mark - Table view delegate

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return nil;
}

#pragma mark - Sliding delegate

- (void)menuButtonPressed:(id)sender {
    [self.delegate menuButtonPressed:sender];
}

- (void)refreshData
{
    isRefreshing = YES;
    
    [self removeOldEntries];
    
    // Generate the URL
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://ong-untis-parser.herokuapp.com/%@.json", [self currentWeekday]]];
    
    // Create the connection
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    // Make an NSOperationQueue
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue setName:@"Substitute Fetch"];
    
    // Send an asyncronous request on the queue
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        // If there was an error getting the data
        if (error) {
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            });
            return;
        }
        
        // Decode the data
        NSError *jsonError;
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        // If there was an error decoding the JSON
        if (jsonError) {
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                NSLog(@"Unresolved JSON error %@, %@", jsonError, [jsonError userInfo]);
            });
            return;
        }
        
        [self fetchedData:responseDict];
        
    }];
    
}

- (void)fetchedData:(NSDictionary *)responseData {
    
    if(responseData){
        
        NSDictionary* substitutes = [responseData objectForKey:@"substitutes"];
        
        NSArray *keys = [substitutes allKeys]; //NSArray of dictionary's keys
        
        for (id key in keys) //'foreach' loop for all keys
        {
            for( NSString *klasse in [self klassenForKey:[NSString stringWithFormat:@"%@", key]]){
                id information = [substitutes objectForKey: key]; //getting object from the dictionary
                
                for (NSDictionary* substitute in information) {
                    Vertretung *vertretung = [NSEntityDescription insertNewObjectForEntityForName:@"Vertretung" inManagedObjectContext:self.managedObjectContext];
                    vertretung.klasse = klasse;
                    vertretung.stunde = [substitute[@"period"] stringValue];
                    vertretung.lehrerAlt = substitute[@"was"][@"teacher"];
                    vertretung.fachAlt = substitute[@"was"][@"shorthand"];
                    vertretung.vertreter = substitute[@"is"][@"teacher"];
                    vertretung.fachNeu = substitute[@"is"][@"shorthand"];
                    vertretung.raumNeu = substitute[@"is"][@"room"];
                    vertretung.art = substitute[@"text"];
                    vertretung.vertretungstext = substitute[@"type"];
                    vertretung.datum = [self dateFromString:responseData[@"meta"][@"valid_on"]];
                }
            }
        
        }
    }
    
    if(responseData[@"meta"][@"info"] != [NSNull null]){
        Nachrichten *nachricht = [NSEntityDescription insertNewObjectForEntityForName:@"Nachrichten" inManagedObjectContext:self.managedObjectContext];
        nachricht.nachricht = responseData[@"meta"][@"info"];
        nachricht.datum = [self dateFromString:responseData[@"meta"][@"valid_on"]];
    }
    
        dispatch_async(dispatch_get_main_queue(), ^{
            isRefreshing = NO;
            [self updateTableHeaderView];
            [self.refreshControl endRefreshing];
            [[Database sharedInstance] saveContext];
        });
}

- (void) removeOldEntries{
    
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        NSFetchRequest * oldEntries = [[NSFetchRequest alloc] init];
        [oldEntries setEntity:[NSEntityDescription entityForName:@"Vertretung" inManagedObjectContext:self.managedObjectContext]];
        [oldEntries setIncludesPropertyValues:NO]; //only fetch the managedObjectID
        
        NSError * error = nil;
        NSArray * vertretungen = [self.managedObjectContext executeFetchRequest:oldEntries error:&error];
        
        if (error) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
        else{
            //error handling goes here
            for (NSManagedObject * vertretung in vertretungen) {
                [self.managedObjectContext deleteObject:vertretung];
            }
        }
        
        NSFetchRequest * oldNachrichten = [[NSFetchRequest alloc] init];
        [oldNachrichten setEntity:[NSEntityDescription entityForName:@"Nachrichten" inManagedObjectContext:self.managedObjectContext]];
        [oldNachrichten setIncludesPropertyValues:NO]; //only fetch the managedObjectID
        
        error = nil;
        NSArray * nachrichten = [self.managedObjectContext executeFetchRequest:oldNachrichten error:&error];
        
        if (error) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
        else{
            for (NSManagedObject * nachricht in nachrichten) {
                [self.managedObjectContext deleteObject:nachricht];
            }
        }
    });
    
}

- (NSArray *) klassenForKey:(NSString *)key{
    NSMutableArray *klassen = [[NSMutableArray alloc] init];
    
    NSRange range = [key rangeOfString:@"."];
    
    //Klasse 12 oder 13
    if([key isEqualToString:@"12"] || [key isEqualToString:@"13"])
        [klassen addObject:key];
    
    else if([key isEqualToString:@"5IG"])
        [klassen addObjectsFromArray:@[@"5.1", @"5.2", @"5.3"]];
    
    else if([key isEqualToString:@"6IG"])
        [klassen addObjectsFromArray:@[@"6.1", @"6.2", @"6.3"]];
    
    else if([key isEqualToString:@"7IG"])
        [klassen addObjectsFromArray:@[@"7.1", @"7.2", @"7.3"]];
    
    else if([key isEqualToString:@"8IG"])
        [klassen addObjectsFromArray:@[@"8.1", @"8.2", @"8.3"]];
    
    else if([key isEqualToString:@"9IG"])
        [klassen addObjectsFromArray:@[@"9.1", @"9.2", @"9.3"]];
    
    else if([key isEqualToString:@"10IG"])
        [klassen addObjectsFromArray:@[@"10.1", @"10.2", @"10.3"]];
    
    else {
        
        for (int i = range.location; i<[key length]-1; i++) {
            if([[key substringWithRange:NSMakeRange(i+1, 1)] intValue]>3){ // Neue Klasse beginnt wie 10.39.3
                key = [key substringWithRange:NSMakeRange(i+1, [key length]-i-1)];
                range = [key rangeOfString:@"."];
                
                for (int i = range.location; i<[key length]-1; i++)
                    [klassen addObject: [[key substringWithRange:NSMakeRange(0, range.location)] stringByAppendingString:[NSString stringWithFormat:@".%@", [key substringWithRange:NSMakeRange(i+1, 1)]]]];
                
            }
            
            else
                [klassen addObject: [[key substringWithRange:NSMakeRange(0, range.location)] stringByAppendingString:[NSString stringWithFormat:@".%@", [key substringWithRange:NSMakeRange(i+1, 1)]]]];

        }
    }
    
    return klassen;
}

- (NSString *) currentWeekday{
    NSDate *today = [[NSDate alloc] init];
    
    /* Generate the URL */
    
    NSString *weekday = nil;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents =[gregorian components:NSWeekdayCalendarUnit fromDate:today];
    NSInteger day = [weekdayComponents weekday];
    switch (day) {
        case 1: // Sunday
        case 2: // Monday
        case 7: // Saturday
            weekday = @"monday";
            break;
        case 3: //Tuesday
            weekday = @"tuesday";
            break;
        case 4: //Wednesday
            weekday = @"wednesday";
            break;
        case 5: //Thursday
            weekday = @"thursday";
            break;
        case 6: //Friday
            weekday = @"friday";
            break;
        default: //Erde geht unter
            break;
    }
    
    return weekday;
}

- (NSDate *)dateFromString:(NSString*) dateString
{
    // Prepare an NSDateFormatter to convert to and from the string representation
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    // ...using a date format corresponding to your date
    [dateFormatter setDateFormat:@"yyy-MM-dd HH:mm:ss ZZZ"];
    
    // Parse the string representation of the date
    NSDate *date = [dateFormatter dateFromString:dateString];
    
    return date;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showDetails"]) {
        DetailViewController *newController = segue.destinationViewController;
        newController.vertretung = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
    }
}

- (UIView *) noChangesView {
    if (_noChangesView == nil) {
        _noChangesView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
        _noChangesView.center = CGPointMake(self.tableView.center.x, self.tableView.center.y-80);
        _noChangesView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        _noChangesView.layer.cornerRadius = 10.f;
        _noChangesView.clipsToBounds = YES;
        
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 180, 100)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor darkGrayColor];
        titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:17.0];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"Keine Vertretungen vorhanden!";
        titleLabel.numberOfLines = 10;
        ;
        [_noChangesView addSubview:titleLabel];
    }
    
    return _noChangesView;
}

@end
