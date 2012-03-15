//
//  Category.h
//  DFN
//
//  Created by Pawel Nuzka on 2/19/12.
//  Copyright (c) 2012 pawelqus@gmail.com All rights reserved.
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
@end

@interface Category (CoreDataGeneratedAccessors)

- (void)addEventsObject:(Event *)value;
- (void)removeEventsObject:(Event *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

@end
