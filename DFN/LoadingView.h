//
//  LoadingView.h
//  DFN
//
//  Created by Marcin Raburski on 30.03.2012.
//  Copyright (c) 2012 pawel.jankowski@me.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIViewController {
    IBOutlet UIImageView *defaultImage;
    IBOutlet UIActivityIndicatorView *indicator;
    IBOutlet UILabel *randomText;
    IBOutlet UILabel *authorLabel;
    IBOutlet UIView *backView;
    NSArray *texts;
    NSArray *authors;
}

@end