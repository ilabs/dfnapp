//
//  LectureMapView.m
//  DFN
//
//  Created by Marcin Raburski on 24.03.2012.
//  Copyright (c) 2012 pawel.jankowski@me.com. All rights reserved.
//

#import "LectureMapView.h"

@implementation LectureMapView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil lecture:(Event*)_event {
    if(self=[self initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        event = _event;
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)openMap:(id)sender {
    NSString *url = [NSString stringWithFormat:@"http://maps.google.com/maps?daddr=%@&saddr=Current Location",event.place.gpsCoordinates];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
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
    self.title = @"Mapa";
    NSArray *arr = [event.place.gpsCoordinates componentsSeparatedByString:@","];
    CLLocationCoordinate2D coord = {.latitude = [[arr objectAtIndex:0] floatValue], .longitude = [[arr objectAtIndex:1] floatValue]};
    MKCoordinateSpan span = {.latitudeDelta =  0.03, .longitudeDelta =  0.03};
    MKCoordinateRegion region = {coord, span};
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = coord;
    point.title = event.place.address;
    
    [mapView addAnnotation:point];
    [mapView setRegion:region];
    
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

@end
