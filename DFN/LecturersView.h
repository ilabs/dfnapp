//
//  LecturersView.h
//  DFN
//
//  Created by Marcin Raburski on 24.03.2012.
//  Copyright (c) 2012 Pawel Nuzka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseManager.h"

@interface LecturersView : UIViewController {
    Event *event;
    NSArray *list;
    IBOutlet UITableView *tableView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil lecture:(Event*)_event;

@end
