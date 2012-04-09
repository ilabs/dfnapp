//
//  EventForm.h
//  DFN
//
//  Created by Pawel Nuzka on 4/6/12.
//  Copyright (c) 2012 Pawel Nuzka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event, EventFormType;

@interface EventForm : NSManagedObject

@property (nonatomic, retain) NSString * dbID;
@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) EventFormType *eventFormType;

@end
