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
#import "SearchView.h"
#import "WatchedView.h"
#import "AboutUsView.h"
#import "SimpleSearchView.h"


@implementation DFNAppDelegate

@synthesize window = _window;
@synthesize tabBar = _tabBar;
@synthesize navigationLectures = _navigationLectures;
@synthesize navigationAboutUs = _navigationAboutUs;
@synthesize loadingView = _loadingView;
//@synthesize managedObjectContext = __managedObjectContext;
//@synthesize managedObjectModel = __managedObjectModel;
//@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_window release];
    //    [__managedObjectContext release];
    //    [__managedObjectModel release];
    //    [__persistentStoreCoordinator release];
    [super dealloc];
}

- (void)progressBar:(NSNotification *)notif;
{
    float progress = [[notif object] floatValue];
    /*NSLog(@"progress: %f", progress);
     NSMutableString * string = [NSMutableString stringWithFormat:@"|"];
     for (int i = 0; i < progress; i++)
     [string appendString:@"=>"];
     NSLog(@"%@", string);
     */
    [self.loadingView setLoadingProgress:progress];
    //[self.loadingView performSelectorOnMainThread:@selector(setLoadingProgress:) withObject:[] waitUntilDone:NO];
}

- (void)dataDidLoad {
    [UIView beginAnimations:@"Launch" context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeLoadingScreen)];
    [UIView setAnimationDuration:0.8];
    _loadingView.view.alpha = 0.0;
    [UIView commitAnimations];
}

- (void)dataDidNotLoad {
    /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Aktualizacja danych" message:@"Nie można było pobrać nowych danych." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
     [alert show];
     [alert release];
     */[self dataDidLoad];
}

- (void)removeLoadingScreen {
    [_loadingView.view removeFromSuperview];
    [_loadingView release];
    _loadingView = nil;
}

- (void)loadData {
    // [[NSNotificationCenter defaultCenter] addObserver:self 
    //                                          selector:@selector(progressBar:) name:@"DownloadProgress" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dataDidNotLoad) name:@"No connection" object:nil];
    [self loadDataAsync];
    //   [self performSelectorInBackground:@selector(loadDataAsync) withObject:nil];
}

- (void)loadDataAsync {
    @autoreleasepool {
        //   DatabaseManager *dbManager = [DatabaseManager sharedInstance];
        //[dbManager refreshState];
        DataFetcher *dataFetcher = [DataFetcher sharedInstance];
        [dataFetcher updateData];
        // [self performSelectorOnMainThread:@selector(dataDidLoad) withObject:nil waitUntilDone:NO];
        [self dataDidLoad];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor whiteColor];
    //[DatabaseManager setUpDatabase:self.persistentStoreCoordinator];
    // *** Tylko na czas debuggingu
    //DatabaseManager *m = [[DatabaseManager alloc] init];
    /*Event *e = [m createEvent];
     e.title = @"NOWY WYKLAD";
     e.lecturer = @"Ziemek, staszek, franek";
     e.lecturersTitle = @"Ziemek ma inżyniera z biofizyki, a staszek i franek po doktorze w lekkoatletyce";
     e.place = [m createPlace];
     e.place.gpsCoordinates = @"51.844252,16.598943";
     e.organisation = [m createOrganisation];
     e.organisation.name = @"Wyższa Szkoła chuj\r\nI druga linijka jakby co";
     e.place.address = @"ul. Kup mi buty za 5 złoty \r\nKoło starego baru mlecznego";
     e.place.city = @"Zdżebłaszowykotywice";
     //[e addDates:[[NSSet alloc] initWithObjects:[[NSDate alloc] initWithTimeIntervalSinceNow:0],[[NSDate alloc] initWithTimeIntervalSinceNow:12890], nil]];
     e.place.numberOfFreePlaces = @"1267";
     LectureView *obserwowane = [[LectureView alloc] initWithNibName:@"LectureView" bundle:nil lecture:e]; // ofc to trzebaby bylo zwolnic, ale to tak na testy tylko
     */// ***
    
    MainCategoryListView *mainView = [[[MainCategoryListView alloc] initWithNibName:@"MainCategoryListView" bundle:nil] autorelease];
    UIViewController *obserwowane = [[[WatchedView alloc] initWithNibName:@"WatchedView" bundle:nil] autorelease];
    SimpleSearchView *search = [[[SimpleSearchView alloc] initWithNibName:@"SimpleSearchView" bundle:nil] autorelease];
    
    _navigationLectures = [[[UINavigationController alloc] initWithRootViewController:mainView] autorelease];
    UINavigationController *obserwNav = [[[UINavigationController alloc] initWithRootViewController:obserwowane] autorelease];
    UINavigationController *searchNav = [[[UINavigationController alloc] initWithRootViewController:search] autorelease];
    _navigationLectures.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    obserwNav.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    searchNav.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    _tabBar = [[[UITabBarController alloc] init] autorelease];
    
    // Buttony na TabBar
    UITabBarItem *item1 = [[[UITabBarItem alloc] initWithTitle:@"Wykłady" image:[UIImage imageNamed:@"logo2.png"] tag:0] autorelease];
    UITabBarItem *item2 = [[[UITabBarItem alloc] initWithTitle:@"Obserwowane" image:[UIImage imageNamed:@"logo2.png"] tag:1] autorelease];
    UITabBarItem *item3 = [[[UITabBarItem alloc] initWithTitle:@"Szukaj" image:[UIImage imageNamed:@"logo2.png"] tag:2] autorelease];
    
    // Ustawiamy dla kazdego view buttona
    _navigationLectures.tabBarItem = item1;
    obserwNav.tabBarItem = item2;
    searchNav.tabBarItem = item3;
    
    // Zeby bylo widac tlo, ustawiamy odpowiednio background naszego widoku (mozna tez dac w viewDidLoad)
    _navigationLectures.view.backgroundColor = [UIColor clearColor];
    mainView.view.backgroundColor = [UIColor clearColor];
    obserwNav.view.backgroundColor = [UIColor clearColor];
    searchNav.view.backgroundColor = [UIColor clearColor];
    search.view.backgroundColor = [UIColor clearColor];
    
    // Dodajemy widoki do listy
    NSMutableArray *views = [[[NSMutableArray alloc] init] autorelease];
    [views addObject:_navigationLectures];
    [views addObject:obserwNav];
    [views addObject:searchNav];
    
    [_tabBar setViewControllers:views];
    
    // Customize TabBar
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background@2x.png"]];
    [_tabBar.view insertSubview:imageView atIndex:0];
    [imageView release];
    
    self.window.rootViewController = _tabBar;
    [self.window addSubview:[_tabBar view]];
    
    // Loading view commituje krotka animacja i wywoluje (void)loadData
    [self showLoadingView:YES];
    
    // To co tu bylo jest teraz w -loadData!
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)showLoadingView:(BOOL)isStartup {
    // Loading view commituje krotka animacja i wywoluje (void)loadData
    _loadingView = [[LoadingView alloc] initWithNibName:@"LoadingView" bundle:nil];
    _loadingView.animatedStart = isStartup;
    [self.window addSubview:_loadingView.view];
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
    //    [self saveContext];
}

//- (void)saveContext
//{
//    NSError *error = nil;
//    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
//    if (managedObjectContext != nil)
//    {
//        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
//        {
//            /*
//             Replace this implementation with code to handle the error appropriately.
//             
//             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
//             */
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//            abort();
//        } 
//    }
//}

#pragma mark - Core Data stack

///**
// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
// */
//- (NSManagedObjectContext *)managedObjectContext
//{
//    if (__managedObjectContext != nil)
//    {
//        return __managedObjectContext;
//    }
//    
//    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
//    if (coordinator != nil)
//    {
//        __managedObjectContext = [[NSManagedObjectContext alloc] init];
//        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
//    }
//    return __managedObjectContext;
//}
//
///**
// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
// */
//- (NSManagedObjectModel *)managedObjectModel {
//    
//    if (__managedObjectModel != nil) {
//        return __managedObjectModel;
//    }
//    __managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
//    return __managedObjectModel;
//}
///**
// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
// */
//- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
//{
//    if (__persistentStoreCoordinator != nil)
//    {
//        return __persistentStoreCoordinator;
//    }
//    
//    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"DFN.sqlite"];
//    
//    NSError *error = nil;
//    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
//    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
//    {
//        /*
//         Replace this implementation with code to handle the error appropriately.
//         
//         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
//         
//         Typical reasons for an error here include:
//         * The persistent store is not accessible;
//         * The schema for the persistent store is incompatible with current managed object model.
//         Check the error message to determine what the actual problem was.
//         
//         
//         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
//         
//         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
//         * Simply deleting the existing store:
//         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
//         
//         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
//         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
//         
//         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
//         
//         */
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
//    }    
//    
//    return __persistentStoreCoordinator;
//}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
//- (NSURL *)applicationDocumentsDirectory
//{
//    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
//}

@end
