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
@interface LectureRecordView ()

@end

@implementation LectureRecordView

- (IBAction)confirmData:(id)sender
{
    filePath = [[NSBundle mainBundle] pathForResource:@"imiona" ofType:@"csv"];
    fileContent = [NSString stringWithContentsOfFile:filePath encoding: NSUTF8StringEncoding error:nil];
    arrayWithNames = [fileContent componentsSeparatedByString:@"\n"];
    NSString *temporaryName = myName.text;
    NSString *surname = mySurname.text;
    NSString *email = myEmail;
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValidEmail = [emailTest evaluateWithObject:email];
    
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
    else if(!isValidEmail)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Niepoprawny adres mailowy!" message:@"Prosimy, podaj email jeszcze raz" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }    
    else {

        NSString *emailContent, *convertedName, *sex;
        NSInteger i = [self getPositionName:temporaryName]; 
        DatabaseManager *dbManager = [DatabaseManager sharedInstance];
        [dbManager createUserWithName:myName.text withSurname:mySurname.text];

        if ( i != -1 ) {
            convertedName = [ self getName:i];
            sex = [self getSex:i];
        }
        else {
            convertedName = temporaryName;
            UniChar lastLetter = [temporaryName characterAtIndex:[temporaryName length] - 1];
            sex = ( lastLetter == 'a' || lastLetter == 'A')  ? (@"K") : (@"M");
        }
    
        emailContent = [self generateMail:sex andName:convertedName andSurname:surname];
        [self sendEmail:email andEmailContent:emailContent];
        [self viewDidLoad];
    }
}

- (NSInteger) getPositionName:(NSString *)name
{
    for (int i = 0; i < [arrayWithNames count]; i++)
    {
        NSArray *temporaryArray = [[arrayWithNames objectAtIndex:i] componentsSeparatedByString:@";"];
        NSCharacterSet *charToTrim = [NSCharacterSet characterSetWithCharactersInString:@"\""];
        NSString *temporaryString = [[temporaryArray objectAtIndex:0] stringByTrimmingCharactersInSet:charToTrim];
        if ( [name isEqualToString:temporaryString] )
        {
            return i;
        }
    }
    return -1;
}

- (NSString *) getName:(int)positionOfName
{
    NSArray *temporaryArray = [[arrayWithNames objectAtIndex:positionOfName] componentsSeparatedByString:@";"];
    NSCharacterSet *charToTrim = [NSCharacterSet characterSetWithCharactersInString:@"\""];
    NSString *temporaryString = [[temporaryArray objectAtIndex:1] stringByTrimmingCharactersInSet:charToTrim];
    return temporaryString;
}

- (NSString *) getSex:(int)positionOfName
{
    NSArray *temporaryArray = [[arrayWithNames objectAtIndex:positionOfName] componentsSeparatedByString:@";"];
    NSCharacterSet *charToTrim = [NSCharacterSet characterSetWithCharactersInString:@"\""];
    NSString *temporaryString = [[temporaryArray objectAtIndex:2] stringByTrimmingCharactersInSet:charToTrim];    
    return temporaryString;
    
}

- (NSString *) generateMail:(NSString *)sex andName:(NSString *)name andSurname:(NSString *)surname
{
    sex = [sex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ( [sex isEqualToString:@"K"] ){
        return [NSString stringWithFormat:@"Szanowny Panie\n\nChce wziąć udział w wydarzeniu %@, które odbędzie się:\ndnia: %@ \no godzinie: %@\n\nPozdrawiam %@ %@\n\nMail został automatycznie wygenerowany za pomocą oficjalnej aplikacji Dolnośląskiego Festiwalu Nauki na urządzenia mobilne.", event, data, time, name, surname];
    }
    else {
        return [NSString stringWithFormat:@"Szanowna Pani\n\nChce wziąć udział w wydarzeniu %@, które odbędzie się:\ndnia: %@ \no godzinie: %@\n\nPozdrawiam %@ %@\n\nMail został automatycznie wygenerowany za pomocą oficjalnej aplikacji Dolnośląskiego Festiwalu Nauki na urządzenia mobilne.", event, data, time, name, surname];
    }
}

- (void) sendEmail:(NSString *)email andEmailContent:(NSString *)emailContent 
{
    NSArray *array = [NSArray arrayWithObjects:email, nil];
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
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
}

- (void) setEventName:(NSString *)eventName
{
    event = eventName;
}

- (void) setMyEmail:(NSString *)email
{
    myEmail = email;
}

- (void) setEventData:(EventDate *)eventData
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    [timeFormat setDateFormat:@"HH:mm:ss"];
    NSString *tmp_data = [dateFormat stringFromDate:eventData.openingHour];
    data = [tmp_data mutableCopy];
    NSString *tmp_time = [timeFormat stringFromDate:eventData.openingHour];
    time = [tmp_time mutableCopy];
    [dateFormat release];
    [timeFormat release];

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
    self.title = @"Wypełnij dane";
	// Do any additional setup after loading the view.
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
