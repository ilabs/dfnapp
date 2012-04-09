//
//  WatchedEntities.h
//  DFN
//
//  Created by Pawel Nuzka on 4/6/12.
//  Copyright (c) 2012 Pawel.Nuzka@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface WatchedEntities : NSManagedObject

@property (nonatomic, retain) NSSet *watched;
@end

@interface WatchedEntities (CoreDataGeneratedAccessors)

- (void)addWatchedObject:(Event *)value;
- (void)removeWatchedObject:(Event *)value;
- (void)addWatched:(NSSet *)values;
- (void)removeWatched:(NSSet *)values;
@end
