//
//  EventDate.h
//  DFN
//
//  Created by Pawel Nuzka on 3/17/12.
//  Copyright (c) 2012 pawel.jankowski@me.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface EventDate : NSManagedObject

@property (nonatomic, retain) NSDate * closingHour;
@property (nonatomic, retain) NSDate * day;
@property (nonatomic, retain) NSString * dbID;
@property (nonatomic, retain) NSDate * lastUpdate;
@property (nonatomic, retain) NSDate * openingHour;
@property (nonatomic, retain) Event *event;

@end
