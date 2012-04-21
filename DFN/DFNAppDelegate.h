//
//  AppDelegate.h
//  DFN
//
//  Created by Paweł Jankowski on 2011-12-27.
//  Copyright (c) 2011 pawelqus@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"

@interface DFNAppDelegate : NSObject <UIApplicationDelegate> {
    
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBar;
@property (nonatomic, retain) IBOutlet LoadingView *loadingView;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationLectures;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationAboutUs;
@property (readonly, retain, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, retain, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, retain, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)loadData;
- (void)loadDataAsync;
- (void)removeLoadingScreen;
- (void)dataDidLoad;
- (void)dataDidNotLoad;
- (void)showLoadingView:(BOOL)isStartup;
- (NSURL *)applicationDocumentsDirectory;
- (void)saveContext;
@end
