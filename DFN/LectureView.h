//
//  LectureView.h
//  DFN
//
//  Created by Marcin Raburski on 08.03.2012.
//  Copyright (c) 2012 Pawel.Nuzka@gmail.com. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "DatabaseManager.h"

@interface LectureView : UIViewController {
    IBOutlet UIView *viewBase;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *placeLabel;
    IBOutlet UILabel *placeCityLabel;
    IBOutlet UILabel *organisationLabel;
    IBOutlet UILabel *numberOfPlacesLabel;
    IBOutlet UILabel *eventFormLabel;
    IBOutlet UIButton *mapButton;
    IBOutlet UIButton *signinButton;
    IBOutlet UIButton *watchButton;
    IBOutlet UIButton *descriptionButton;
    IBOutlet UILabel *dodanoLabel;
    IBOutlet UITableView *tableView;
    IBOutlet UITableView *datesTableView;
    IBOutlet UIButton *tableViewBackground;
    IBOutlet UIButton *datesTableViewBackground;
    IBOutlet UILabel *signinLabel;
    IBOutlet UIImageView *signinImage;
    NSDateFormatter *dateFormatter;
    NSDateFormatter *dateFormatterHour;
    NSArray *lecturersList;
    NSArray *dates;
    Event *event;
    int selected;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil lecture:(Event*)_event;
- (IBAction)showOnMap:(id)sender;
- (IBAction)showDescription:(id)sender;
- (IBAction)signIn:(id)sender;
- (IBAction)addToWatched:(id)sender;

@end