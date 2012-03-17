//
//  LectureView.m
//  DFN
//
//  Created by Marcin Raburski on 08.03.2012.
//  Copyright (c) 2012 pawel.jankowski@me.com. All rights reserved.
//

#import "LectureView.h"

@implementation LectureView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil lecture:(Event*)_event {
    if(self=[self initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        event = [_event retain];
    }
    return self;
}
- (IBAction)showOnMap:(id)sender {
    
}
- (IBAction)signIn:(id)sender {
    
}

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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    scrollView.frame = CGRectMake(0, 20, 320, 460);
    scrollView.contentSize = viewBase.frame.size;
    //scrollView.contentInset=UIEdgeInsetsMake(24.0,0.0,24.0,0.0);

    // dr Joanna Thannhauser, dr Wojciech Woźniak, dr Jakub Mędrek - jak jest kilku to podzielic
    NSString *lecturers_ = event.lecturer;
    int count = [[lecturers_ componentsSeparatedByString:@","] count];
    lecturers_ = [lecturers_ stringByReplacingOccurrencesOfString:@"," withString:@"\n"];
    lowerContent.frame = CGRectMake(0, lecturers.frame.origin.y+18*count, lowerContent.frame.size.width, lowerContent.frame.size.height);
    [title setText:event.title];
    [place setText:event.place.address];
    [placeCity setText:event.place.city];
    [numberOfPlaces setText:event.place.numberOfFreePlaces];
    [organisation setText:event.organisation.name];
    [lecturers setText:lecturers_];
    [date setText:[event.dates description]];
    
    if([event.place.gpsCoordinates length]>0){
        [mapButton setEnabled:YES];
    }
    // TODO to samo z sign in button
    
    // TODO czemu Data to SET ?
    
    self.title = @"Szczegóły";
    [scrollView addSubview:viewBase];
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

- (void)dealloc {
    [event release];
}

@end
