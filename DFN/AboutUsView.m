//
//  AboutUsView.m
//  DFN
//
//  Created by Radoslaw Wilczak on 09.04.2012.
//  Copyright (c) 2012 pawel.jankowski@me.com. All rights reserved.
//

#import "AboutUsView.h"
#import "MessageUI/MFMailComposeViewController.h"

@implementation AboutUsView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)setAuthor:(NSString*)description onButton:(UIButton*)button
{
    [button setTitle:description forState:UIControlStateNormal];
    [button.titleLabel setLineBreakMode:UILineBreakModeWordWrap];
    [button.titleLabel setTextAlignment:UITextAlignmentCenter];
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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"O nas";
    scrollView.contentSize = subView.frame.size;
    
    [subView setBackgroundColor:[UIColor clearColor]];
    [self setAuthor:@"Paweł Nużka\npawelqus@gmail.com" onButton:button1];
    [self setAuthor:@"Radek Wilczak\nradekwilczak@gmail.com" onButton:button2];
    [self setAuthor:@"Michał Jodko\nthe.kazior@gmail.com" onButton:button3];
    [self setAuthor:@"Marcin Raburski\nrabursky@gmail.com" onButton:button4];
    [self setAuthor:@"Eugeniusz Keptia\nedzio27@gmail.com" onButton:button5];
    [self.view addSubview:subView];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (IBAction)button1Clicked:(id)sender {
    NSArray *array = [NSArray arrayWithObjects:@"pawelqus@gmail.com", nil];
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    
    if([MFMailComposeViewController canSendMail])
    {
        [controller setToRecipients:array];
        [self presentModalViewController:controller animated:YES];   
    }     
}
- (IBAction)button2Clicked:(id)sender {
    NSArray *array = [NSArray arrayWithObjects:@"radekwilczak@gmail.com", nil];
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    
    if([MFMailComposeViewController canSendMail])
    {
        [controller setToRecipients:array];
        [self presentModalViewController:controller animated:YES];   
    }     
}
- (IBAction)button3Clicked:(id)sender {
    NSArray *array = [NSArray arrayWithObjects:@"the.kazior@gmail.com", nil];
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    
    if([MFMailComposeViewController canSendMail])
    {
        [controller setToRecipients:array];
        [self presentModalViewController:controller animated:YES];   
    }    
}
- (IBAction)button4Clicked:(id)sender {    
    NSArray *array = [NSArray arrayWithObjects:@"rabursky@gmail.com", nil];
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    
    if([MFMailComposeViewController canSendMail])
    {
        [controller setToRecipients:array];
        [self presentModalViewController:controller animated:YES];   
    }
}
- (IBAction)button5Clicked:(id)sender {
    NSArray *array = [NSArray arrayWithObjects:@"edzio27@gmail.com", nil];
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    
    if([MFMailComposeViewController canSendMail])
    {
        [controller setToRecipients:array];
        [self presentModalViewController:controller animated:YES];   
    }
}
@end
