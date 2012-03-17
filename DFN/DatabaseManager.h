//
//  Database.h
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


@interface DatabaseManager : NSObject
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

//********************************************************************************************************
+(id)sharedInstance;
//********************************************************************************************************
- (void)saveDatabase;
- (NSURL *)applicationDocumentsDirectory;
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
- (NSInteger) getDatesCountForEvent:(Event *)event;
//
- (NSArray *) getAllCategories;
- (NSArray *) getAllOrganisations;
- (NSArray *) getAllPlaces;
- (NSArray *) getAllEventForms;
- (NSArray *) getALlEventsForCategory:(Category *)category;
- (NSArray *) getAllDatesForEvent:(Event *)event;
- (NSArray *) getAllEventsForEventDate:(NSDate *)date;
- (NSArray *) getAllEventsAfterDay:(NSDate *)day;
- (NSArray *) getAllEventsForCity:(NSString *)city;
- (NSArray *) getAllEventsForPlace:(Place *)place;
- (NSArray *) getAllEventsForLecturer:(NSString *)lecturer;
- (NSArray *) getAllEventsForAddress:(NSString *)address;
//
- (Event *) createEvent;
- (EventForm *) createForm;
- (Category *)createCategory;
- (Place *) createPlace;
- (Organisation *) createOrganisation;
- (EventDate *) createDate;
- (void)addEvent:(Event *)event toCategory:(Category *)category;
- (void)addPlace:(Place *)place toEvent:(Event *)event;
- (void)addOrganisation:(Organisation *)organisation toEvent:(Event *)event;
- (void)addDate:(EventDate *)date toEvent:(Event *)event;
- (void)addForm:(EventForm *)form toEvent:(Event *)event;
//
- (Event *)getEventById:(NSString *)ID;
- (EventDate *)getDateById:(NSString *)ID;
- (Place *)getPlaceById:(NSString *)ID;
- (Organisation *)getOrganistationById:(NSString *)ID;
- (EventForm *)getFormById:(NSString *)ID;
- (Category *)getCategoryById:(NSString *)ID;
//
- (void)removeEvent:(Event *)event;
- (void)removeEventById:(NSString *)ID;
- (void)removeForm:(EventForm *)form;
- (void)removeFormById:(NSString *)ID;
- (void)removeOrganisation:(Organisation *)organisation;
- (void)removeOrganisationById:(NSString *)ID;
- (void)removePlace:(Place *)place;
- (void)removePlaceById:(NSString *)ID;
- (void)removeDate:(EventDate *)date;
- (void)removeDateById:(NSString *)ID;
- (void)removeCategory:(Category *)category;
- (void)removeCategoryById:(NSString *)ID;
@end
