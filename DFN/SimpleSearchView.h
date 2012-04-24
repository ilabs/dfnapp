//
//  SimpleSearchView.h
//  DFN
//
//  Created by Marcin Raburski on 22.04.2012.
//  Copyright (c) 2012 pawel.jankowski@me.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleSearchView : UIViewController {
    IBOutlet UISearchBar *sBar;
    IBOutlet UITableView *tableView;
    NSArray *listEvents;
    NSTimer *timer;
}

- (void)searchStart:(NSTimer*)theTimer;
- (void)setSearch:(NSNotification *) notification;

@end
