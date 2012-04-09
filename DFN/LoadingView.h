//
//  LoadingView.h
//  DFN
//
//  Created by Marcin Raburski on 30.03.2012.
//  Copyright (c) 2012 Pawel Nuzka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIViewController {
    IBOutlet UIImageView *defaultImage;
    IBOutlet UIActivityIndicatorView *indicator;
    IBOutlet UILabel *randomText;
    IBOutlet UILabel *authorLabel;
    IBOutlet UIView *backView;
    IBOutlet UIProgressView *progressBar;
    NSArray *texts;
    NSArray *authors;
}

- (void)setLoadingProgress:(float)prog;
//- (void)setLoadingProgress:(NSNumber*)prog;

@end
