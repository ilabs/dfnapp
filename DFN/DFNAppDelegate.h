//
//  AppDelegate.h
//  DFN
//
//  Created by Paweł Jankowski on 2011-12-27.
//  Copyright (c) 2011 pawel.jankowski@me.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DFNAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
