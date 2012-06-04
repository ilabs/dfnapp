//
//  DataFetcher.m
//  DFN
//
//  Created by Pawel Nuzka on 3/17/12.
//  Copyright (c) 2012 Pawel.Nuzka@gmail.com. All rights reserved.
//

#import "DataFetcher.h"

#define JSONS_PATH @"http://dfn.coijak.pwr.wroc.pl/iphone/"
#define MAIN_JSON_PATH @"http://dfn.coijak.pwr.wroc.pl/iphone/checksums.json"
#define STATIC_JSON_PATH @"http://dfn.coijak.pwr.wroc.pl/iphone/imprezy.json"
#define DYNAMIC_JSON_PATH @"http://dfn.coijak.pwr.wroc.pl/iphone/terminy.json"

@implementation DataFetcher
@synthesize urlToMainJSON, urlToEventsJSON, urlToEventsDatesJSON, xsdDateTimeFormatter;

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
            [master setXsdDateTimeFormatter:[[NSDateFormatter alloc] init]];
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
    self.xsdDateTimeFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = nil;
    date = [self.xsdDateTimeFormatter dateFromString: dateTime];
    return (date);
}
-(NSDate *)xsdDateToNSDate:(NSString *)dateTime {
    self.xsdDateTimeFormatter.dateFormat = @"yyyy-MM-dd";
    NSDate *date = nil;
    date = [self.xsdDateTimeFormatter dateFromString: dateTime];
    return (date);
}
-(NSDate *)xsdDateTimeToNSDate:(NSString *)dateString andTime:(NSString *)time {
    NSMutableString *datetime = [NSMutableString stringWithFormat:@"%@", dateString];
    [datetime appendFormat:@";"];
    [datetime appendString:time];
    self.xsdDateTimeFormatter.dateFormat = @"yyyy-MM-dd;HH:mm:ss";
    NSDate *date = nil;
    date = [self.xsdDateTimeFormatter dateFromString: datetime];
    return (date);
}
- (void)notifyUpdatedEvent:(Event *)dbEvent
{
    if ([[DatabaseManager sharedInstance] isWatched:dbEvent])
    {
        [dbEvent setShowAsUpdated:[NSNumber numberWithBool:YES]];
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"Event updated" object:[dbEvent dbID]]];
    }
}
- (void)updateEvent:(Event *)dbEvent withForm:(NSString *)form
{
    DatabaseManager * dbManager = [DatabaseManager sharedInstance];
    EventFormType *dbEventFormType = [dbManager getEventFormTypeWithId:form];
    [dbEventFormType setName:form];
    EventForm * dbEventForm = [dbManager getEventFormWithId:
                               [NSString stringWithFormat:@"%@1", dbEvent.dbID]];
    if (!dbEventForm)     //nie istnieje forma 1, tworzymy wiec nowa, nie ma update'u
    {
        dbEventForm = [dbManager createEventForm];
        [dbEventForm setDbID:[NSString stringWithFormat:@"%@1", dbEvent.dbID]];
        [dbEventForm setEventFormType:dbEventFormType];
        [dbEventFormType addEventFormsObject:dbEventForm];
        [dbEventForm setEvent:dbEvent];
    }
    else          //forma juz istnieje, byc moze cos sie zmienilo
    {
        
        if (dbEventForm.eventFormType != dbEventFormType)
        {
            [dbEventForm setEventFormType:dbEventFormType];
            [dbEventFormType addEventFormsObject:dbEventForm];
            [self notifyUpdatedEvent:dbEvent];
        }
        if (dbEventForm.event != dbEvent)
        {
            [dbEvent addFormsObject:dbEventForm];
            [dbEventForm setEvent:dbEvent];
            [self notifyUpdatedEvent:dbEvent];
        }
    }
    
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
        //     [dbManager refreshState];
        NSLog(@"%d %@",i, [event description] );
        i++;
        Event * dbEvent = [dbManager getEventWithId:[event objectForKey:@"id_imprezy"]];
        if (!dbEvent)
        {
            dbEvent = [dbManager createEvent];
            [dbEvent setDbID:[event objectForKey:@"id_imprezy"]];
        }
        id ID = [event objectForKey:@"forma1"];
        ID = [event objectForKey:@"forma1"];
        if ([ID isKindOfClass:[NSString class]] && ![[ID description] isEqualToString:@"<null>"])
            [self updateEvent:dbEvent withForm:(NSString *)ID];
        
        ID = [event objectForKey:@"forma2"];
        if ([ID isKindOfClass:[NSString class]] && ![[ID description] isEqualToString:@"<null>"])
            [self updateEvent:dbEvent withForm:(NSString *)ID];
        
        ID = [event objectForKey:@"forma3"];
        if ([ID isKindOfClass:[NSString class]] && ![[ID description] isEqualToString:@"<null>"])
            [self updateEvent:dbEvent withForm:(NSString *)ID];
        
        ID = [event objectForKey:@"kategoria"];
        if ([ID isKindOfClass:[NSString class]])
        {
            //To jeszcze nie działa do końca!!!
            Category *dbCategory = [dbManager getCategoryWithId:(NSString *)ID];
            if (dbEvent.category != dbCategory || ![dbCategory.name isEqualToString:(NSString *)ID])
            {
                [dbCategory setName:(NSString *)ID];
                [dbEvent setCategory:dbCategory];
                [self notifyUpdatedEvent:dbEvent];
            }
            ID = [event objectForKey:@"panel_id"];
            if ([ID isKindOfClass:[NSString class]] && ![ID isEqualToString:@"11"] && ![ID isEqualToString:@"5"])
            {
                Section * dbSection = [dbManager getSectionWithId:(NSString *)ID];
                ID = [event objectForKey:@"panel"];
                NSArray *listItems = [(NSString *)ID componentsSeparatedByString:@"/"];
                if (dbCategory.section != dbSection || ![dbSection.name isEqualToString:(NSString *)ID])
                {
                    [dbSection setName:[listItems objectAtIndex:0]];
                    [dbCategory setSection:dbSection];
                    [dbSection addCategoriesObject:dbCategory];
                    [self notifyUpdatedEvent:dbEvent];
                }
            }
        }
        
        ID = [event objectForKey:@"opis"];
        if ([ID isKindOfClass:[NSString class]])
            [dbEvent setDescriptionContent:[(NSString *)ID stringByReplacingOccurrencesOfString:@"\\&quot;" withString:@"\""]]; 
        ID = [event objectForKey:@"organizacja"];
        if ([ID isKindOfClass:[NSString class]])
        {
            Organisation *dbOrganisation = [dbManager getOrganistationWithId:(NSString *)ID];
            [dbOrganisation setName:(NSString *)ID];
            [dbEvent setOrganisation:dbOrganisation];
        }
        ID = [event objectForKey:@"poprawial_data"];
        if ([ID isKindOfClass:[NSString class]])
        {
            NSDate *lastUpdate = [self jsonDateAndTimeToNSDate:(NSString *)ID];
            if (![lastUpdate isEqualToDate:dbEvent.lastUpdate])
            {
                [dbEvent setLastUpdate:lastUpdate];
                [self notifyUpdatedEvent:dbEvent];
            }
        }
        ID = [event objectForKey:@"prowadzacy"];
        if ([ID isKindOfClass:[NSString class]])
            [dbEvent setLecturer:[(NSString *)ID stringByReplacingOccurrencesOfString:@"\\&quot;" withString:@"\""]]; 
        ID = [event objectForKey:@"zapisy"];
        if ([ID isKindOfClass:[NSString class]])
            [dbEvent setSubscription:(NSString *)ID];
        ID = [event objectForKey:@"prowadzacy_afiliacje"];
        if ([ID isKindOfClass:[NSString class]])
            [dbEvent setLecturersTitle:(NSString *)ID];
        ID = [event objectForKey:@"tytul_imprezy"];
        if ([ID isKindOfClass:[NSString class]])
            [dbEvent setTitle:[(NSString *)ID stringByReplacingOccurrencesOfString:@"\\&quot;" withString:@"\""]]; 
        
        if (i % (all/10) == 0 && showProgress)
        {
            //       [dbManager saveDatabase];
            //       [dbManager refreshState];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DownloadProgress"
                                                                object:[NSNumber numberWithFloat:i/(all*2.0)]];
        }
        
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
            ID = [eventDatesData objectForKey:@"id_termin"];
            EventDate *dbDate = [dbManager getEventDateWithId:(NSString *)ID];
            if (!dbDate)
            {
                dbDate = [dbManager createEventDate];
                [dbDate setDbID:(NSString *)ID];
            }
            NSDate *previousDay = dbDate.day;
            NSDate *previousOpeningHour = dbDate.openingHour;
            NSDate *previousClosingHour = dbDate.closingHour;
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
            
            if (![previousDay isEqualToDate:dbDate.day] || ![previousOpeningHour isEqualToDate:dbDate.openingHour]
                || ![previousClosingHour isEqualToDate:dbDate.closingHour])
                [self notifyUpdatedEvent:dbEvent];
            
            ID = [eventDatesData objectForKey:@"lokalizacja"];
            if ([ID isKindOfClass:[NSString class]])
            {
                ID = [eventDatesData objectForKey:@"id_miejsce"];
                Place *dbPlace = [dbManager getPlaceWithId:(NSString *)ID];
                if (!dbPlace)
                {
                    dbPlace = [dbManager createPlace];
                    [dbPlace setDbID:(NSString *)ID];
                }
                if (dbEvent.place != dbPlace)
                {
                    [dbPlace addEventObject:dbEvent];
                    [dbEvent setPlace:dbPlace];
                    [self notifyUpdatedEvent:dbEvent];
                }
                ID = [eventDatesData objectForKey:@"lokalizacja"];
                if (![dbPlace.address isEqualToString:(NSString *)ID])
                {
                    [dbPlace setAddress:(NSString *)ID];
                    [self notifyUpdatedEvent:dbEvent];
                }
                
                ID = [eventDatesData objectForKey:@"miasto"];
                if ([ID isKindOfClass:[NSString class]])
                {
                    if (![dbPlace.city isEqualToString:(NSString *)ID])
                    {
                        
                        [dbPlace setCity:(NSString *)ID];
                        [self notifyUpdatedEvent:dbEvent];
                    }
                }
                ID = [eventDatesData objectForKey:@"ilosc_miejsc"];
                if ([ID isKindOfClass:[NSString class]])
                {
                    if (![dbPlace.numberOfFreePlaces isEqualToString:(NSString *)ID])
                    {
                        [dbPlace setNumberOfFreePlaces:(NSString *)ID];
                        [self notifyUpdatedEvent:dbEvent];
                    }
                }
            }
        }
        if (i % (all/10) == 0 && showProgress)
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DownloadProgress"
                                                                object:[NSNumber numberWithFloat:0.5+i/(all*2.0)]];
    }
}
- (void)updateData
{
    //NSLog(@"Jestem tu! %@", self.urlToMainJSON);
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
    [self.xsdDateTimeFormatter release];
    [super dealloc];
}
@end
