//
//  LeftViewController.h
//  Vertretungsplan
//
//  Created by Carl Ambroselli on 03.09.13.
//  Copyright (c) 2013 carlambroselli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSSlidingViewController.h"

@interface LeftViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) JSSlidingViewController *slidingController;

@end
