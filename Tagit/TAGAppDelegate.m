//
//  TAGAppDelegate.m
//  Tagit
//
//  Created by Shane Rogers on 8/2/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGAppDelegate.h"
#import "TAGLoginViewController.h"
#import "TAGTagsViewController.h"

#import "TAGStyleConstants.h"

@implementation TAGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    TAGLoginViewController *loginViewController = [[TAGLoginViewController alloc]init];
    [[self window] setRootViewController:loginViewController];

    self.window.backgroundColor = [UIColor whiteColor];
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

- (void)initializeNavigationControllers{
    TAGTagsViewController *feedViewController = [TAGTagsViewController new];

    UINavigationController *tagFeedViewNavController = [[UINavigationController alloc]initWithRootViewController:feedViewController];

    UITabBarController *tagTabBarController = [UITabBarController new];

    [tagTabBarController setViewControllers:@[tagFeedViewNavController]];
    [self styleTabBar:tagTabBarController.tabBar];

    [[self window] setRootViewController:tagTabBarController];
}

- (void)styleTabBar:(UITabBar *)tabBar {
    [[UITabBar appearance] setBarTintColor:kTagitBlue];
    [[UITabBar appearance] setSelectedImageTintColor:kPureWhite];
    NSArray *tabBarTitlesMap = @[@"Feed"];
    NSArray *tabBarImagesMap = @[@"tag"];

    [[tabBar items] enumerateObjectsUsingBlock:^(UITabBarItem *item, NSUInteger index, BOOL *stop){
        [self setTabItemImages:item withTitle:[tabBarTitlesMap objectAtIndex:index] andImageName:[tabBarImagesMap objectAtIndex:index]];
    }];
}

- (void)setTabItemImages:(UITabBarItem *)item withTitle:(NSString *)title andImageName:(NSString *)imageName {
    [item setTitle:title];
    [item setImage:[[UIImage imageNamed:[imageName stringByAppendingString:@"Unselected.png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item setSelectedImage:[[UIImage imageNamed:[imageName stringByAppendingString:@"Selected.png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item setTitleTextAttributes:@{ NSForegroundColorAttributeName : kTagitDeselectedGrey } forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{ NSForegroundColorAttributeName : kPureWhite } forState:UIControlStateHighlighted];
    [item setTitleTextAttributes:@{ NSForegroundColorAttributeName : kPureWhite, NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:14.0] } forState:UIControlStateNormal];
};

@end
