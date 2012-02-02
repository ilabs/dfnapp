//
//  Event.h
//  DFN
//
//  Created by Pawel Nuzka on 2/2/12.
//  Copyright (c) 2012 pawel.jankowski@me.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Category, Date, Form, Organisation, Place;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSString * section;
@property (nonatomic, retain) NSString * lecturer;
@property (nonatomic, retain) NSString * lecturers_title;
@property (nonatomic, retain) NSDate * last_update;
@property (nonatomic, retain) NSSet *dates;
@property (nonatomic, retain) Category *category;
@property (nonatomic, retain) NSSet *form;
@property (nonatomic, retain) NSSet *place;
@property (nonatomic, retain) Organisation *organisation;
@end

@interface Event (CoreDataGeneratedAccessors)

- (void)addDatesObject:(Date *)value;
- (void)removeDatesObject:(Date *)value;
- (void)addDates:(NSSet *)values;
- (void)removeDates:(NSSet *)values;
- (void)addFormObject:(Form *)value;
- (void)removeFormObject:(Form *)value;
- (void)addForm:(NSSet *)values;
- (void)removeForm:(NSSet *)values;
- (void)addPlaceObject:(Place *)value;
- (void)removePlaceObject:(Place *)value;
- (void)addPlace:(NSSet *)values;
- (void)removePlace:(NSSet *)values;
@end
