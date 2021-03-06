//
//  Place.h
//  DFN
//
//  Created by Pawel Nuzka on 4/6/12.
//  Copyright (c) 2012 Pawel.Nuzka@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface Place : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * dbID;
@property (nonatomic, retain) NSString * gpsCoordinates;
@property (nonatomic, retain) NSDate * lastUpdate;
@property (nonatomic, retain) NSString * numberOfFreePlaces;
@property (nonatomic, retain) NSSet *event;
@end

@interface Place (CoreDataGeneratedAccessors)

- (void)addEventObject:(Event *)value;
- (void)removeEventObject:(Event *)value;
- (void)addEvent:(NSSet *)values;
- (void)removeEvent:(NSSet *)values;
@end
