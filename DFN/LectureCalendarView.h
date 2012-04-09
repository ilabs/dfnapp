//
//  LectureCalendarView.h
//  DFN
//
//  Created by Marcin Raburski on 30.03.2012.
//  Copyright (c) 2012 Pawel.Nuzka@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseManager.h"

@interface LectureCalendarView : UIViewController {
    IBOutlet UITableView *tableView;
    Event *event;
    NSMutableArray *list;
    int selected;
    NSDateFormatter *dateFormatter;
    NSDateFormatter *dateFormatterHour;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil lecture:(Event*)_event;


@end
