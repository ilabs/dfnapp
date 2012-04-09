//
//  EventDate.h
//  DFN
//
//  Created by Pawel Nuzka on 4/6/12.
//  Copyright (c) 2012 Pawel Nuzka. All rights reserved.
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
