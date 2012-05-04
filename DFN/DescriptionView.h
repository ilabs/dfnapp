//
//  DescriptionView.h
//  DFN
//
//  Created by Marcin Raburski on 04.05.2012.
//  Copyright (c) 2012 pawel.jankowski@me.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseManager.h"

@interface DescriptionView : UIViewController {
    IBOutlet UITextView *textView;
    Event *event;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil lecture:(Event*)_event;

@end
