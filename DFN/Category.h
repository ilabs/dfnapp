//
//  Category.h
//  DFN
//
//  Created by Pawel Nuzka on 2/2/12.
//  Copyright (c) 2012 pawel.jankowski@me.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Category : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * year;
@property (nonatomic, retain) NSDate * last_update;

@end
