//
//  DataFetcher.h
//  DFN
//
//  Created by Pawel Nuzka on 3/17/12.
//  Copyright (c) 2012 pawel.jankowski@me.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONKit.h"
#import "DatabaseManager.h"


@interface DataFetcher : NSObject{
    NSString * urlToMainJSON;
    NSString * urlToEventsJSON;
    NSString * urlToEventsDatesJSON;
}

+ (id)sharedInstance;
- (void)updateData;
- (NSData *)downloadDataFromURL:(NSString *)url;
- (NSDictionary *)decodeFromJSON:(NSData *)data;

@property (readonly) NSString *urlToMainJSON;
@property (readonly) NSString *urlToEventsJSON;
@property (readonly) NSString *urlToEventsDatesJSON;

@end
