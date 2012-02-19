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
- (NSInteger) getFormsCount;
- (NSInteger) getPlacesCount;
- (NSInteger) getDatesCountForEvent:(Event *)event;
//
- (NSArray *) getAllCategories;
- (NSArray *) getAllOrganisations;
- (NSArray *) getAllPlaces;
- (NSArray *) getAllForms;
- (NSArray *) getALlEventsForCategory:(Category *)category;
- (NSArray *) getAllDatesForEvent:(Event *)event;
- (NSArray *) getAllEventsForData:(NSDate *)date;
- (NSArray *) getAllEventsAfterDay:(NSDate *)day;
- (NSArray *) getAllEventsForCity:(NSString *)city;
- (NSArray *) getAllEventsForPlace:(Place *)place;
- (NSArray *) getAllEventsForLecturer:(NSString *)lecturer;
- (NSArray *) getAllEventsForAddress:(NSString *)address;
//
- (Event *) createEvent;
- (Form *) createForm;
- (Category *)createCategory;
- (Place *) createPlace;
- (Organisation *) createOrganisation;
- (Date *) createDate;
- (void)addEvent:(Event *)event toCategory:(Category *)category;
- (void)addPlace:(Place *)place toEvent:(Event *)event;
- (void)addOrganisation:(Organisation *)organisation toEvent:(Event *)event;
- (void)addDate:(Date *)date toEvent:(Event *)event;
- (void)addForm:(Form *)form toEvent:(Event *)event;
//
- (Event *)getEventById:(NSString *)ID;
- (Date *)getDateById:(NSString *)ID;
- (Place *)getPlaceById:(NSString *)ID;
- (Organisation *)getOrganistationById:(NSString *)ID;
- (Form *)getFormById:(NSString *)ID;
- (Category *)getCategoryById:(NSString *)ID;
//
- (void)removeEvent:(Event *)event;
- (void)removeEventById:(NSString *)ID;
- (void)removeForm:(Form *)form;
- (void)removeFormById:(NSString *)ID;
- (void)removeOrganisation:(Organisation *)organisation;
- (void)removeOrganisationById:(NSString *)ID;
- (void)removePlace:(Place *)place;
- (void)removePlaceById:(NSString *)ID;
- (void)removeDate:(Date *)date;
- (void)removeDateById:(NSString *)ID;
- (void)removeCategory:(Category *)category;
- (void)removeCategoryById:(NSString *)ID;
@end
