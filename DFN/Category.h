//
//  Category.h
//  DFN
//
//  Created by Pawel Nuzka on 6/3/12.
//  Copyright (c) 2012 pawel.jankowski@me.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface Category : NSManagedObject

@property (nonatomic, retain) NSString * dbID;
@property (nonatomic, retain) NSDate * lastUpdate;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * year;
@property (nonatomic, retain) NSSet *events;
@property (nonatomic, retain) NSManagedObject *section;
@end

@interface Category (CoreDataGeneratedAccessors)

- (void)addEventsObject:(Event *)value;
- (void)removeEventsObject:(Event *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;
@end
