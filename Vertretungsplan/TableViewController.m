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
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"stunde" ascending:YES]];
        if(![self.klasse isEqualToString:@"komplett"]) request.predicate = [NSPredicate predicateWithFormat:@"klasse == %@", self.klasse];
        else request.predicate = [NSPredicate predicateWithFormat:@"TRUEPREDICATE"];
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:@"stunde" cacheName:nil];
        
    }else {
        self.fetchedResultsController = nil;
    }
}

- (IBAction)refresh
{
    if(!isRefreshing){
        [self.refreshControl beginRefreshing];
        [self refreshData];
    }
    else{
        [self.refreshControl endRefreshing];
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
    if(!self.klasse) self.klasse = @"5.1";
    [self updateTableHeaderView];
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
            CGSize size = [headerText sizeWithFont:[UIFont fontWithName:@"AvenirNext-Medium" size:15.0] constrainedToSize:CGSizeMake(self.tableView.frame.size.width-10, 20000) lineBreakMode:NSLineBreakByWordWrapping];
            
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
    
    NSDate *today = [[NSDate alloc] init];
    
    /* Generate the URL */
    
    NSString *requestUrl = nil;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents =[gregorian components:NSWeekdayCalendarUnit fromDate:today];
    NSInteger weekday = [weekdayComponents weekday];
    switch (weekday) {
        case 1: // Sunday
        case 2: // Monday
        case 7: // Saturday
            requestUrl = @"http://www.otto-nagel-gymnasium.de/joomla158/plaene/KLmontag.htm";
            break;
        case 3: //Tuesday
            requestUrl = @"http://www.otto-nagel-gymnasium.de/joomla158/plaene/KLdienst.htm";
            break;
        case 4: //Wednesday
            requestUrl = @"http://www.otto-nagel-gymnasium.de/joomla158/plaene/KLmittwo.htm";
            break;
        case 5: //Thursday
            requestUrl = @"http://www.otto-nagel-gymnasium.de/joomla158/plaene/KLdonners.htm";
            break;
        case 6: //Friday
            requestUrl = @"http://www.otto-nagel-gymnasium.de/joomla158/plaene/KLfreita.htm";
            break;   
        default: //Erde geht unter
            break;
    }
    
    if(requestUrl){ // Erde ist nicht untergegangen
        
        // Create the connection
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:requestUrl]];
        
        // Make an NSOperationQueue
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [queue setName:@"fetchNewPlan"];
        
        // Send an asyncronous request on the queue
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            
            // If there was an error getting the data
            if (error) {
                
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                });
                isRefreshing = NO;
                return;
            }
            
            NSString *content = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];

            if([content length]>0){ // We received data!
                
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
                
                
                //[self.tableView beginUpdates];
                
                NSRegularExpression *regexZeit = [NSRegularExpression
                                                       regularExpressionWithPattern:@"<div class=\"mon_title\">([^ ]*)"
                                                       options:0
                                                       error:&error];
                
                NSArray* zeitMatches = [regexZeit matchesInString:content options:0 range:NSMakeRange(0, [content length])];
                
                
                NSTextCheckingResult *dateStr = [zeitMatches lastObject];
                
                // Convert string to date object
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"dd.MM.YYYY"];
                NSDate *date = [dateFormat dateFromString:[content substringWithRange:[dateStr rangeAtIndex:1]]];
                NSLog(@"%@, %@", date, today);
                if([date dateByAddingTimeInterval:60*60*24] > today || true){ // Plan aktuell

                    //dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"here!");
                        NSError *error = nil;
                        NSRegularExpression *regex = [NSRegularExpression
                                                      regularExpressionWithPattern:@"<tr .*<td class=\"list\"(?: align=\"center\"){0,1}>(.*)</td><td class=\"list\"(?: align=\"center\"){0,1}>(.*)</td><td class=\"list\"(?: align=\"center\"){0,1}>(?:<strike>)*([^<]*)(?:</strike>)*</td><td class=\"list\"(?: align=\"center\"){0,1}>(.*)</td><td class=\"list\"(?: align=\"center\"){0,1}>(.*)</td><td class=\"list\"(?: align=\"center\"){0,1}>(?:<strike>)*([^<]*)(?:</strike>)*</td><td class=\"list\"(?: align=\"center\"){0,1}>(?:<strike>)*([^<]*)(?:</strike>)*</td><td class=\"list\"(?: align=\"center\"){0,1}>(.*)</td><td class=\"list\"(?: align=\"center\"){0,1}>(.*)</td><td class=\"list\"(?: align=\"center\"){0,1}>(.*)</td>.*</tr>"
                                                      options:0
                                                      error:&error];
                        
                        NSArray* matches = [regex matchesInString:content options:0 range:NSMakeRange(0, [content length])];
                        
                        for (NSTextCheckingResult *match in matches) {
                            
                            NSString *klasse = [[content substringWithRange:[match rangeAtIndex:1]] gtm_stringByUnescapingFromHTML];
                            NSRange range = [klasse rangeOfString:@"."];
                            
                            if(!([klasse isEqualToString:@"12"] || [klasse isEqualToString:@"13"])){
                            
                                for (int i = range.location; i<[klasse length]-1; i++) {
                                    if([[klasse substringWithRange:NSMakeRange(i+1, 1)] intValue]>3){ // Neue Klasse beginnt wie 10.39.3
                                        klasse = [klasse substringWithRange:NSMakeRange(i+1, [klasse length]-i-1)];
                                        range = [klasse rangeOfString:@"."];
                                        for (int i = range.location; i<[klasse length]-1; i++) {
                                            
                                            NSString *gefundeneKlasse = [[klasse substringWithRange:NSMakeRange(0, range.location)] stringByAppendingString:[NSString stringWithFormat:@".%@", [klasse substringWithRange:NSMakeRange(i+1, 1)]]];
                                            
                                            Vertretung *vertretung = [NSEntityDescription insertNewObjectForEntityForName:@"Vertretung" inManagedObjectContext:self.managedObjectContext];
                                            vertretung.klasse = gefundeneKlasse;
                                            vertretung.stunde = [[content substringWithRange:[match rangeAtIndex:2]] gtm_stringByUnescapingFromHTML];
                                            vertretung.lehrerAlt = [[content substringWithRange:[match rangeAtIndex:3]] gtm_stringByUnescapingFromHTML];
                                            vertretung.fachAlt = [[content substringWithRange:[match rangeAtIndex:4]] gtm_stringByUnescapingFromHTML];
                                            vertretung.raumAlt = [[content substringWithRange:[match rangeAtIndex:5]] gtm_stringByUnescapingFromHTML];
                                            vertretung.vertreter = [[content substringWithRange:[match rangeAtIndex:6]] gtm_stringByUnescapingFromHTML];
                                            vertretung.fachNeu = [[content substringWithRange:[match rangeAtIndex:7]] gtm_stringByUnescapingFromHTML];
                                            vertretung.raumNeu = [[content substringWithRange:[match rangeAtIndex:8]] gtm_stringByUnescapingFromHTML];
                                            vertretung.art = [[content substringWithRange:[match rangeAtIndex:9]] gtm_stringByUnescapingFromHTML];
                                            vertretung.vertretungstext = [[content substringWithRange:[match rangeAtIndex:10]] gtm_stringByUnescapingFromHTML];
                                            vertretung.datum = [[NSDate alloc] init];
                                        }
                                    }
                                    else{                                
                                        NSString *gefundeneKlasse = [[klasse substringWithRange:NSMakeRange(0, range.location)] stringByAppendingString:[NSString stringWithFormat:@".%@", [klasse substringWithRange:NSMakeRange(i+1, 1)]]];
                                    
                                        Vertretung *vertretung = [NSEntityDescription insertNewObjectForEntityForName:@"Vertretung" inManagedObjectContext:self.managedObjectContext];
                                        vertretung.klasse = gefundeneKlasse;
                                        vertretung.stunde = [[content substringWithRange:[match rangeAtIndex:2]] gtm_stringByUnescapingFromHTML];
                                        vertretung.lehrerAlt = [[content substringWithRange:[match rangeAtIndex:3]] gtm_stringByUnescapingFromHTML];
                                        vertretung.fachAlt = [[content substringWithRange:[match rangeAtIndex:4]] gtm_stringByUnescapingFromHTML];
                                        vertretung.raumAlt = [[content substringWithRange:[match rangeAtIndex:5]] gtm_stringByUnescapingFromHTML];
                                        vertretung.vertreter = [[content substringWithRange:[match rangeAtIndex:6]] gtm_stringByUnescapingFromHTML];
                                        vertretung.fachNeu = [[content substringWithRange:[match rangeAtIndex:7]] gtm_stringByUnescapingFromHTML];
                                        vertretung.raumNeu = [[content substringWithRange:[match rangeAtIndex:8]] gtm_stringByUnescapingFromHTML];
                                        vertretung.art = [[content substringWithRange:[match rangeAtIndex:9]] gtm_stringByUnescapingFromHTML];
                                        vertretung.vertretungstext = [[content substringWithRange:[match rangeAtIndex:10]] gtm_stringByUnescapingFromHTML];
                                        vertretung.datum = [[NSDate alloc] init];
                                    }
                                }
                            }
                            
                           else{
                               Vertretung *vertretung = [NSEntityDescription insertNewObjectForEntityForName:@"Vertretung" inManagedObjectContext:self.managedObjectContext];
                               vertretung.klasse = klasse;
                               vertretung.stunde = [[content substringWithRange:[match rangeAtIndex:2]] gtm_stringByUnescapingFromHTML];
                               vertretung.lehrerAlt = [[content substringWithRange:[match rangeAtIndex:3]] gtm_stringByUnescapingFromHTML];
                               vertretung.fachAlt = [[content substringWithRange:[match rangeAtIndex:4]] gtm_stringByUnescapingFromHTML];
                               vertretung.raumAlt = [[content substringWithRange:[match rangeAtIndex:5]] gtm_stringByUnescapingFromHTML];
                               vertretung.vertreter = [[content substringWithRange:[match rangeAtIndex:6]] gtm_stringByUnescapingFromHTML];
                               vertretung.fachNeu = [[content substringWithRange:[match rangeAtIndex:7]] gtm_stringByUnescapingFromHTML];
                               vertretung.raumNeu = [[content substringWithRange:[match rangeAtIndex:8]] gtm_stringByUnescapingFromHTML];
                               vertretung.art = [[content substringWithRange:[match rangeAtIndex:9]] gtm_stringByUnescapingFromHTML];
                               vertretung.vertretungstext = [[content substringWithRange:[match rangeAtIndex:10]] gtm_stringByUnescapingFromHTML];
                               vertretung.datum = [[NSDate alloc] init];
                           }
                        

                        }
                        
                        error = nil;
                        NSRegularExpression *regexNachricht = [NSRegularExpression
                                                      regularExpressionWithPattern:@"<td class='info' colspan=\"2\">(.*)</td>"
                                                      options:0
                                                      error:&error];
                        
                        NSArray* nachrichtMatches = [regexNachricht matchesInString:content options:0 range:NSMakeRange(0, [content length])];
                        
                        for (NSTextCheckingResult *match in nachrichtMatches) {
                            
                            Nachrichten *nachricht = [NSEntityDescription insertNewObjectForEntityForName:@"Nachrichten" inManagedObjectContext:self.managedObjectContext];
                            nachricht.nachricht = [[content substringWithRange:[match rangeAtIndex:1]] gtm_stringByUnescapingFromHTML];
                            nachricht.datum = [[NSDate alloc] init];
                        }
                    //});
                }
                
                
                [self updateTableHeaderView];
                //[self.tableView endUpdates];
                isRefreshing = NO;
                
                // All looks fine, lets call the completion block with the response data
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.refreshControl endRefreshing];
                    [[Database sharedInstance] saveContext];
                });
            }
        }];
            
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showDetails"]) {
        DetailViewController *newController = segue.destinationViewController;
        newController.vertretung = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
    }
}

@end
