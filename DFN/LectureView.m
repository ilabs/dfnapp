//
//  LectureView.m
//  DFN
//
//  Created by Marcin Raburski on 08.03.2012.
//  Copyright (c) 2012 pawel.jankowski@me.com. All rights reserved.
//

#import "LectureView.h"
#import "LecturersView.h"
#import "LectureMapView.h"
#import <QuartzCore/QuartzCore.h>

@implementation LectureView

@synthesize navigationController = _nav;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil lecture:(Event*)_event {
    if(self=[self initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        event = [_event retain];
    }
    return self;
}

- (IBAction)showOnMap:(id)sender {
    LectureMapView *lview = [[[LectureMapView alloc] initWithNibName:@"LectureMapView" bundle:nil lecture:event] autorelease];
    [_nav pushViewController:lview animated:YES];
}
- (IBAction)showLecturers:(id)sender {
    LecturersView *lview = [[[LecturersView alloc] initWithNibName:@"LecturersView" bundle:nil lecture:event] autorelease];
    [_nav pushViewController:lview animated:YES];
}
- (IBAction)signIn:(id)sender {
    
}
- (IBAction)showCalendar:(id)sender {
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _nav = nil;
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

    [titleLabel setText:event.title];
    [placeLabel setText:event.place.address];
    [placeCityLabel setText:event.place.city];
    if(event.place.numberOfFreePlaces>0){
        [numberOfPlacesLabel setText:event.place.numberOfFreePlaces];
    }else{
        [numberOfPlacesLabel setText:@"Brak ograniczenia"];
    }
    [organisationLabel setText:event.organisation.name];
    [dateLabel setText:[event.dates description]];
    if([event.place.gpsCoordinates length]>0){
        [mapButton setHidden:NO];
    }
    // TODO to samo z sign in button
    
    NSMutableString *tekst = [[[NSMutableString alloc] init] autorelease];
    for(EventForm* form in event.forms)
    {
        if([tekst length]>0)
            [tekst appendString:@", "];
        [tekst appendString:form.name];
    }
    [eventFormLabel setText:tekst];
    // TODO czemu Data to SET ?
    // NSDate to jest, tak?
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy 'o' HH:mm"];
    dateLabel.text = @"";
    for(NSDate *date in event.dates)
    {
        dateLabel.text = [dateLabel.text stringByAppendingFormat:@"%s\r\n" ,[dateFormatter stringFromDate:date]];
    }
    [dateFormatter release];
    switch (event.dates.count) {
        case 0:
            dateLabel.text = @"Na razie nieznane";
            break;
        case 1:
            dateLabel.font = [UIFont systemFontOfSize:24];
            break;
        case 2:
            dateLabel.font = [UIFont systemFontOfSize:20];
            break;
        case 3:
            dateLabel.font = [UIFont systemFontOfSize:16];
            break;
        case 4:
            dateLabel.font = [UIFont systemFontOfSize:14];
            break;
        default:
            break;
    }
    
    self.title = @"Impreza";
    
    UIView *round = [viewBase viewWithTag:2];
    while(round!=nil){
        round.layer.borderWidth = 1;
        round.layer.cornerRadius = 12;
        round.layer.borderColor = [[UIColor grayColor] CGColor];
        round.backgroundColor = [UIColor whiteColor];
        round.tag = 0;
        round.alpha = 0.95;
        round.layer.shadowOffset = CGSizeMake(0,0);
        round.layer.shadowRadius = 8;
        round.layer.shadowOpacity = 0.2;
        round = [viewBase viewWithTag:2];
    }
    
    viewBase.backgroundColor = [UIColor clearColor];
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
