//
//  LectureRecordView.h
//  DFN
//
//  Created by Lion User on 13/05/2012.
//  Copyright (c) 2012 Keptia.Eugeniusz All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignInView.h"
#import "MessageUI/MFMailComposeViewController.h"

@interface LectureRecordView : UIViewController
<MFMailComposeViewControllerDelegate, UINavigationControllerDelegate>
{
    IBOutlet UITextField *myName, *mySurname, *myEmail;
    NSArray *arrayWithNames;
    NSString *event, *data, *time, *filePath, *fileContent;
    
}
- (IBAction)confirmData:(id)sender;
- (NSInteger) getPositionName:(NSString *) name;
- (NSString *) getName: (int) positionOfName;
- (NSString *) getSex: (int) positionOfName;
- (void) setEventName:(NSString *) eventName;
- (void) setEventData:(EventDate *) eventData;
- (NSString *) generateMail: (NSString *) sex andName:(NSString *) name andSurname:(NSString *) surname;
- (void) sendEmail: (NSString *) email andEmailContent:(NSString *) emailContent;
@end
