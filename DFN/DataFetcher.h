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
#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>

@interface DataFetcher : NSObject{
    NSString * urlToMainJSON;
    NSString * urlToEventsJSON;
    NSString * urlToEventsDatesJSON;
    JSONDecoder *jsonDecoder;
}

+ (id)sharedInstance;
- (void)updateData;
- (NSData *)downloadDataFromURL:(NSString *)url;
- (NSDictionary *)decodeFromJSON:(NSData *)data;
- (BOOL)checkConnection;
@property (retain) NSString *urlToMainJSON;
@property (retain) NSString *urlToEventsJSON;
@property (retain) NSString *urlToEventsDatesJSON;
@property (readonly) JSONDecoder *jsonDecoder;

@end
