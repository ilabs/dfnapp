//
//  SimpleSearchView.h
//  DFN
//
//  Created by Marcin Raburski on 22.04.2012.
//  Copyright (c) 2012 pawelqus@gmail.com. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface SimpleSearchView : UIViewController {
    IBOutlet UISearchBar *sBar;
    IBOutlet UITableView *tableView;
    NSArray *listEvents;
    NSTimer *timer;
}

@property (nonatomic,retain) NSDate *fromDate;
@property (nonatomic,retain) NSDate *toDate;

- (void)searchStart:(NSTimer*)theTimer;
- (void)setSearch:(NSNotification *) notification;
- (void)refreshSearch;

@end
