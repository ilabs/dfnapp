//
//  Organisation.h
//  DFN
//
//  Created by Pawel Nuzka on 4/6/12.
//  Copyright (c) 2012 Pawel.Nuzka@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface Organisation : NSManagedObject

@property (nonatomic, retain) NSString * dbID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *events;
@end

@interface Organisation (CoreDataGeneratedAccessors)

- (void)addEventsObject:(Event *)value;
- (void)removeEventsObject:(Event *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;
@end
