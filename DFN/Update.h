//
//  Update.h
//  DFN
//
//  Created by Pawel Nuzka on 4/6/12.
//  Copyright (c) 2012 Pawel Nuzka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Checksum;

@interface Update : NSManagedObject

@property (nonatomic, retain) NSString * dynamicChecksum;
@property (nonatomic, retain) NSNumber * numberOfEventsChecksums;
@property (nonatomic, retain) NSNumber * numberOfEventsDatesChecksums;
@property (nonatomic, retain) NSString * staticChecksum;
@property (nonatomic, retain) NSSet *eventsChecksum;
@property (nonatomic, retain) NSSet *eventsDatesChecksum;
@end

@interface Update (CoreDataGeneratedAccessors)

- (void)addEventsChecksumObject:(Checksum *)value;
- (void)removeEventsChecksumObject:(Checksum *)value;
- (void)addEventsChecksum:(NSSet *)values;
- (void)removeEventsChecksum:(NSSet *)values;
- (void)addEventsDatesChecksumObject:(Checksum *)value;
- (void)removeEventsDatesChecksumObject:(Checksum *)value;
- (void)addEventsDatesChecksum:(NSSet *)values;
- (void)removeEventsDatesChecksum:(NSSet *)values;
@end
