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
@synthesize tabBar = _tabBar;


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
    DatabaseManager *m = [[DatabaseManager alloc] init];
    Event *e = [m createEvent];
    e.title = @"NOWY WYKLAD";
    e.lecturer = @"Ziemek, staszek, franek";
    LectureView *obserwowane = [[LectureView alloc] initWithNibName:@"LectureView" bundle:nil lecture:e]; // ofc to trzebaby bylo zwolnic, ale to tak na testy tylko
    // ***
    
    MainCategoryListView *mainView = [[[MainCategoryListView alloc] initWithNibName:@"MainCategoryListView" bundle:nil] autorelease];
    //UIViewController *obserwowane = [[[UIViewController alloc] init] autorelease];
    UIViewController *ustawienia = [[[UIViewController alloc] init] autorelease];
    
    _tabBar = [[[UITabBarController alloc] init] autorelease];
    
    // Buttony na TabBar
    UITabBarItem *item1 = [[UITabBarItem alloc] initWithTitle:@"Wykłady" image:[UIImage imageNamed:@"logo2.png"] tag:0];
    UITabBarItem *item2 = [[UITabBarItem alloc] initWithTitle:@"Obserwowane" image:[UIImage imageNamed:@"logo2.png"] tag:1];
    UITabBarItem *item3 = [[UITabBarItem alloc] initWithTitle:@"Ustawienia" image:[UIImage imageNamed:@"logo2.png"] tag:2];

    // Ustawiamy dla kazdego view buttona
    mainView.tabBarItem = item1;
    obserwowane.tabBarItem = item2;
    ustawienia.tabBarItem = item3;
    
    // Zeby bylo widac tlo, ustawiamy odpowiednio background naszego widoku (mozna tez dac w viewDidLoad)
    mainView.view.backgroundColor = [UIColor clearColor];
    obserwowane.view.backgroundColor = [UIColor clearColor];
    ustawienia.view.backgroundColor = [UIColor clearColor];
    
    // Dodajemy widoki do listy
    NSMutableArray *views = [[NSMutableArray alloc] init];
    [views addObject:mainView];
    [views addObject:obserwowane];
    [views addObject:ustawienia];
    
    [_tabBar setViewControllers:views];
    
    // Customize TabBar
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    [_tabBar.view insertSubview:imageView atIndex:0];
    [imageView release];
    
    self.window.rootViewController = _tabBar;
    [self.window addSubview:[_tabBar view]];
    
    // *** do testowania 
    //MainCategoryListView *mainCategoryList = [[MainCategoryListView alloc] initWithNibName:@"MainCategoryListView" bundle:nil]; //podobno trzeba zwolnić, ale to tylko na testy
    //[self.window addSubview:[mainCategoryList view]];
    
    // *** do testowania
    //SubCategoryListView *subCategoryListView = [[SubCategoryListView alloc] initWithNibName:@"SubCategoryListView" bundle:nil]; //trzeba zwolnić, ale to tylko do testów
    //[self.window addSubview:[subCategoryListView view]];
    
    DataFetcher *dataFetcher = [DataFetcher sharedInstance];
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
