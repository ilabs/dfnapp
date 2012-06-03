//
//  Section.h
//  DFN
//
//  Created by Pawel Nuzka on 6/3/12.
//  Copyright (c) 2012 pawel.jankowski@me.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Category;

@interface Section : NSManagedObject

@property (nonatomic, retain) NSString * dbID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *categories;
@end

@interface Section (CoreDataGeneratedAccessors)

- (void)addCategoriesObject:(Category *)value;
- (void)removeCategoriesObject:(Category *)value;
- (void)addCategories:(NSSet *)values;
- (void)removeCategories:(NSSet *)values;
@end
