//
//  Event.h
//  DFN
//
//  Created by Pawel Nuzka on 4/6/12.
//  Copyright (c) 2012 Pawel Nuzka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Category, EventDate, EventForm, Organisation, Place, WatchedEntities;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSString * dbID;
@property (nonatomic, retain) NSString * descriptionContent;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSDate * lastUpdate;
@property (nonatomic, retain) NSString * lecturer;
@property (nonatomic, retain) NSString * lecturersTitle;
@property (nonatomic, retain) NSString * section;
@property (nonatomic, retain) NSString * subscription;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Category *category;
@property (nonatomic, retain) NSSet *dates;
@property (nonatomic, retain) NSSet *forms;
@property (nonatomic, retain) Organisation *organisation;
@property (nonatomic, retain) Place *place;
@property (nonatomic, retain) WatchedEntities *watched;
@end

@interface Event (CoreDataGeneratedAccessors)

- (void)addDatesObject:(EventDate *)value;
- (void)removeDatesObject:(EventDate *)value;
- (void)addDates:(NSSet *)values;
- (void)removeDates:(NSSet *)values;
- (void)addFormsObject:(EventForm *)value;
- (void)removeFormsObject:(EventForm *)value;
- (void)addForms:(NSSet *)values;
- (void)removeForms:(NSSet *)values;
@end
