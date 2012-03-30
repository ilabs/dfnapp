//
//  Database.m
//  DFN
//
//  Created by Pawel Nuzka on 2/3/12.
//  Copyright (c) 2012 pawelqus@gmail.com. All rights reserved.
//

#import "DatabaseManager.h"

@interface DatabaseManager ()

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
- (NSString *)applicationDocumentsDirectory;

@end

@implementation DatabaseManager

+ (id)sharedInstance
{
    static id master = nil;
    
    @synchronized(self)
    {
        if (master == nil)
            master = [self new];
    }
    return master;
}

-(NSString *) databasePath
{
    return [[self  applicationDocumentsDirectory] stringByAppendingPathComponent:@"DFN.sqlite"];
}
- (NSString *)applicationDocumentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (managedObjectContext != nil)
    {
        return managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (managedObjectModel != nil)
    {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (persistentStoreCoordinator != nil)
    {
        return persistentStoreCoordinator;
    }
    
    NSString *path = [self databasePath];
    NSURL *storeURL = [NSURL fileURLWithPath:path];
    
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        return nil;
    }    
    
    return persistentStoreCoordinator;
}

//**Saving database
- (void)saveDatabase
{
    NSError *error = nil;
    if (managedObjectContext != nil)
    {
        if([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


- (void)removeEntity:(NSManagedObject *)entity
{
    if(entity)
    {
        [self.managedObjectContext deleteObject:entity];
        [self saveDatabase];
    }
}
//*Fetching queries from database;
- (NSArray *)fetchedManagedObjectsForEntity:(NSString *)entityName withPredicate:(NSPredicate *)predicate
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = entity;
    request.predicate = predicate;
    
    NSArray *results = [context executeFetchRequest:request error:nil];
    [request release];
    if ((results != nil) && ([results count] == 0))
        results = nil;
    return results;
}
- (NSArray *)fetchedManagedObjectsForEntity:(NSString *)entityName withPredicate:(NSPredicate *)predicate withSortingByKey:(NSString *)key
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setSortDescriptors:sortDescriptors];
    request.entity = entity;
    
    if(predicate != nil)
        [request setPredicate:predicate];
    
    NSArray *results = [context executeFetchRequest:request error:nil];
    [request release];
    if ((results != nil) && ([results count] == 0))
        results = nil;
    [sortDescriptor autorelease];
    [sortDescriptors autorelease];
    return results;
}

-(NSManagedObject *) getEntity:(NSString *)entity withId:(NSString *)entityId
{
    NSArray *foundEntity = [self fetchedManagedObjectsForEntity:entity withPredicate:[NSPredicate predicateWithFormat:@"dbID == %@", entityId]];
    NSManagedObject *result = nil;
    if (foundEntity != nil && [foundEntity count] > 0)
        result = [foundEntity objectAtIndex:0];
    return result;
    
}
//
- (NSManagedObject *)createEntity:(NSString *)entityName withID:(NSString *)entityId
{
    NSManagedObject * entity = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.managedObjectContext];
    if ([entityId isKindOfClass:[NSString class]])
        [entity setValue:entityId forKey:@"dbID"];
    [self saveDatabase];
    return entity;
}
- (EventForm *)createEventFormWithId:(NSString *)ID
{
    return (EventForm *)[self createEntity:@"EventForm" withID:ID];
}
- (EventFormType *)createEventFormTypeWithId:(NSString *)ID
{
    return (EventFormType *)[self createEntity:@"EventFormType" withID:ID];
}

- (Organisation *)createOrganisationWithId:(NSString *)ID
{
    return (Organisation *)[self createEntity:@"Organisation" withID:ID];
}
- (Event *)createEvent
{
    return (Event *)[self createEntity:@"Event" withID:nil];
}
- (Category *)createCategoryWithId:(NSString *)ID
{
    return (Category *)[self createEntity:@"Category" withID:ID];
}
- (EventForm *)createEventForm
{
    return (EventForm *)[self createEntity:@"EventForm" withID:nil];
}
- (EventFormType *)createEventFormType
{
    return (EventFormType *)[self createEntity:@"EventFormType" withID:nil];
}
- (Organisation *)createOrganisation
{
    return (Organisation *)[self createEntity:@"Organisation" withID:nil];
}

- (Category *)createCategory
{
    return (Category *)[self createEntity:@"Category" withID:nil];
}

- (Place *)createPlace
{
    return (Place *)[self createEntity:@"Place" withID:nil];
}
- (EventDate *)createEventDate
{
    return (EventDate *)[self createEntity:@"EventDate" withID:nil];
}
//
- (NSInteger) getEventsCountForCategory:(Category *)category
{
    return [category.events count];
}
- (NSInteger) getCategoriesCount
{
    return [[self getAllCategories] count];
}
- (NSInteger) getOrganisationsCount
{
    return [[self getAllOrganisations] count];
}
- (NSInteger) getEventFormsCount
{
    return [[self getAllEventForms] count];
}
- (NSInteger) getPlacesCount
{
    return [[self getAllPlaces] count];
}
- (NSInteger) getDatesCountForEvent:(Event *)event
{
    return [event.dates count];
}
//
- (NSArray *) getAllCategories
{
    return [self fetchedManagedObjectsForEntity:@"Category" withPredicate:nil];
}
- (NSArray *) getAllOrganisations
{
    return [self fetchedManagedObjectsForEntity:@"Organisation" withPredicate:nil];
}
- (NSArray *) getAllPlaces
{
    return [self fetchedManagedObjectsForEntity:@"Place" withPredicate:nil];
}
- (NSArray *) getAllEventForms
{
    return [self fetchedManagedObjectsForEntity:@"EventForm" withPredicate:nil];
}
- (NSArray *) getAllEventsForCategory:(Category *)category
{
    return [self fetchedManagedObjectsForEntity:@"Event" withPredicate:[NSPredicate predicateWithFormat:@"category == %@", category]];
}
- (NSArray *) getAllDatesForEvent:(Event *)event
{
    return [self fetchedManagedObjectsForEntity:@"EventDate" withPredicate:[NSPredicate predicateWithFormat:@"event == %@", event]];
}
- (NSArray *) getAllEventsForEventDate:(NSDate *)date
{
    return [self fetchedManagedObjectsForEntity:@"Event" withPredicate:[NSPredicate predicateWithFormat:@"data == %@", date]];
}
- (NSArray *) getAllEventsAfterDay:(NSDate *)day
{
    return [self fetchedManagedObjectsForEntity:@"Event" withPredicate:[NSPredicate predicateWithFormat:@"data >= %@", day]];
}
- (NSArray *) getAllEventsForCity:(NSString *)city
{
//    return [self fetchedManagedObjectsForEntity:@"Event" withPredicate:[NSPredicate predicateWithFormat:@"
    return nil;
}
- (NSArray *) getAllEventsForPlace:(Place *)place
{
    return nil;
}
- (NSArray *) getAllEventsForLecturer:(NSString *)lecturer
{
    return [self fetchedManagedObjectsForEntity:@"Event" withPredicate:[NSPredicate predicateWithFormat:@"lecturer == %@", lecturer]];
}
- (NSArray *) getAllEventsForAddress:(NSString *)address
{
    return nil;
}
//
- (Event *)getEventById:(NSString *)ID
{
    return (Event *)[self getEntity:@"Event" withId:ID];
}
- (EventDate *)getDateById:(NSString *)ID
{
    return (EventDate *)[self getEntity:@"EventDate" withId:ID];
}
- (Place *)getPlaceById:(NSString *)ID
{
    return (Place *)[self getEntity:@"Place" withId:ID];
}
- (Organisation *)getOrganistationById:(NSString *)ID;
{
    Organisation * org = (Organisation *)[self getEntity:@"Organisation" withId:ID];
    if (!org)
        org = [self createOrganisationWithId:ID];
    return org;
}
- (EventForm *)getFormById:(NSString *)ID
{
    EventForm * res = (EventForm *)[self getEntity:@"EventForm" withId:ID];
    if (!res)
        res = [self createEventFormWithId:ID];
    return res;
}
- (EventFormType *)getFormTypeById:(NSString *)ID
{
    EventFormType * res = (EventFormType *)[self getEntity:@"EventFormType" withId:ID];
    if (!res)
        res = [self createEventFormTypeWithId:ID];
    return res;
}

- (Category *)getCategoryById:(NSString *)ID
{
    Category * res = (Category *)[self getEntity:@"Category" withId:ID];
    if (!res)
        res = [self createCategoryWithId:ID];
    return res;
}
//
- (void)removeEvent:(Event *)event
{
    [self removeEntity:event];
}
- (void)removeEventById:(NSString *)ID
{
    [self removeEntity:[self getEventById:ID]];
}
- (void)removeEventForm:(EventForm *)form
{
    [self removeEntity:form];
}
- (void)removeEventFormType:(EventFormType *)formType
{
    [self removeEntity:formType];
}

- (void)removeEventFormById:(NSString *)ID
{
    [self removeEntity:[self getEventById:ID]];
}
- (void)removeOrganisation:(Organisation *)organisation
{
    [self removeEntity:organisation];
}
- (void)removeOrganisationById:(NSString *)ID
{
    [self removeEntity:[self getEventById:ID]];
}
- (void)removePlace:(Place *)place
{
    [self removeEntity:place];
}
- (void)removePlaceById:(NSString *)ID
{
    [self removeEntity:[self getEventById:ID]];
}
- (void)removeEventDate:(EventDate *)date
{
    [self removeEntity:date];
}
- (void)removeDateById:(NSString *)ID
{
    [self removeEntity:[self getEventById:ID]];
}
- (void)removeCategory:(Category *)category
{
    [self removeEntity:category];
}
- (void)removeCategoryById:(NSString *)ID
{
    [self removeEntity:[self getEventById:ID]];
}
- (Update *)getUpdate
{
    Update *update = (Update *)[[self fetchedManagedObjectsForEntity:@"Update" withPredicate:nil] objectAtIndex:0];
    if (update == nil)
    {
        update = [NSEntityDescription insertNewObjectForEntityForName:@"Update" inManagedObjectContext:self.managedObjectContext];
        [update setStaticChecksum:@"NULL"];
        [update setDynamicChecksum:@"NULL"];
        [self saveDatabase];
    }
    return update;
}
- (NSString *)getLastEventsChecksum
{
    return  [[self getUpdate] staticChecksum];
}
- (NSString *)getLastEventsDatesChecksum
{
    return [[self getUpdate] dynamicChecksum ];
}
- (void)setLastEventsChecksum:(NSString *)checksum
{
    [[self getUpdate] setStaticChecksum:checksum];
    [self saveDatabase];
}
- (void)setLastEventsDatesChecksum:(NSString *)checksum
{
    [[self getUpdate] setDynamicChecksum:checksum];
    [self saveDatabase];
}
@end
