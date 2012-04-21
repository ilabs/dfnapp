//
//  Event.h
//  DFN
//
//  Created by Pawel Nuzka on 4/21/12.
//  Copyright (c) 2012 pawel.jankowski@me.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Category, EventDate, EventForm, Organisation, Place, WatchedEntities;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSString * dbID;
@property (nonatomic, retain) NSString * descriptionContent;
@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSDate * lastUpdate;
@property (nonatomic, retain) NSString * lecturer;
@property (nonatomic, retain) NSString * lecturersTitle;
@property (nonatomic, retain) NSString * section;
@property (nonatomic, retain) NSString * subscription;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * showAsUpdated;
@property (nonatomic, retain) Category *category;
@property (nonatomic, retain) NSSet *dates;
@property (nonatomic, retain) NSSet *forms;
@property (nonatomic, retain) Organisation *organisation;
@property (nonatomic, retain) Place *place;
@property (nonatomic, retain) WatchedEntities *watched;
@property (nonatomic, retain) NSSet *subscribedDates;
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
- (void)addSubscribedDatesObject:(EventDate *)value;
- (void)removeSubscribedDatesObject:(EventDate *)value;
- (void)addSubscribedDates:(NSSet *)values;
- (void)removeSubscribedDates:(NSSet *)values;
@end
