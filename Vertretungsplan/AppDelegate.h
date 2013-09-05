//
//  AppDelegate.h
//  Vertretungsplan
//
//  Created by Carl Ambroselli on 03.09.13.
//  Copyright (c) 2013 carlambroselli. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JSSlidingViewController.h"
#import "TableViewController.h"
#import "LeftViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, MenuButtonDelegate, JSSlidingViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) JSSlidingViewController *viewController;
@property (strong, nonatomic) LeftViewController *backVC;
@property (strong, nonatomic) TableViewController *frontVC;

@end
