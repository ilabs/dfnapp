//
//  EventForm.h
//  DFN
//
//  Created by Pawel Nuzka on 3/30/12.
//  Copyright (c) 2012 pawel.jankowski@me.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface EventForm : NSManagedObject

@property (nonatomic, retain) NSString * dbID;
@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) NSManagedObject *eventFormType;

@end
