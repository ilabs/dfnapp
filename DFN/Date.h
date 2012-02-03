//
//  Date.h
//  DFN
//
//  Created by Pawel Nuzka on 2/3/12.
//  Copyright (c) 2012 pawel.jankowski@me.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface Date : NSManagedObject

@property (nonatomic, retain) NSDate * closing_hour;
@property (nonatomic, retain) NSDate * day;
@property (nonatomic, retain) NSDate * last_update;
@property (nonatomic, retain) NSDate * opening_hour;
@property (nonatomic, retain) NSString * dbID;
@property (nonatomic, retain) Event *event;

@end
