//
//  SignInView.h
//  DFN
//
//  Created by Marcin Raburski on 20.04.2012.
//  Copyright (c) 2012 pawel.jankowski@me.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseManager.h"

@interface SignInView : UIViewController {
    IBOutlet UITableView *tableView;
    Event *event;
    NSArray *list;
    NSDateFormatter *dateFormatter;
    NSDateFormatter *dateFormatterHour;
}

@property (assign) id parent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil lecture:(Event*)_event;

@end
