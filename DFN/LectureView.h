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
    IBOutlet UILabel *title;
    IBOutlet UILabel *lecturers;
    IBOutlet UILabel *lecturersInfo;
    IBOutlet UILabel *date;
    IBOutlet UILabel *place;
    IBOutlet UILabel *placeCity;
    IBOutlet UILabel *organisation;
    IBOutlet UILabel *numberOfPlaces;
    IBOutlet UIView *lowerContent;
    IBOutlet UIButton *mapButton;
    IBOutlet UIButton *signinButton;
    Event *event;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil lecture:(Event*)_event;
- (IBAction)showOnMap:(id)sender;
- (IBAction)signIn:(id)sender;

@end
