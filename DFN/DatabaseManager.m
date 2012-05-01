//
//  Database.m
//  DFN
//
//  Created by Pawel Nuzka on 2/3/12.
//  Copyright (c) 2012 pawelqus@gmail.com. All rights reserved.
//

#import "DFNAppDelegate.h"
#import "DatabaseManager.h"
#import "WatchedEntities.h"
#import "Update.h"
#import "Checksum.h"
@interface DatabaseManager ()

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSPersistentStoreCoordinator *persistentStoreCoordinator;
- (NSString *)applicationDocumentsDirectory;

@end

@implementation DatabaseManager
+(void)setUpDatabase:(NSPersistentStoreCoordinator *)_persistentStoreCoordinator
{
    static id master = nil;
    
    @synchronized(self)
    {
        if (master == nil)
        {
            master = [self new];
            [master setPersistentStoreCoordinator:_persistentStoreCoordinator];
        }   
    }
    
}
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
-(void)refreshState
{
    [self saveDatabase];
    [managedObjectContext release];
}
- (void)setManagedObjectContext:(NSManagedObjectContext *)_managedObjectContext
{
    [managedObjectContext release];
    managedObjectContext = nil;
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

- (void)setPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)_persistentStoreCoordinator
{
    if (!persistentStoreCoordinator)
        persistentStoreCoordinator = _persistentStoreCoordinator;
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
    @synchronized(self)
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
}
- (NSArray *)fetchedManagedObjectsForEntity:(NSString *)entityName withPredicate:(NSPredicate *)predicate withSortingByKey:(NSString *)key
{
    @synchronized(self)
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
}

-(NSManagedObject *) getEntity:(NSString *)entity withId:(NSString *)entityId
{
    NSArray *foundEntity;
    if (entityId)
        foundEntity = [self fetchedManagedObjectsForEntity:entity 
                                             withPredicate:[NSPredicate predicateWithFormat:@"dbID == %@", entityId]];
    else
        foundEntity = [self fetchedManagedObjectsForEntity:entity 
                                             withPredicate:nil];
    
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
    Event * event = (Event *)[self createEntity:@"Event" withID:nil];
    [event setShowAsUpdated:[NSNumber numberWithBool:NO]];
    return event;
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
- (WatchedEntities *)createWatchedEntities
{
    return (WatchedEntities *)[self createEntity:@"WatchedEntities" withID:nil];
}
- (Checksum *)createChecksum
{
    return (Checksum *)[self createEntity:@"Checksum" withID:nil];
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
- (NSInteger) getEventDatesCountForEvent:(Event *)event
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
    Place * place = (Place *)[[self fetchedManagedObjectsForEntity:@"Place" 
                                                     withPredicate:[NSPredicate predicateWithFormat:@"city == %@", city]] objectAtIndex:0];
    return [self getAllEventsForPlace:place];
}
- (NSArray *) getAllEventsForPlace:(Place *)place
{
    return [self fetchedManagedObjectsForEntity:@"Event" withPredicate:[NSPredicate predicateWithFormat:@"place == %@", place]];;
}
- (NSArray *) getAllEventsForLecturer:(NSString *)lecturer
{
    return [self fetchedManagedObjectsForEntity:@"Event" withPredicate:[NSPredicate predicateWithFormat:@"lecturer == %@", lecturer]];
}
- (NSArray *) getAllEventsForAddress:(NSString *)address
{
    Place * place = (Place *)[[self fetchedManagedObjectsForEntity:@"Place" 
                                                     withPredicate:[NSPredicate predicateWithFormat:@"address == %@", address]] objectAtIndex:0];
    return [self getAllEventsForPlace:place];
}
//
- (WatchedEntities *)getWatchedEntities
{
    WatchedEntities * watched = (WatchedEntities *)[self getEntity:@"WatchedEntities" withId:nil];
    if (!watched)
        watched = [self createWatchedEntities];
    return watched;
}

- (NSArray *)getAllWatched
{
    WatchedEntities * watched = [self getWatchedEntities];
    return [[watched watched] allObjects];
}
- (NSArray *) getAllSubscribed
{
    NSMutableArray *array = [NSMutableArray array];
    for (Event * event in [self getAllWatched])
        [array addObjectsFromArray:[[event subscribedDates] allObjects]];
    return array;
}
- (BOOL)isWatched:(Event *)event
{
    if ([event watched])
        return TRUE;
    else
        return FALSE;
}
- (BOOL)isSubscribed:(Event *)event
{
    if ([[event subscribedDates] count] > 0)
        return TRUE;
    else
        return FALSE;
}
- (Event *)getEventWithId:(NSString *)ID
{
    return (Event *)[self getEntity:@"Event" withId:ID];
}
- (EventDate *)getEventDateWithId:(NSString *)ID
{
    return (EventDate *)[self getEntity:@"EventDate" withId:ID];
}
- (Place *)getPlaceWithId:(NSString *)ID
{
    return (Place *)[self getEntity:@"Place" withId:ID];
}
- (Organisation *)getOrganistationWithId:(NSString *)ID;
{
    Organisation * org = (Organisation *)[self getEntity:@"Organisation" withId:ID];
    if (!org)
        org = [self createOrganisationWithId:ID];
    return org;
}
- (EventForm *)getEventFormWithId:(NSString *)ID
{
    EventForm * res = (EventForm *)[self getEntity:@"EventForm" withId:ID];
    if (!res)
        res = [self createEventFormWithId:ID];
    return res;
}
- (EventFormType *)getEventFormTypeWithId:(NSString *)ID
{
    EventFormType * res = (EventFormType *)[self getEntity:@"EventFormType" withId:ID];
    if (!res)
        res = [self createEventFormTypeWithId:ID];
    return res;
}

- (Category *)getCategoryWithId:(NSString *)ID
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
- (void)removeEventWithId:(NSString *)ID
{
    [self removeEntity:[self getEventWithId:ID]];
}
- (void)removeEventForm:(EventForm *)form
{
    [self removeEntity:form];
}
- (void)removeEventFormType:(EventFormType *)formType
{
    [self removeEntity:formType];
}
- (void)removeEventFormWithId:(NSString *)ID
{
    [self removeEntity:[self getEventWithId:ID]];
}
- (void)removeEventFormTypeWithId:(NSString *)ID
{
    [self removeEntity:[self getEventFormTypeWithId:ID]];
}
- (void)removeOrganisation:(Organisation *)organisation
{
    [self removeEntity:organisation];
}
- (void)removeOrganisationWithId:(NSString *)ID
{
    [self removeEntity:[self getEventWithId:ID]];
}
- (void)removePlace:(Place *)place
{
    [self removeEntity:place];
}
- (void)removePlaceWithId:(NSString *)ID
{
    [self removeEntity:[self getEventWithId:ID]];
}
- (void)removeEventDate:(EventDate *)date
{
    [self removeEntity:date];
}
- (void)removeEventDateWithId:(NSString *)ID
{
    [self removeEntity:[self getEventDateWithId:ID]];
}
- (void)removeCategory:(Category *)category
{
    [self removeEntity:category];
}
- (void)removeCategoryWithId:(NSString *)ID
{
    [self removeEntity:[self getEventWithId:ID]];
}
- (void)addToWatchedEntities:(Event *)event
{
    WatchedEntities * watched = [self getWatchedEntities];
    [watched addWatchedObject:event];
    [self saveDatabase];
}
- (void)removeFromWatchedEntities:(Event *)event
{
    WatchedEntities *watched = [self getWatchedEntities];
    [watched removeWatchedObject:event];
    [self saveDatabase];
}
- (void)addToSubscribedEntities:(EventDate *)eventDate
{
    Event * event = [eventDate event];
    [event addSubscribedDatesObject:eventDate];
    [self addToWatchedEntities:event];
    [self saveDatabase];
}
- (void)removeFromSubscribedEntities:(EventDate *)eventDate
{
    Event *event = [eventDate event];
    [event removeSubscribedDatesObject:eventDate];
    [self removeFromWatchedEntities:event];
    [self saveDatabase];
}
- (BOOL)isEventDateSubscribed:(EventDate *)eventDate
{
    if ([eventDate subscribeEvent])
        return TRUE;
    else
        return FALSE;
}
- (EventDate *)hasAlreadySubscribedAtDate:(NSDate *)date
{
    NSArray *subscibedAtDate = [self fetchedManagedObjectsForEntity:@"EventDate" withPredicate:
                                [NSPredicate predicateWithFormat:@"day == %@ AND subscribeEvent != nil", date]];
    if ([subscibedAtDate count] > 0)
        return (EventDate *)[subscibedAtDate objectAtIndex:0];
    
    return nil;
}
- (EventDate *)hasAlreadySubscribedAtDay:(NSDate *)day andOpeningHour:(NSDate *)openingHour
{
    NSArray *subscibedAtDate = [self fetchedManagedObjectsForEntity:@"EventDate" withPredicate:
                                [NSPredicate predicateWithFormat:@"day == %@ AND openingHour == %@ and subcriveEvent != nil", day, openingHour]];
    if ([subscibedAtDate count] > 0)
        return (EventDate *)[subscibedAtDate objectAtIndex:0];
    
    return nil;
}


- (Update *)getUpdate
{
    Update *update = (Update *)[[self fetchedManagedObjectsForEntity:@"Update" withPredicate:nil] objectAtIndex:0];
    if (update == nil)
    {
        update = [NSEntityDescription insertNewObjectForEntityForName:@"Update" inManagedObjectContext:self.managedObjectContext];
        [update setStaticChecksum:@"NULL"];
        [update setDynamicChecksum:@"NULL"];
        [update setNumberOfEventsChecksums:[NSNumber numberWithInt:0]];
        [update setNumberOfEventsDatesChecksums:[NSNumber numberWithInt:0]];
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
- (Checksum *)getChecksumWithPredicate:(NSPredicate *)predicate
{
    Checksum *checksum = [[self fetchedManagedObjectsForEntity:@"Checksum" withPredicate:predicate] objectAtIndex:0];
    return checksum;
}
- (NSString *)getChecksumWithEventNumber:(int)eventNumber
{
    Update * update = [self getUpdate];
    Checksum *checksum = [self getChecksumWithPredicate:
                          [NSPredicate predicateWithFormat:@"((number = %d)) AND ((eventsUpdate = %@))",
                           eventNumber, update]];
    return [checksum md5];
}
- (NSString *)getChecksumWithEventDatesNumber:(int)eventDatesNumber
{
    Update * update = [self getUpdate];
    Checksum *checksum = [self getChecksumWithPredicate:
                          [NSPredicate predicateWithFormat:@"((number == %d)) AND ((eventsDatesUpdate == %@))",
                           eventDatesNumber, update]];
    return [checksum md5];
}
- (void)saveChecksum:(NSString *)md5 withEventsNumber:(int)eventsNumber
{
    Update * update = [self getUpdate];
    Checksum *checksum = [self getChecksumWithPredicate:
                          [NSPredicate predicateWithFormat:@"((number == %d)) AND ((eventsUpdate == %@))",
                           eventsNumber, update]];
    if (!checksum)
    {
        checksum = [self createChecksum];
        [checksum setNumber:[NSNumber numberWithInt:eventsNumber]];
        [update addEventsChecksumObject:checksum];
        [checksum setEventsUpdate:update];
    }
    [checksum setMd5:md5];
    [self saveDatabase];
    // NSLog(@"zapisuje checksume event %@", checksum);
}
- (void)saveChecksum:(NSString *)md5 withEventsDatesNumber:(int)eventsDatesNumber
{
    Update * update = [self getUpdate];
    Checksum *checksum = [self getChecksumWithPredicate:
                          [NSPredicate predicateWithFormat:@"((number == %d)) AND ((eventsDatesUpdate == %@))",
                           eventsDatesNumber, update]];
    if (!checksum)
    {
        checksum = [self createChecksum];
        [checksum setNumber:[NSNumber numberWithInt:eventsDatesNumber]];
        [update addEventsDatesChecksumObject:checksum];
        [checksum setEventsDatesUpdate:update];
    }
    [checksum setMd5:md5];
    [self saveDatabase];
    // NSLog(@"zapisuje checksume event date %@", checksum);
}
- (int)getNumberOfEventsChecksums
{
    return [[[self getUpdate] numberOfEventsChecksums] intValue];
}
- (int)getNumberOfEventsDatesChecksums
{
    return [[[self getUpdate] numberOfEventsDatesChecksums] intValue];
}
- (void)setNumberOfEventsChecksums:(int)number
{
    [[self getUpdate] setNumberOfEventsChecksums:[NSNumber numberWithInt:number]];
}
- (void)setNumberOfEventsDatesChecksums:(int)number
{
    [[self getUpdate] setNumberOfEventsDatesChecksums:[NSNumber numberWithInt:number]];
}
- (void)removeAllEventsChecksums
{
    Update * update = [self getUpdate];
    NSArray *checksumArray = [self fetchedManagedObjectsForEntity:@"Checksum" 
                                                    withPredicate:[NSPredicate predicateWithFormat:@"eventsUpdate == %@", update]];
    for (int i = 0; i < [checksumArray count]; i++)
        [self removeEntity:(Checksum *)[checksumArray objectAtIndex:i]];
}
- (void)removeAllEventDatesChecksums
{
    Update * update = [self getUpdate];
    NSArray *checksumArray = [self fetchedManagedObjectsForEntity:@"Checksum" 
                                                    withPredicate:[NSPredicate predicateWithFormat:@"eventsDatesUpdate == %@", update]];
    for (int i = 0; i < [checksumArray count]; i++)
        [self removeEntity:(Checksum *)[checksumArray objectAtIndex:i]];
}

@end
