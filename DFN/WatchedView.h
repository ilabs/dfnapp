//
//  WatchedView.h
//  DFN
//
//  Created by Marcin Raburski on 07.04.2012.
//  Copyright (c) 2012 pawel.jankowski@me.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WatchedView : UIViewController {
    IBOutlet UITableView *tableView;
    NSArray *list;
    UIImage *changed;
}

@end
