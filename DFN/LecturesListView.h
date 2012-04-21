//
//  LecturesListView.h
//  DFN
//
//  Created by Radoslaw Wilczak on 17.03.2012.
//  Copyright (c) 2012 Pawel.Nuzka@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseManager.h"

@interface LecturesListView : UITableViewController {
    Category *category;
    //UINavigationController *navigationController;
    NSArray *list;
}

//@property (nonatomic, retain)UINavigationController *navigationController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil category:(Category*)_category;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil events:(NSArray *)_events;

@end
