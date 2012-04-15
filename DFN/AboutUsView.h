//
//  AboutUsView.h
//  DFN
//
//  Created by Radoslaw Wilczak on 09.04.2012.
//  Copyright (c) 2012 pawel.jankowski@me.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutUsView : UIViewController
{
    IBOutlet UIView *subView;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIButton *button1, *button2, *button3, *button4, *button5; 
    
}
- (void)setAuthor:(NSString*)description onButton:(UIButton*)button;

@end
