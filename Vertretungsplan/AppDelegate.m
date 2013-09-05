//
//  AppDelegate.m
//  Vertretungsplan
//
//  Created by Carl Ambroselli on 03.09.13.
//  Copyright (c) 2013 carlambroselli. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize frontVC, backVC;

#pragma mark - JSSlidingViewControllerDelegate

- (BOOL)slidingViewController:(JSSlidingViewController *)viewController shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientationsForSlidingViewController:(JSSlidingViewController *)viewController {
    return UIInterfaceOrientationMaskAll;
}

#pragma mark - Convenience

- (void)menuButtonPressed:(id)sender {
    if (self.viewController.isOpen == NO) {
        [self.viewController openSlider:YES completion:nil];
    } else {
        [self.viewController closeSlider:YES completion:nil];
    }
}

- (void)lockSlider {
    self.viewController.locked = YES;
}

- (void)unlockSlider {
    self.viewController.locked = NO;
}

#pragma mark - App Delegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle: nil];
    
    self.frontVC = (TableViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"TableView"];
    self.frontVC.delegate = self;
    UINavigationController *navCont = [[UINavigationController alloc] initWithRootViewController:self.frontVC];
    
    self.backVC = (LeftViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"LeftView"];
    
    self.viewController = [[JSSlidingViewController alloc] initWithFrontViewController:navCont backViewController:self.backVC];
    self.viewController.delegate = self;
    
    self.backVC.slidingController = self.viewController;
    
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
