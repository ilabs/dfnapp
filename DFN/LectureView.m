//
//  LectureView.m
//  DFN
//
//  Created by Marcin Raburski on 08.03.2012.
//  Copyright (c) 2012 pawel.jankowski@me.com. All rights reserved.
//

#import "LectureView.h"
#import "LecturersView.h"
#import "LectureCalendarView.h"

@implementation LectureView


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil lecture:(Event*)_event {
    if(self=[self initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        event = [_event retain];
    }
    return self;
}

- (IBAction)showOnMap:(id)sender {
    NSString *url;
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if([language isEqual:@"pl"] || [language isEqual:@"pol"]){
        language = @"Bieżące położenie";
    }else{
        language = @"Current Location";
    }
    if([event.place.gpsCoordinates length]>0){
        url = [NSString stringWithFormat:@"http://maps.google.com/maps?daddr=%@&saddr=%@",event.place.gpsCoordinates, language];
    }else{
        url = [NSString stringWithFormat:@"http://maps.google.com/maps?daddr=%@&saddr=%@, %@",event.place.address, event.place.city, language];
    }
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    /*LectureMapView *lview = [[[LectureMapView alloc] initWithNibName:@"LectureMapView" bundle:nil lecture:event] autorelease];
    [self.navigationController pushViewController:lview animated:YES];*/
}
- (IBAction)showLecturers:(id)sender {
    LecturersView *lview = [[[LecturersView alloc] initWithNibName:@"LecturersView" bundle:nil lecture:event] autorelease];
    [self.navigationController pushViewController:lview animated:YES];
}
- (IBAction)signIn:(id)sender {
    
}
- (IBAction)showCalendar:(id)sender {
    LectureCalendarView *lview = [[[LectureCalendarView alloc] initWithNibName:@"LectureCalendarView" bundle:nil lecture:event] autorelease];
    [self.navigationController pushViewController:lview animated:YES];
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

    [titleLabel setText:event.title];
    [placeLabel setText:[event.place.address stringByReplacingOccurrencesOfString:@", " withString:@"\r\n"]];
    [placeCityLabel setText:event.place.city];
    if(![event.place.numberOfFreePlaces isEqualToString:@"0"]){
        [numberOfPlacesLabel setText:event.place.numberOfFreePlaces];
    }else{
        [numberOfPlacesLabel setText:@"∞"];
         numberOfPlacesLabel.font = [UIFont systemFontOfSize:32];
    }
    [organisationLabel setText:event.organisation.name];
    [dateLabel setText:[event.dates description]];
    /*if([event.place.gpsCoordinates length]>0){
        [mapButton setHidden:NO];
    }*/
    // TODO to samo z sign in button
    
    NSMutableString *tekst = [[[NSMutableString alloc] init] autorelease];
    NSLog(@"forms: %@",event.forms);
    for(EventForm* form in event.forms)
    {
        if([tekst length]>0)
            [tekst appendString:@", "];
        [tekst appendString: [((EventFormType*) form.eventFormType) name]];
    }
    [eventFormLabel setText:tekst];
    
    if(event.dates!=nil){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSDateFormatter *dateFormatterHour = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MM-yyyy"];
        [dateFormatterHour setDateFormat:@"HH:mm"];
        dateLabel.text = @"";
        for(EventDate *date in event.dates)
        {
            //NSLog(@"datattt: %@",date.day);
            //NSLog(@"data: %@",[dateFormatter stringFromDate:date]);
            dateLabel.text = [dateLabel.text stringByAppendingFormat:@"%@, %@ - %@\r\n" ,[dateFormatter stringFromDate:date.day], [dateFormatterHour stringFromDate:date.openingHour], [dateFormatterHour stringFromDate:date.closingHour]];
        }
        [dateFormatter release];
        [dateFormatterHour release];
        switch (event.dates.count) {
            case 0:
                dateLabel.text = @"Na razie nieznane";
                break;
            case 1:
                dateLabel.font = [UIFont systemFontOfSize:23];
                break;
            case 2:
                dateLabel.font = [UIFont systemFontOfSize:20];
                break;
            case 3:
                dateLabel.font = [UIFont systemFontOfSize:16];
                break;
            case 4:
                dateLabel.font = [UIFont systemFontOfSize:12];
                break;
            default:
                dateLabel.font = [UIFont systemFontOfSize:12];
                break;
        }
    }else{
        dateLabel.text = @"Na razie nieznane";
    }
    self.title = @"Impreza";
    
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
