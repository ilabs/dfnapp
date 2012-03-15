//
//  EventForm.h
//  DFN
//
//  Created by Pawel Nuzka on 2/19/12.
//  Copyright (c) 2012 pawelqus@gmail.com All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface EventForm : NSManagedObject

@property (nonatomic, retain) NSString * dbID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Event *event;

@end
