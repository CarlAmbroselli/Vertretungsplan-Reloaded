//
//  LeftViewController.m
//  Vertretungsplan
//
//  Created by Carl Ambroselli on 03.09.13.
//  Copyright (c) 2013 carlambroselli. All rights reserved.
//

#import "LeftViewController.h"
#import "TableViewController.h"

@interface LeftViewController ()

@end

@implementation LeftViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"separator.png"]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 21;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Klasse 5.1";
            break;
        case 1:
            cell.textLabel.text = @"Klasse 5.2";
            break;
        case 2:
            cell.textLabel.text = @"Klasse 5.3";
            break;
        case 3:
            cell.textLabel.text = @"Klasse 6.1";
            break;
        case 4:
            cell.textLabel.text = @"Klasse 6.2";
            break;
        case 5:
            cell.textLabel.text = @"Klasse 6.3";
            break;
        case 6:
            cell.textLabel.text = @"Klasse 7.1";
            break;
        case 7:
            cell.textLabel.text = @"Klasse 7.2";
            break;
        case 8:
            cell.textLabel.text = @"Klasse 7.3";
            break;
        case 9:
            cell.textLabel.text = @"Klasse 8.1";
            break;
        case 10:
            cell.textLabel.text = @"Klasse 8.2";
            break;
        case 11:
            cell.textLabel.text = @"Klasse 8.3";
            break;
        case 12:
            cell.textLabel.text = @"Klasse 9.1";
            break;
        case 13:
            cell.textLabel.text = @"Klasse 9.2";
            break;
        case 14:
            cell.textLabel.text = @"Klasse 9.3";
            break;
        case 15:
            cell.textLabel.text = @"Klasse 10.1";
            break;
        case 16:
            cell.textLabel.text = @"Klasse 10.2";
            break;
        case 17:
            cell.textLabel.text = @"Klasse 10.3";
            break;
        case 18:
            cell.textLabel.text = @"Jahrgang 12";
            break;
        case 19:
            cell.textLabel.text = @"Jahrgang 13";
            break;
        case 20:
            cell.textLabel.text = @"Komplett";
            break;
        default:
            break;
    }
    
    cell.textLabel.textColor = [UIColor colorWithRed:0.0/255 green:120.0/255 blue:197.0/255 alpha:1.0];
    cell.textLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:17.0];
    
    UIImage *accessoryImage = [UIImage imageNamed:@"accessory_disclosure.png"];
    UIImageView *accImageView = [[UIImageView alloc] initWithImage:accessoryImage];
    [accImageView setFrame:CGRectMake(20, 0, 90, 28)];
    accImageView.backgroundColor = [UIColor clearColor];
    accImageView.userInteractionEnabled = YES;
    cell.accessoryView = accImageView;
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor grayColor];
    cell.selectedBackgroundView = v;
    
    
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    
    
    
    
    switch (indexPath.row) {
        case 0:
            [userDefaults setObject:@"5.1" forKey:@"class"];
            break;
        case 1:
            [userDefaults setObject:@"5.2" forKey:@"class"];
            break;
        case 2:
            [userDefaults setObject:@"5.3" forKey:@"class"];
            break;
        case 3:
            [userDefaults setObject:@"6.1" forKey:@"class"];
            break;
        case 4:
            [userDefaults setObject:@"6.2" forKey:@"class"];
            break;
        case 5:
            [userDefaults setObject:@"6.3" forKey:@"class"];
            break;
        case 6:
            [userDefaults setObject:@"7.1" forKey:@"class"];
            break;
        case 7:
            [userDefaults setObject:@"7.2" forKey:@"class"];
            break;
        case 8:
            [userDefaults setObject:@"7.3" forKey:@"class"];
            break;
        case 9:
            [userDefaults setObject:@"8.1" forKey:@"class"];
            break;
        case 10:
            [userDefaults setObject:@"8.2" forKey:@"class"];
            break;
        case 11:
            [userDefaults setObject:@"8.3" forKey:@"class"];
            break;
        case 12:
            [userDefaults setObject:@"9.1" forKey:@"class"];
            break;
        case 13:
            [userDefaults setObject:@"9.2" forKey:@"class"];
            break;
        case 14:
            [userDefaults setObject:@"9.3" forKey:@"class"];
            break;
        case 15:
            [userDefaults setObject:@"10.1" forKey:@"class"];
            break;
        case 16:
            [userDefaults setObject:@"10.2" forKey:@"class"];
            break;
        case 17:
            [userDefaults setObject:@"10.3" forKey:@"class"];
            break;
        case 18:
            [userDefaults setObject:@"12" forKey:@"class"];
            break;
        case 19:
            [userDefaults setObject:@"13" forKey:@"class"];
            break;
        case 20:
            [userDefaults setObject:@"komplett" forKey:@"class"];
            break;
        default:
            break;
    }
    
    [userDefaults synchronize];
    //Push view
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    [[((UINavigationController *)self.slidingController.frontViewController).viewControllers objectAtIndex:0] setKlasse:[userDefaults objectForKey:@"class"]];
    [self.slidingController closeSlider:YES completion:nil];
    
}

@end
