//
//  Event.h
//  DFN
//
//  Created by Pawel Nuzka on 2/3/12.
//  Copyright (c) 2012 pawel.jankowski@me.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Category, Date, Form, Organisation, Place;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSDate * last_update;
@property (nonatomic, retain) NSString * lecturer;
@property (nonatomic, retain) NSString * lecturers_title;
@property (nonatomic, retain) NSString * section;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * dbID;
@property (nonatomic, retain) Category *category;
@property (nonatomic, retain) NSSet *dates;
@property (nonatomic, retain) NSSet *forms;
@property (nonatomic, retain) Organisation *organisation;
@property (nonatomic, retain) Place *place;
@end

@interface Event (CoreDataGeneratedAccessors)

- (void)addDatesObject:(Date *)value;
- (void)removeDatesObject:(Date *)value;
- (void)addDates:(NSSet *)values;
- (void)removeDates:(NSSet *)values;
- (void)addFormsObject:(Form *)value;
- (void)removeFormsObject:(Form *)value;
- (void)addForms:(NSSet *)values;
- (void)removeForms:(NSSet *)values;
@end
