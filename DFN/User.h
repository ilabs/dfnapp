//
//  User.h
//  DFN
//
//  Created by Pawel Nuzka on 5/28/12.
//  Copyright (c) 2012 pawelqus@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSNumber * isSet;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * surname;

@end
