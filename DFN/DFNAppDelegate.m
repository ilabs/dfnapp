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



@implementation DFNAppDelegate

@synthesize window = _window;
@synthesize tabBar = _tabBar;
@synthesize navigationController = _nav;
@synthesize loadingView = _loadingView;


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_window release];
    [super dealloc];
}

- (void)progressBar:(NSNotification *)notif;
{
    float progress = [[notif object] floatValue];
    NSLog(@"progress: %f", progress);
    NSMutableString * string = [NSMutableString stringWithFormat:@"|"];
    for (int i = 0; i < progress; i++)
        [string appendString:@"=>"];
    NSLog(@"%@", string);
     
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Aktualizacja danych" message:@"Nie można było pobrać nowych danych." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    [alert release];
    [self dataDidLoad];
}

- (void)removeLoadingScreen {
    [_loadingView.view removeFromSuperview];
    [_loadingView release];
    _loadingView = nil;
}

- (void)loadData {
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(progressBar:) name:@"DownloadProgress" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dataDidNotLoad:) name:@"No connection" object:nil];
    
    [self performSelectorInBackground:@selector(loadDataAsync) withObject:nil];
}

- (void)loadDataAsync {
    DataFetcher *dataFetcher = [DataFetcher sharedInstance];
    [dataFetcher updateData];
    [self dataDidLoad];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor whiteColor];
    
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
    SearchView *search = [[[SearchView alloc] init] autorelease];
    
    _nav = [[[UINavigationController alloc] initWithRootViewController:mainView] autorelease];
    UINavigationController *obserwNav = [[[UINavigationController alloc] initWithRootViewController:obserwowane] autorelease];
    _nav.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    obserwNav.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    
    _tabBar = [[[UITabBarController alloc] init] autorelease];
    
    // Buttony na TabBar
    UITabBarItem *item1 = [[[UITabBarItem alloc] initWithTitle:@"Wykłady" image:[UIImage imageNamed:@"logo2.png"] tag:0] autorelease];
    UITabBarItem *item2 = [[[UITabBarItem alloc] initWithTitle:@"Obserwowane" image:[UIImage imageNamed:@"logo2.png"] tag:1] autorelease];
    UITabBarItem *item3 = [[[UITabBarItem alloc] initWithTitle:@"Szukaj" image:[UIImage imageNamed:@"logo2.png"] tag:2] autorelease];
    
    // Ustawiamy dla kazdego view buttona
    _nav.tabBarItem = item1;
    obserwNav.tabBarItem = item2;
    search.tabBarItem = item3;
    
    // Zeby bylo widac tlo, ustawiamy odpowiednio background naszego widoku (mozna tez dac w viewDidLoad)
    _nav.view.backgroundColor = [UIColor clearColor];
    mainView.view.backgroundColor = [UIColor clearColor];
    obserwNav.view.backgroundColor = [UIColor clearColor];
    search.view.backgroundColor = [UIColor clearColor];
    
    // Dodajemy widoki do listy
    NSMutableArray *views = [[[NSMutableArray alloc] init] autorelease];
    [views addObject:_nav];
    [views addObject:obserwNav];
    [views addObject:search];
    
    [_tabBar setViewControllers:views];
    
    // Customize TabBar
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background@2x.png"]];
    [_tabBar.view insertSubview:imageView atIndex:0];
    [imageView release];
    
    self.window.rootViewController = _tabBar;
    [self.window addSubview:[_tabBar view]];
    
    // Loading view commituje krotka animacja i wywoluje (void)loadData
    _loadingView = [[LoadingView alloc] initWithNibName:@"LoadingView" bundle:nil];
    [self.window addSubview:_loadingView.view];
    
    // To co tu bylo jest teraz w -loadData!
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
