//
//  Place.h
//  DFN
//
//  Created by Pawel Nuzka on 2/2/12.
//  Copyright (c) 2012 pawel.jankowski@me.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Place : NSManagedObject

@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * free_places;
@property (nonatomic, retain) NSString * gps_coordinates;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSDate * last_update;

@end
