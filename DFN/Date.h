//
//  Date.h
//  DFN
//
//  Created by Pawel Nuzka on 2/2/12.
//  Copyright (c) 2012 pawel.jankowski@me.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Date : NSManagedObject

@property (nonatomic, retain) NSDate * day;
@property (nonatomic, retain) NSDate * opening_hour;
@property (nonatomic, retain) NSDate * closing_hour;
@property (nonatomic, retain) NSDate * last_update;

@end
