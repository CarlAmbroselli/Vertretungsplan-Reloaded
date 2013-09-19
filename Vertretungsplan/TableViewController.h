//
//  TableViewController.h
//  Vertretungsplan
//
//  Created by Carl Ambroselli on 03.09.13.
//  Copyright (c) 2013 carlambroselli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"

@protocol MenuButtonDelegate;

@interface TableViewController : CoreDataTableViewController

@property (nonatomic, weak) id <MenuButtonDelegate> delegate;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSString *klasse;
@property (strong, nonatomic) UIView *noChangesView;

@end

@protocol MenuButtonDelegate <NSObject>

- (void)menuButtonPressed:(id)sender;
- (void)lockSlider;
- (void)unlockSlider;

@end