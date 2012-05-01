//
//  DatabaseManager.h
//  DFN
//
//  Created by Pawel Nuzka on 2/3/12.
//  Copyright (c) 2012 pawelqus@gmail.com All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"
#import "EventForm.h"
#import "Category.h"
#import "Place.h"
#import "Organisation.h"
#import "EventDate.h"
#import "EventFormType.h"

@interface DatabaseManager : NSObject {
    NSManagedObjectContext *managedObjectContext;
    NSManagedObjectModel *managedObjectModel;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    
}
//********************************************************************************************************
+(void)setUpDatabase:(NSPersistentStoreCoordinator *)_persistentStoreCoordinator;
+(id)sharedInstance;
-(void)refreshState;
//********************************************************************************************************
- (void)saveDatabase;
- (NSString *) databasePath;
//********************************************************************************************************
- (NSArray *)fetchedManagedObjectsForEntity:(NSString *)entityName withPredicate:(NSPredicate *)predicate;
- (void)removeEntity:(NSManagedObject *)entity;
//********************************************************************************************************
// Potrzebne dla delegatów UITableView datasource
- (NSInteger) getEventsCountForCategory:(Category *)category;
- (NSInteger) getCategoriesCount;
- (NSInteger) getOrganisationsCount;
- (NSInteger) getEventFormsCount;
- (NSInteger) getPlacesCount;
- (NSInteger) getEventDatesCountForEvent:(Event *)event;
//
- (NSArray *) getAllCategories;
- (NSArray *) getAllOrganisations;
- (NSArray *) getAllPlaces;
- (NSArray *) getAllEventForms;
- (NSArray *) getAllEventsForCategory:(Category *)category;
- (NSArray *) getAllDatesForEvent:(Event *)event;
- (NSArray *) getAllEventsForEventDate:(NSDate *)date;
- (NSArray *) getAllEventsAfterDay:(NSDate *)day;
- (NSArray *) getAllEventsForCity:(NSString *)city;
- (NSArray *) getAllEventsForPlace:(Place *)place;
- (NSArray *) getAllEventsForLecturer:(NSString *)lecturer;
- (NSArray *) getAllEventsForAddress:(NSString *)address;
- (NSArray *) getAllWatched;
- (NSArray *)  getAllSubscribed;
- (BOOL)isWatched:(Event *)event;

//
- (Event *) createEvent;
- (EventForm *) createEventForm;
- (EventFormType *) createEventFormType;
- (Category *)createCategory;
- (Place *) createPlace;
- (Organisation *) createOrganisation;
- (EventDate *) createEventDate;
- (void)addToWatchedEntities:(Event *)event;
- (void)removeFromWatchedEntities:(Event *)event;
- (void)addToSubscribedEntities:(EventDate *)eventDate;
- (void)removeFromSubscribedEntities:(EventDate *)eventDate;
- (BOOL)isSubscribed:(Event *)event;
- (BOOL)isEventDateSubscribed:(EventDate *)eventDate;
- (BOOL)hasAlreadySubscribedAtDate:(NSDate *)date;
- (BOOL)hasAlreadySubscribedAtDay:(NSDate *)day andOpeningHour:(NSDate *)openingHour;
//- (void)addEvent:(Event *)event toCategory:(Category *)category;
//- (void)addPlace:(Place *)place toEvent:(Event *)event;
//- (void)addOrganisation:(Organisation *)organisation toEvent:(Event *)event;
//- (void)addDate:(EventDate *)date toEvent:(Event *)event;
//- (void)addForm:(EventForm *)form toEvent:(Event *)event;
//
- (Event *)getEventWithId:(NSString *)ID;
- (EventDate *)getEventDateWithId:(NSString *)ID;
- (Place *)getPlaceWithId:(NSString *)ID;
- (Organisation *)getOrganistationWithId:(NSString *)ID;
- (EventForm *)getEventFormWithId:(NSString *)ID;
- (EventFormType *)getEventFormTypeWithId:(NSString *)ID;
- (Category *)getCategoryWithId:(NSString *)ID;
//
- (void)removeEvent:(Event *)event;
- (void)removeEventWithId:(NSString *)ID;
- (void)removeEventForm:(EventForm *)form;
- (void)removeEventFormWithId:(NSString *)ID;
- (void)removeEventFormTypeWithId:(NSString *)ID;
- (void)removeOrganisation:(Organisation *)organisation;
- (void)removeOrganisationWithId:(NSString *)ID;
- (void)removePlace:(Place *)place;
- (void)removePlaceWithId:(NSString *)ID;
- (void)removeEventDate:(EventDate *)date;
- (void)removeEventDateWithId:(NSString *)ID;
- (void)removeCategory:(Category *)category;
- (void)removeCategoryWithId:(NSString *)ID;
//
- (int)getNumberOfEventsChecksums;
- (int)getNumberOfEventsDatesChecksums;
- (void)setNumberOfEventsChecksums:(int)number;
- (void)setNumberOfEventsDatesChecksums:(int)number;
- (void)saveChecksum:(NSString *)md5 withEventsNumber:(int)eventsNumber;
- (void)saveChecksum:(NSString *)md5 withEventsDatesNumber:(int)eventsDateNumber;
- (void)removeAllEventsChecksums;
- (void)removeAllEventDatesChecksums;
- (NSString *)getChecksumWithEventNumber:(int)eventNumber;
- (NSString *)getChecksumWithEventDatesNumber:(int)eventDatesNumber;
- (NSString *)getLastEventsChecksum;
- (NSString *)getLastEventsDatesChecksum;
- (void)setLastEventsChecksum:(NSString *)checksum;
- (void)setLastEventsDatesChecksum:(NSString *)checksum;

@end
