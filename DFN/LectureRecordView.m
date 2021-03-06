//
//  LectureRecordView.m
//  DFN
//
//  Created by Lion User on 13/05/2012.
//  Copyright (c) 2012 Keptia.Eugeniusz All rights reserved.
//


#import "LectureRecordView.h"
#import "MessageUI/MFMailComposeViewController.h"
#import "MainCategoryListView.h"
#import "DatabaseManager.h"

@implementation LectureRecordView

@synthesize myEmail = _myEmail;
@synthesize address = _address;
@synthesize data    = _data;
@synthesize time    = _time;

- (IBAction)confirmData:(id)sender
{
    filePath = [[NSBundle mainBundle] pathForResource:@"imiona" ofType:@"csv"];
    fileContent = [NSString stringWithContentsOfFile:filePath encoding: NSUTF8StringEncoding error:nil];
    arrayWithNames = [fileContent componentsSeparatedByString:@"\n"];
    NSString *temporaryName = myName.text;
    NSString *surname = mySurname.text;
    NSString *email = self.myEmail;
    
    if(temporaryName.length < 3)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Zbyt krótkie imię!" message:@"Prosimy, podaj swoje imię jeszcze raz" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else if(surname.length < 3)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Zbyt krótkie nazwisko!" message:@"Prosimy, podaj swoje nazwisko jeszcze raz" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    else {
        NSString *emailContent, *sex;
        NSInteger i = [self getPositionName:lecturer]; 
        DatabaseManager *dbManager = [DatabaseManager sharedInstance];
        [dbManager createUserWithName:myName.text withSurname:mySurname.text];
        if ( i != -1 ) {
            sex = [self getSex:i];
        }
        else {
            sex = @"U";
        }
        emailContent = [self generateMail:sex andName:temporaryName andSurname:surname];
        [self sendEmail:email andEmailContent:emailContent];
        
        [self viewDidLoad];
    }
}

- (void) mainFunction
{
    filePath = [[NSBundle mainBundle] pathForResource:@"imiona" ofType:@"csv"];
    fileContent = [NSString stringWithContentsOfFile:filePath encoding: NSUTF8StringEncoding error:nil];
    arrayWithNames = [fileContent componentsSeparatedByString:@"\n"];        
    [self viewDidLoad];
}

- (void) setLecturerName:(NSString *)lecturerName
{
    lecturer = lecturerName;
}

- (NSInteger) getPositionName:(NSString *)name
{
    for (int i = 0; i < [arrayWithNames count]; i++)
    {
        NSArray *temporaryArray = [[arrayWithNames objectAtIndex:i] componentsSeparatedByString:@";"];
        NSArray *nameArray = [name componentsSeparatedByString:@" "];
        for(int j = 0; j < [nameArray count]; j++)
        {
            if ( [[nameArray objectAtIndex:j] isEqualToString:[temporaryArray objectAtIndex:0]])
            {
                return i;
            }
        }
    }
    return -1;
}

- (NSString *) getSex:(int)positionOfName
{
    if ( positionOfName != -1 ) {
        NSArray *temporaryArray = [[arrayWithNames objectAtIndex:positionOfName] componentsSeparatedByString:@";"];
        NSCharacterSet *charToTrim = [NSCharacterSet characterSetWithCharactersInString:@"\""];
        NSString *temporaryString = [[temporaryArray objectAtIndex:2] stringByTrimmingCharactersInSet:charToTrim];   
        return temporaryString;
    }
    else {
        return @"U";
    }
}

- (NSString *) generateMail:(NSString *)sex andName:(NSString *)name andSurname:(NSString *)surname
{
    sex = [sex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ( [sex isEqualToString:@"K"] ){
        return [NSString stringWithFormat:@"Szanowna Pani\n\nChcę wziąć udział w wydarzeniu %@, które odbędzie się:\ndnia: %@ \no godzinie: %@\nw: %@\n\nPozdrawiam %@ %@\n\nMail został automatycznie wygenerowany za pomocą oficjalnej aplikacji Dolnośląskiego Festiwalu Nauki na urządzenia mobilne.", event, self.data, self.time, self.address, name, surname];
    }
    if ( [sex isEqualToString:@"M"] ){
        return [NSString stringWithFormat:@"Szanowny Panie\n\nChcę wziąć udział w wydarzeniu %@, które odbędzie się:\ndnia: %@ \no godzinie: %@\nw: %@\n\nPozdrawiam %@ %@\n\nMail został automatycznie wygenerowany za pomocą oficjalnej aplikacji Dolnośląskiego Festiwalu Nauki na urządzenia mobilne.", event, self.data, self.time, self.address, name, surname];
    }
    else {
        return [NSString stringWithFormat:@"Szanowni Państwo\n\nChcę wziąć udział w wydarzeniu %@, które odbędzie się:\ndnia: %@ \no godzinie: %@\nw: %@\n\nPozdrawiam %@ %@\n\nMail został automatycznie wygenerowany za pomocą oficjalnej aplikacji Dolnośląskiego Festiwalu Nauki na urządzenia mobilne.", event, self.data, self.time, self.address, name, surname];
    }
}

- (void) sendEmail:(NSString *)email andEmailContent:(NSString *)emailContent 
{
    NSArray *array = [NSArray arrayWithObjects:self.myEmail, nil];
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    [controller autorelease];
    controller.mailComposeDelegate = self;
    
    if([MFMailComposeViewController canSendMail])
    {
        [controller setSubject:event];
        [controller setToRecipients:array];
        [controller setMessageBody:emailContent isHTML:NO]; 
        [self presentModalViewController:controller animated:YES];   
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    if (result == MFMailComposeResultSent) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Wysłano wiadomość!" message:@"Twoja wiadomość została wysłana, dziękujemy!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        [alert release];
        [self dismissModalViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"Subscribed" object:nil]];
        [Flurry logEvent:@"DidRegister" withParameters:@{@"event": event}];
    } 
    if (result == MFMailComposeResultFailed) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Nie wysłano wiadomości!" message:@"Niestety Twoja wiadomość nie została wysłana!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        [alert release];
        [self dismissModalViewControllerAnimated:YES];
    }
    if (result == MFMailComposeResultCancelled) {
        [self dismissModalViewControllerAnimated:YES];
    }
    if (result == MFMailComposeResultSaved )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Zachowano wiadomość!" message:@"Twoja wiadomość została zapisana!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        [alert release];
        [self dismissModalViewControllerAnimated:YES];
    }
    [self dismissModalViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void) setEventName:(NSString *)eventName
{
    event = eventName;
}

- (void) setEventData:(EventDate *)eventData
{
    NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
    NSDateFormatter *timeFormat = [[[NSDateFormatter alloc] init] autorelease];
    
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    [timeFormat setDateFormat:@"HH:mm:ss"];
    
    self.data = [dateFormat stringFromDate:eventData.openingHour];
    self.time = [timeFormat stringFromDate:eventData.openingHour];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Zapisy";
	// Do any additional setup after loading the view.
    [myName becomeFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
