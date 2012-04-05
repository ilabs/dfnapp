//
//  DataFetcher.m
//  DFN
//
//  Created by Pawel Nuzka on 3/17/12.
//  Copyright (c) 2012 pawel.jankowski@me.com. All rights reserved.
//

#import "DataFetcher.h"

#define JSONS_PATH @"http://michaljodko.com/dfn/"
#define MAIN_JSON_PATH @"http://michaljodko.com/dfn/checksums.json"
#define STATIC_JSON_PATH @"http://michaljodko.com/dfn/imprezy.json"
#define DYNAMIC_JSON_PATH @"http://michaljodko.com/dfn/terminy.json"

@implementation DataFetcher
@synthesize urlToMainJSON, urlToEventsJSON, urlToEventsDatesJSON;

BOOL showProgress = FALSE; 

+ (id)sharedInstance
{
    static id master = nil;
    
    @synchronized(self)
    {
        if (master == nil)
        {
            master = [self new];
            [master setUrlToMainJSON:MAIN_JSON_PATH];
            [master setUrlToEventsJSON:STATIC_JSON_PATH];
            [master setUrlToEventsDatesJSON:DYNAMIC_JSON_PATH];
        }
    }
    return master;
}
- (JSONDecoder *)jsonDecoder
{
    return [JSONDecoder decoder];
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
    NSLog(@"events\n %@", [eventsData description]);
    int i = 1;
    int all = [eventsData count];
    for (NSDictionary *event in eventsData)
    {
        NSLog(@"%d %@",i, [event description] );
        i++;
        Event * dbEvent = [dbManager createEvent];
        id ID = [event objectForKey:@"forma1"];
        ID = [event objectForKey:@"forma1"];
        if ([ID isKindOfClass:[NSString class]] && ![[ID description] isEqualToString:@"<null>"])
        {
            //To jeszcze nie działa do końca!!!
            EventFormType *dbEventFormType = [dbManager getEventFormTypeWithId:(NSString *)ID];
            [dbEventFormType setName:(NSString *)ID];
            EventForm * dbEventForm = [dbManager createEventForm];
            [dbEventForm setEventFormType:dbEventFormType];
            [dbEventFormType addEventFormsObject:dbEventForm];
            [dbEventForm setEvent:dbEvent];
            [dbEvent addFormsObject:dbEventForm];
        }

        ID = [event objectForKey:@"forma2"];
        if ([ID isKindOfClass:[NSString class]] && ![[ID description] isEqualToString:@"<null>"])
        {
            //To jeszcze nie działa do końca!!!
            EventFormType *dbEventFormType = [dbManager getEventFormTypeWithId:(NSString *)ID];
            [dbEventFormType setName:(NSString *)ID];
            EventForm * dbEventForm = [dbManager createEventForm];
            [dbEventForm setEventFormType:dbEventFormType];
            [dbEventFormType addEventFormsObject:dbEventForm];
            [dbEventForm setEvent:dbEvent];
            [dbEvent addFormsObject:dbEventForm];
        }
        ID = [event objectForKey:@"forma3"];
        if ([ID isKindOfClass:[NSString class]] && ![[ID description] isEqualToString:@"<null>"])
        {
            //To jeszcze nie działa do końca!!!
            EventFormType *dbEventFormType = [dbManager getEventFormTypeWithId:(NSString *)ID];
            [dbEventFormType setName:(NSString *)ID];
            EventForm * dbEventForm = [dbManager createEventForm];
            [dbEventForm setEventFormType:dbEventFormType];
            [dbEventFormType addEventFormsObject:dbEventForm];
            [dbEventForm setEvent:dbEvent];
            [dbEvent addFormsObject:dbEventForm];
        }

        
        [dbEvent setDbID:[event objectForKey:@"id_imprezy"]];
        ID = [event objectForKey:@"kategoria"];
        if ([ID isKindOfClass:[NSString class]])
        {
            //To jeszcze nie działa do końca!!!
            Category *dbCategory = [dbManager getCategoryWithId:(NSString *)ID];
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
            Organisation *dbOrganisation = [dbManager getOrganistationWithId:(NSString *)ID];
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
        
        if (i % (all/10) == 0 && showProgress)
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DownloadProgress"
                                                                object:[NSNumber numberWithFloat:i/(all*2.0)]];
        
    }
}
- (void)updateEventsData
{
    NSDictionary *eventsDatesData = [self decodeFromJSON:[self downloadDataFromURL:self.urlToEventsDatesJSON]];
    DatabaseManager *dbManager = [DatabaseManager sharedInstance];
 //   NSLog(@"events's dates \n %@", [eventsDatesData description]);
    int i = 1;
    int all = [eventsDatesData count];
    for (NSDictionary *eventDatesData in eventsDatesData)
    {
        NSLog(@"%d %@",i, [eventDatesData description] );
        i++;
        id ID = [eventDatesData objectForKey:@"id_imprezy"];
        if ([ID isKindOfClass:[NSString class]])
        {
            Event *dbEvent = [dbManager getEventWithId:(NSString *)ID];
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
                ID = [eventDatesData objectForKey:@"ilosc_miejsc"];
                if ([ID isKindOfClass:[NSString class]])
                    [dbPlace setNumberOfFreePlaces:(NSString *)ID];
                
            }
        }
        if (i % (all/10) == 0 && showProgress)
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DownloadProgress"
                                                                object:[NSNumber numberWithFloat:0.5+i/(all*2.0)]];
    }
}
- (void)updateData
{
    NSLog(@"Jestem tu! %@", self.urlToMainJSON);
    if (![self checkConnection])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"No connection" object:nil];
        return;
    }
    NSDictionary * checksums = [self decodeFromJSON:[self downloadDataFromURL:self.urlToMainJSON]];
    
    NSString *eventsChecksum = [checksums objectForKey:@"imprezy"];
    NSString *eventsDatesChecksum = [checksums objectForKey:@"terminy"];
    NSLog(@"imprezy:  %@ \n terminy %@", eventsChecksum, eventsDatesChecksum);

    int numberOfEvents = [(NSString *)[checksums objectForKey:@"ile_imprez"] intValue];
    int numberOfEventsDates = [(NSString *)[checksums objectForKey:@"ile_terminow"] intValue];
    NSLog(@"# imprez - %d , # dat - %d", numberOfEvents, numberOfEventsDates);
    DatabaseManager *dbManager = [DatabaseManager sharedInstance];
    
    if ([dbManager getNumberOfEventsChecksums] == 0)
    {
        showProgress = TRUE;
        [self updateEvents];
        [dbManager setLastEventsChecksum:eventsChecksum];
        [dbManager setNumberOfEventsChecksums:numberOfEvents];
        [dbManager removeAllEventsChecksums];
        for (int i =0; i < numberOfEvents; i++)
            [dbManager saveChecksum:[checksums objectForKey:[NSString stringWithFormat:@"impreza%d", i]]
                    withEventsNumber:i];
        showProgress = FALSE;
    }
    
    if ([dbManager getNumberOfEventsDatesChecksums] == 0)
    {
        showProgress = TRUE;
        [self updateEventsData];
        [dbManager setLastEventsDatesChecksum:eventsDatesChecksum];
        [dbManager setNumberOfEventsDatesChecksums:numberOfEventsDates];
        [dbManager removeAllEventDatesChecksums];
        for (int i =0; i < numberOfEventsDates; i++)
            [dbManager saveChecksum:[checksums objectForKey:[NSString stringWithFormat:@"termin%d", i]]
                    withEventsDatesNumber:i];
        showProgress = FALSE;
    }
    
    
    
    if (numberOfEvents != [dbManager getNumberOfEventsChecksums])
    {
        [dbManager removeAllEventsChecksums];
        [dbManager setNumberOfEventsChecksums:0];
    }
    
    if (numberOfEventsDates != [dbManager getNumberOfEventsDatesChecksums])
    {
        [dbManager removeAllEventDatesChecksums];
        [dbManager setNumberOfEventsDatesChecksums:0];
    }
    
    if (![eventsChecksum isEqualToString:[dbManager getLastEventsChecksum]])
    {
        for (int i = 0; i < numberOfEvents; i++)
        {
            NSString *eventChecksumFromJSON = [checksums objectForKey:[NSString stringWithFormat:@"impreza%d", i]];
            NSString *eventChecksumFromDB = [dbManager getChecksumWithEventNumber:i];
            if (![eventChecksumFromJSON isEqualToString:eventChecksumFromDB])
            {
                [self setUrlToEventsJSON:[NSString stringWithFormat:@"%@impreza%d.json", JSONS_PATH, i]];
                [self updateEvents];
                [dbManager saveChecksum:eventChecksumFromJSON withEventsNumber:i];
            }
            if (i % (numberOfEvents/10) == 0)
                [[NSNotificationCenter defaultCenter] postNotificationName:@"DownloadProgress"
                                                                    object:[NSNumber numberWithFloat:i/(numberOfEvents*2.0)]];
        }
        [dbManager setLastEventsChecksum:eventsChecksum];
        [dbManager setNumberOfEventsChecksums:numberOfEvents];
    }
    if (![eventsDatesChecksum isEqualToString:[dbManager getLastEventsDatesChecksum]])
    {
        for (int i = 0; i < numberOfEventsDates; i++)
        {                        NSString *eventDatesChecksumFromJSON = [checksums objectForKey:[NSString stringWithFormat:@"termin%d", i]];
            NSString *eventDatesChecksumFromDB = [dbManager getChecksumWithEventDatesNumber:i];
            if (![eventDatesChecksumFromJSON isEqualToString:eventDatesChecksumFromDB])
            {
                [self setUrlToEventsDatesJSON:[NSString stringWithFormat:@"%@termin%d.json", JSONS_PATH, i]];
                [self updateEventsData];
                [dbManager saveChecksum:eventDatesChecksumFromJSON withEventsDatesNumber:i];
            }
            if (i % (numberOfEventsDates/10) == 0)
                [[NSNotificationCenter defaultCenter] postNotificationName:@"DownloadProgress"
                                                                    object:[NSNumber numberWithFloat:0.5+i/(numberOfEventsDates*2.0)]];
        }
        [dbManager setLastEventsDatesChecksum:eventsDatesChecksum];
        [dbManager setNumberOfEventsDatesChecksums:numberOfEventsDates];
    }
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
    //return [data mutableObjectFromJSONData];
    return [[self jsonDecoder] objectWithData:data];
}
- (BOOL)checkConnection
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];  
    NetworkStatus networkStatus = [reachability currentReachabilityStatus]; 
    return !(networkStatus == NotReachable);
}
- (void)dealloc
{
    [self.urlToMainJSON release];
    [self.urlToEventsJSON release];
    [self.urlToEventsDatesJSON release];
    [super dealloc];
}
@end
