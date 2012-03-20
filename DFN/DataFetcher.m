//
//  DataFetcher.m
//  DFN
//
//  Created by Pawel Nuzka on 3/17/12.
//  Copyright (c) 2012 pawel.jankowski@me.com. All rights reserved.
//

#import "DataFetcher.h"
#define MAIN_JSON_PATH @"http://michaljodko.com/dfn/checksums.json"
#define STATIC_JSON_PATH @"http://michaljodko.com/dfn/imprezy.json"
#define DYNAMIC_JSON_PATH @"http://michaljodko.com/dfn/terminy.json"

@implementation DataFetcher

+ (id)sharedInstance
{
    static id master = nil;
    
    @synchronized(self)
    {
        if (master == nil)
            master = [self new];
    }
    return master;
}
- (NSString *)urlToMainJSON
{
    if(!urlToMainJSON)
        urlToMainJSON = [[NSString alloc] initWithFormat:MAIN_JSON_PATH];
    return urlToMainJSON;
}
- (NSString *)urlToEventsJSON
{
    if(!urlToEventsJSON)
        urlToEventsJSON = [[NSString alloc] initWithFormat:STATIC_JSON_PATH];
    return urlToEventsJSON;
}
- (NSString *)urlToEventsDatesJSON
{
    if(!urlToEventsDatesJSON)
        urlToEventsDatesJSON = [[NSString alloc] initWithFormat:DYNAMIC_JSON_PATH];
    return urlToEventsDatesJSON;
}
-(NSDate *)jsonDateAndTimeToNSDate:(NSString *)dateTime
{
    NSDateFormatter *xsdDateTimeFormatter;
    xsdDateTimeFormatter = [[NSDateFormatter alloc] init];
    xsdDateTimeFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = nil;
    date = [xsdDateTimeFormatter dateFromString: dateTime];
    NSLog(@"skonwertowana data %@", date);
    // if (date==nil) NSLog(@"could not parse date '%@'", dateTime);
    [xsdDateTimeFormatter autorelease];
    return (date);
}
-(NSDate *)xsdDateToNSDate:(NSString *)dateTime {
    NSDateFormatter *xsdDateTimeFormatter;
    xsdDateTimeFormatter = [[NSDateFormatter alloc] init];
    xsdDateTimeFormatter.dateFormat = @"yyyy-MM-dd";
    NSDate *date = nil;
    date = [xsdDateTimeFormatter dateFromString: dateTime];
    // if (date==nil) NSLog(@"could not parse date '%@'", dateTime);
    [xsdDateTimeFormatter autorelease];
    return (date);
}
-(NSDate *)xsdDateTimeToNSDate:(NSString *)dateString andTime:(NSString *)time {
    NSDateFormatter *xsdDateTimeFormatter;
    NSMutableString *datetime = [NSMutableString stringWithFormat:@"%@", dateString];
    [datetime appendFormat:@";"];
    [datetime appendString:time];
    xsdDateTimeFormatter = [[NSDateFormatter alloc] init];
    xsdDateTimeFormatter.dateFormat = @"yyyy-MM-dd;HH:mm:ss";
    NSDate *date = nil;
    date = [xsdDateTimeFormatter dateFromString: datetime];
    // if (date==nil) NSLog(@"could not parse date '%@'", dateTime);
    [xsdDateTimeFormatter autorelease];
    return (date);
}

- (void)updateEvents
{
    NSDictionary *eventsData = [self decodeFromJSON:[self downloadDataFromURL:self.urlToEventsJSON]];
    DatabaseManager *dbManager = [DatabaseManager sharedInstance];
   // NSLog(@"events\n %@", [eventsData description]);
    int i = 1;
    for (NSDictionary *event in eventsData)
    {
        NSLog(@"%d %@",i, [event description] );
        i++;
        Event * dbEvent = [dbManager createEvent];
        id ID = [event objectForKey:@"forma1"];
        if ([ID isKindOfClass:[NSString class]])
        {
            //To jeszcze nie działa do końca!!!
            EventForm *dbEventForm = [dbManager getFormById:(NSString *)ID];
            [dbEventForm setName:(NSString *)ID];
            [dbEvent addFormsObject:dbEventForm];
        }
        [dbEvent setDbID:[event objectForKey:@"id_imprezy"]];
        ID = [event objectForKey:@"kategoria"];
        if ([ID isKindOfClass:[NSString class]])
        {
            //To jeszcze nie działa do końca!!!
            Category *dbCategory = [dbManager getCategoryById:(NSString *)ID];
            [dbCategory setName:(NSString *)ID];
            [dbEvent setCategory:dbCategory];
        }
        ID = [event objectForKey:@"e_mail"];
        if ([ID isKindOfClass:[NSString class]])
            [dbEvent setEmail:(NSString *)ID];
        ID = [event objectForKey:@"opis"];
        if ([ID isKindOfClass:[NSString class]])
            [dbEvent setDescriptionContent:(NSString *)ID];
        ID = [event objectForKey:@"organizacja"];
        if ([ID isKindOfClass:[NSString class]])
        {
            Organisation *dbOrganisation = [dbManager getOrganistationById:(NSString *)ID];
            [dbOrganisation setName:(NSString *)ID];
            [dbEvent setOrganisation:dbOrganisation];
        }
        ID = [event objectForKey:@"poprawial_data"];
        if ([ID isKindOfClass:[NSString class]])
            [dbEvent setLastUpdate:[self jsonDateAndTimeToNSDate:(NSString *)ID]];
        ID = [event objectForKey:@"prowadzacy"];
        if ([ID isKindOfClass:[NSString class]])
            [dbEvent setLecturer:(NSString *)ID];
        ID = [event objectForKey:@"prowadzacy_afiliacje"];
        if ([ID isKindOfClass:[NSString class]])
            [dbEvent setLecturersTitle:(NSString *)ID];
        ID = [event objectForKey:@"tytul_imprezy"];
        if ([ID isKindOfClass:[NSString class]])
            [dbEvent setTitle:(NSString *)ID];    
        
    }
}
- (void)updateEventsData
{
    NSDictionary *eventsDatesData = [self decodeFromJSON:[self downloadDataFromURL:self.urlToEventsDatesJSON]];
    DatabaseManager *dbManager = [DatabaseManager sharedInstance];
 //   NSLog(@"events's dates \n %@", [eventsDatesData description]);
    int i = 1;
    for (NSDictionary *eventDatesData in eventsDatesData)
    {
        NSLog(@"%d %@",i, [eventDatesData description] );
        i++;
        id ID = [eventDatesData objectForKey:@"id_imprezy"];
        if ([ID isKindOfClass:[NSString class]])
        {
            Event *dbEvent = [dbManager getEventById:(NSString *)ID];
            if (!dbEvent)
            {
                dbEvent = [dbManager createEvent];
                [dbEvent setDbID:(NSString *)ID];
            }
            EventDate *dbDate = [dbManager createEventDate];
            ID = [eventDatesData objectForKey:@"dzien"];
            if ([ID isKindOfClass:[NSString class]])
            {
                [dbDate setDay:[self xsdDateToNSDate:(NSString *)ID]];
                [dbDate setEvent:dbEvent];
                [dbEvent addDatesObject:dbDate];
            }
            ID = [eventDatesData objectForKey:@"godzina_start"];
            if ([ID isKindOfClass:[NSString class]])
                [dbDate setOpeningHour:[self xsdDateTimeToNSDate:[eventDatesData objectForKey:@"dzien"] andTime:ID]];
            ID = [eventDatesData objectForKey:@"godzina_stop"];
            if ([ID isKindOfClass:[NSString class]])
                [dbDate setClosingHour:[self xsdDateTimeToNSDate:[eventDatesData objectForKey:@"dzien"] andTime:ID]];
            ID = [eventDatesData objectForKey:@"lokalizacja"];
            if ([ID isKindOfClass:[NSString class]])
            {
                Place *dbPlace = [dbManager createPlace];
                [dbPlace addEventObject:dbEvent];
                [dbEvent setPlace:dbPlace];
                [dbPlace setAddress:(NSString *)ID];
                ID = [eventDatesData objectForKey:@"miasto"];
                if ([ID isKindOfClass:[NSString class]])
                    [dbPlace setCity:(NSString *)ID];
            }
        }
    }
}
- (void)updateData
{
    NSLog(@"Jestem tu! %@", self.urlToMainJSON);
    NSDictionary * checksums = [self decodeFromJSON:[self downloadDataFromURL:self.urlToMainJSON]];
    NSString *eventsChecksum = [checksums objectForKey:@"imprezy"];
    NSString *eventsDatesChecksum = [checksums objectForKey:@"terminy"];
    NSLog(@"imprezy:  %@ \n terminy %@", eventsChecksum, eventsDatesChecksum);
    
    DatabaseManager *dbManager = [DatabaseManager sharedInstance];
    if (![eventsChecksum isEqualToString:[dbManager getLastEventsChecksum]])
    {
        [self updateEvents];
        [dbManager setLastEventsChecksum:eventsChecksum];
    }
    else
        NSLog(@"events up to date");
    if (![eventsDatesChecksum isEqualToString:[dbManager getLastEventsDatesChecksum]])
    {
        [self updateEventsData];
        [dbManager setLastEventsDatesChecksum:eventsDatesChecksum];
    }
    else
        NSLog(@"dates up to date ;D");
}
- (NSData *)downloadDataFromURL:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSError* err = nil;
    NSURLResponse* response = nil;
    NSMutableURLRequest* request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:url];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setTimeoutInterval:30];
    return [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
}
- (NSDictionary *)decodeFromJSON:(NSData *)data
{
    return [data mutableObjectFromJSONData];
}
- (void)dealloc
{
    [self.urlToMainJSON release];
    [self.urlToEventsJSON release];
    [self.urlToEventsDatesJSON release];
    [super dealloc];
}
@end
