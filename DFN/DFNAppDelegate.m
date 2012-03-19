//
//  AppDelegate.m
//  DFN
//
//  Created by Paweł Jankowski on 2011-12-27.
//  Copyright (c) 2011 pawelqus@gmail.com. All rights reserved.
//

#import "DFNAppDelegate.h"
#import "LectureView.h"
#import "DataFetcher.h"
#import "MainCategoryListView.h"
#import "SubCategoryListView.h"

@implementation DFNAppDelegate

@synthesize window = _window;


- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor whiteColor];
    
    // *** Tylko na czas debuggingu
    //LectureView *lecture = [[LectureView alloc] initWithNibName:@"LectureView" bundle:nil]; // ofc to trzebaby bylo zwolnic, ale to tak na testy tylko
    //[self.window addSubview:[lecture view]];
    
    // *** do testowania 
    //MainCategoryListView *mainCategoryList = [[MainCategoryListView alloc] initWithNibName:@"MainCategoryListView" bundle:nil]; //podobno trzeba zwolnić, ale to tylko na testy
    //[self.window addSubview:[mainCategoryList view]];
    DataFetcher *dataFetcher = [DataFetcher sharedInstance];
    
    // *** do testowania
    //SubCategoryListView *subCategoryListView = [[SubCategoryListView alloc] initWithNibName:@"SubCategoryListView" bundle:nil]; //trzeba zwolnić, ale to tylko do testów
    //[self.window addSubview:[subCategoryListView view]];
    
    [dataFetcher updateData];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
}



@end
