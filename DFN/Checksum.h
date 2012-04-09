//
//  Checksum.h
//  DFN
//
//  Created by Pawel Nuzka on 4/6/12.
//  Copyright (c) 2012 Pawel.Nuzka@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Update;

@interface Checksum : NSManagedObject

@property (nonatomic, retain) NSString * md5;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) Update *eventsDatesUpdate;
@property (nonatomic, retain) Update *eventsUpdate;

@end
