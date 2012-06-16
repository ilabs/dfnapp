//
//  PickDateView.h
//  DFN
//
//  Created by Marcin Raburski on 25.04.2012.
//  Copyright (c) 2012 pawelqus@gmail.com. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "SimpleSearchView.h"

@interface PickDateView : UIViewController {
    IBOutlet UIDatePicker *dateFrom, *dateTo;
    IBOutlet UIView *conditionView, *lowerPart;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UISwitch *from, *to;
}
@property (assign) SimpleSearchView* parent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(SimpleSearchView*)__parent;
- (IBAction)toggleFromPicker:(id)sender;
- (IBAction)toggleToPicker:(id)sender;

@end
