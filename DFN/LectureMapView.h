//
//  LectureMapView.h
//  DFN
//
//  Created by Marcin Raburski on 24.03.2012.
//  Copyright (c) 2012 pawel.jankowski@me.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "DatabaseManager.h"

@interface LectureMapView : UIViewController {
    Event *event;
    IBOutlet MKMapView *mapView;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil lecture:(Event*)_event;
- (IBAction)openMap:(id)sender;

@end
