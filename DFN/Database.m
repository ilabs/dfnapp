//
//  Database.m
//  DFN
//
//  Created by Pawel Nuzka on 2/3/12.
//  Copyright (c) 2012 pawelqus@gmail.com. All rights reserved.
//

#import "Database.h"

@implementation Database
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

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

- (void)saveDatabase
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DFN" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"DFN.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSString *) databasePath
{
    return [[[self  applicationDocumentsDirectory] description] stringByAppendingPathComponent:@"temp.sqlite"];
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
- (NSInteger) getFormsCount
{
    return [[self getAllForms] count];
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
- (NSArray *) getAllForms
{
    return [self fetchedManagedObjectsForEntity:@"Form" withPredicate:nil];
}
- (NSArray *) getALlEventsForCategory:(Category *)category
{
    return [self fetchedManagedObjectsForEntity:@"Event" withPredicate:[NSPredicate predicateWithFormat:@"category == %@", category]];
}
- (NSArray *) getAllDatesForEvent:(Event *)event
{
    return [self fetchedManagedObjectsForEntity:@"Data" withPredicate:[NSPredicate predicateWithFormat:@"event == %@", event]];
}
- (NSArray *) getAllEventsForData:(NSDate *)date
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
- (Date *)getDateById:(NSString *)ID
{
    return (Date *)[self getEntity:@"Date" withId:ID];
}
- (Place *)getPlaceById:(NSString *)ID
{
    return (Place *)[self getEntity:@"Place" withId:ID];
}
- (Organisation *)getOrganistationById:(NSString *)ID;
{
    return (Organisation *)[self getEntity:@"Organisation" withId:ID];
}
- (Form *)getFormById:(NSString *)ID
{
    return (Form *)[self getEntity:@"Form" withId:ID];
}
- (Category *)getCategoryById:(NSString *)ID
{
    return (Category *)[self getEntity:@"Category" withId:ID];
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
- (void)removeForm:(Form *)form
{
    [self removeEntity:form];
}
- (void)removeFormById:(NSString *)ID
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
- (void)removeDate:(Date *)date
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
@end
