//
//  LectureView.h
//  DFN
//
//  Created by Marcin Raburski on 08.03.2012.
//  Copyright (c) 2012 pawel.jankowski@me.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseManager.h"

@interface LectureView : UIViewController {
    IBOutlet UIView *viewBase;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *dateLabel;
    IBOutlet UILabel *placeLabel;
    IBOutlet UILabel *placeCityLabel;
    IBOutlet UILabel *organisationLabel;
    IBOutlet UILabel *numberOfPlacesLabel;
    IBOutlet UILabel *eventFormLabel;
    IBOutlet UIButton *mapButton;
    IBOutlet UIButton *signinButton;
    Event *event;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil lecture:(Event*)_event;
- (IBAction)showOnMap:(id)sender;
- (IBAction)showLecturers:(id)sender;
- (IBAction)signIn:(id)sender;
- (IBAction)showCalendar:(id)sender;

@end
