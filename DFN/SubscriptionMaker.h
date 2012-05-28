//
//  SubscriptionMaker.h
//  DFN
//
//  Created by Tomasz Topczewski on 18.04.2012.
//  Copyright (c) 2012 pawel.nuzka@gmail.com. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "DatabaseManager.h"

@interface SubscriptionMaker : NSObject

@property(nonatomic, retain) NSString *event;


-(void)subscribeWithSubscripiton:(NSString *)subscription withDate:(EventDate *)date withTitle:(NSString *)title andNavigationView:(UINavigationController *)navController; 
-(NSString*) emailRegex:(NSString*) eventString ;
-(NSString*) phoneRegex:(NSString*) eventString ;
-(NSString*) dateRegex:(NSString*) eventString ;
- (void) makeCall:(NSString *)number;
- (void) sendEmailTo:(NSString *)to withSubject:(NSString *)subject withBody:(NSString *)body;

@end
