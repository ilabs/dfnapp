//
//  Update.h
//  DFN
//
//  Created by Pawel Nuzka on 3/17/12.
//  Copyright (c) 2012 pawel.jankowski@me.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Update : NSManagedObject

@property (nonatomic, retain) NSString * dynamicChecksum;
@property (nonatomic, retain) NSString * staticChecksum;

@end
