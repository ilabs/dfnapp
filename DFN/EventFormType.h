//
//  EventFormType.h
//  DFN
//
//  Created by Pawel Nuzka on 4/6/12.
//  Copyright (c) 2012 Pawel Nuzka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EventForm;

@interface EventFormType : NSManagedObject

@property (nonatomic, retain) NSString * dbID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *eventForms;
@end

@interface EventFormType (CoreDataGeneratedAccessors)

- (void)addEventFormsObject:(EventForm *)value;
- (void)removeEventFormsObject:(EventForm *)value;
- (void)addEventForms:(NSSet *)values;
- (void)removeEventForms:(NSSet *)values;
@end
