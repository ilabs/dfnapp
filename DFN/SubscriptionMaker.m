//
//  SubscriptionMaker.m
//  DFN
//
//  Created by Aleksander Kocieniewski on 18.04.2012.
//  Copyright (c) 2012 pawel.nuzka@gmail.com. All rights reserved.
//


#import "SubscriptionMaker.h"
#import "LectureRecordView.h"

@implementation SubscriptionMaker

@synthesize event;

-(NSString*) emailRegex:(NSString*) eventString 
{
    NSArray *ArrayOfTextCheckingResults;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:@"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?"
                                  options:NSRegularExpressionSearch
                                  error:nil];
    ArrayOfTextCheckingResults = [regex matchesInString:eventString options:NSRegularExpressionCaseInsensitive range:NSMakeRange(0, [eventString length])];
    NSString *MatchingString=nil;
    for (NSTextCheckingResult *Result in ArrayOfTextCheckingResults) {
        NSRange matchRange = [Result rangeAtIndex:0];
        MatchingString = [eventString substringWithRange:matchRange];
        DLog(@"Found string '%@'", MatchingString);
    }
    return MatchingString;
}


-(NSString*) phoneRegex:(NSString*) eventString 
{
    NSArray *ArrayOfTextCheckingResults;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:@"([+][0-9]{11})|([+][0-9]{2} [0-9]{3} [0-9]{3} [0-9]{3})|([0-9]{9})|([0-9]{3}-[0-9]{3}-[0-9]{3})|([0-9]{3} [0-9]{3} [0-9]{3}|([+][0-9]{2}[0-9]{3}-[0-9]{3}-[0-9]{3})|([0-9]{2} [0-9]{3} [0-9]{2} [0-9]{2}))"
                                  options:NSRegularExpressionSearch
                                  error:nil];
    ArrayOfTextCheckingResults = [regex matchesInString:eventString options:NSRegularExpressionCaseInsensitive range:NSMakeRange(0, [eventString length])];
    NSString *MatchingString=nil;
    for (NSTextCheckingResult *Result in ArrayOfTextCheckingResults) {
        NSRange matchRange = [Result rangeAtIndex:0];
        MatchingString = [eventString substringWithRange:matchRange];
        DLog(@"Found string '%@'", MatchingString);
    }
    return MatchingString;
}

-(NSString*) dateRegex:(NSString*) eventString 
{
    NSArray *ArrayOfTextCheckingResults;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:@"(([1-2][0-9]|3[0-1]|[1-9])\\.((0[1-9])|[1-12])\\.201[0-9])|(([1-2][0-9]|3[0-1]|[1-9])\\.((0[1-9])|[1-12]))"
                                  options:NSRegularExpressionSearch
                                  error:nil];
    NSRange stringRange = NSMakeRange(0, [eventString length]);
    ArrayOfTextCheckingResults = [regex matchesInString:eventString options:NSRegularExpressionCaseInsensitive range:stringRange];
    NSString *MatchingString=nil;
    for (NSTextCheckingResult *Result in ArrayOfTextCheckingResults) {
        NSRange matchRange = [Result rangeAtIndex:0];
        MatchingString = [eventString substringWithRange:matchRange];
        DLog(@"Found string '%@'", MatchingString);
    }
    return MatchingString;
}

-(void) sendEmailTo:(NSString *)to withSubject:(NSString *)subject withBody:(NSString *)body 
{
    NSString *mailString = [NSString stringWithFormat:@"mailto:?to=%@&subject=%@&body=%@",
                            [to stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
                            [subject stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
                            [body stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailString]];
    [Flurry logEvent:@"RegisteredForEvent" withParameters:@{@"eventTitle": event}];

}

- (void) makeCall:(NSString *)number
{
	NSString *cleanedString = [[number componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
	NSString *clearPhoneNumber = [cleanedString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", clearPhoneNumber]];
	[[UIApplication sharedApplication] openURL:telURL];
}

-(void)subscribeWithSubscripiton:(NSString *)subscription withDate:(EventDate *)date withTitle:(NSString *)title withLecturer:(NSString *)lecturer andNavigationView:(UINavigationController *)navController
{
    NSString * email = [self emailRegex:subscription];
    NSString * phone = [self phoneRegex:subscription];
    
    if (email)
    {
        DatabaseManager *dbManager = [DatabaseManager sharedInstance];
        if ([dbManager isUserSet])
        {
            LectureRecordView *lectureRecord = [[LectureRecordView alloc] initWithNibName:@"LectureRecordView" bundle:nil];
            [lectureRecord setLecturerName:lecturer];
            [lectureRecord setEventName:title];
            [lectureRecord setEventData:date];
            [lectureRecord setMyEmail:email];
            [lectureRecord setAddress:[[[date event] place] address]];
            [lectureRecord mainFunction];
            lectureRecord.view.backgroundColor = [UIColor clearColor];
            [lectureRecord.view setAlpha:0.0];
            [navController pushViewController:lectureRecord animated:YES];
            NSString * emailContent = [lectureRecord generateMail:[lectureRecord getSex:[lectureRecord getPositionName:lecturer]] andName:[dbManager userName] andSurname:[dbManager userSurname]];
            [lectureRecord sendEmail:email andEmailContent:emailContent];
            [lectureRecord release];
        }
        else
        {
            LectureRecordView *lectureRecord = [[LectureRecordView alloc] initWithNibName:@"LectureRecordView" bundle:nil];
            [lectureRecord setEventName:title];
            [lectureRecord setEventData:date];
            [lectureRecord setMyEmail:email];
            [lectureRecord setAddress:[[[date event] place] address]];
            [lectureRecord setLecturerName:lecturer];
            [navController pushViewController:lectureRecord animated:YES];
            lectureRecord.view.backgroundColor = [UIColor clearColor];
            [lectureRecord release];
        }
   }
   else if (phone)
   {
       //sprawdz date !
       [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"Subscribed" object:nil]];
       [self makeCall:phone];
   }
   
   
}

@end
