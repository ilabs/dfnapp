//
//  LectureCalendarView.h
//  DFN
//
//  Created by Marcin Raburski on 30.03.2012.
//  Copyright (c) 2012 pawel.jankowski@me.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseManager.h"

@interface LectureCalendarView : UIViewController {
    IBOutlet UITableView *tableView;
    Event *event;
    NSMutableArray *list;
    int selected;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil lecture:(Event*)_event;


@end
