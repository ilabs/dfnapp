//
//  LoadingView.m
//  DFN
//
//  Created by Marcin Raburski on 30.03.2012.
//  Copyright (c) 2012 Pawel.Nuzka@gmail.com. All rights reserved.
//

#import "LoadingView.h"

@implementation LoadingView

@synthesize animatedStart;

- (void)setLoadingProgress:(float)prog {
    dispatch_sync(dispatch_get_main_queue(), ^{
        if([progressBar respondsToSelector:@selector(setProgress:animated:)])
        {
            [progressBar setProgress:prog animated:YES];
        }else{
            [progressBar setProgress:prog];
        }
        if(progressBar.hidden){
            [progressBar setHidden:NO];
            [UIView beginAnimations:@"ProgBar" context:NULL];
            [UIView setAnimationDelegate:[UIApplication sharedApplication].delegate];
            [UIView setAnimationDidStopSelector:@selector(loadData)];
            [UIView setAnimationDuration:0.6];
            progressBar.alpha = 1.0;
            [UIView commitAnimations];
        }
        
    }
    );

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        animatedStart = NO;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect rect = [[UIScreen mainScreen] bounds];
    self.view.frame = CGRectMake(0, 20, 320, rect.size.height - 20);
    texts = [[NSArray arrayWithObjects:@"Nauka jest zbiorem wypróbowanych przepisów.", 
              @"A ona się jednak porusza!", 
              @"Dajcie mi punkt oparcia, a poruszę ziemię.", 
              nil] retain];
    authors = [[NSArray arrayWithObjects:@"Paul Ambroise Valery", 
                @"Galileusz",
                @"Archimedes z Syrakuz", nil] retain];
    // Do any additional setup after loading the view from its nib.
    int randomIndex = arc4random() % [texts count];
    randomText.text = [texts objectAtIndex:randomIndex];
    authorLabel.text = [authors objectAtIndex:randomIndex];
    self.view.backgroundColor = [UIColor clearColor];
    if(!animatedStart){
        defaultImage.alpha = 0.0;
        backView.alpha = 0.0;
    }
}


- (void)viewDidAppear:(BOOL)animated {
    [indicator startAnimating];
    [UIView beginAnimations:@"Intro" context:NULL];
    [UIView setAnimationDelegate:[UIApplication sharedApplication].delegate];
    [UIView setAnimationDidStopSelector:@selector(loadData)];
    [UIView setAnimationDuration:0.6];
    defaultImage.alpha = 0.0;
    backView.alpha = 0.7;
    [UIView commitAnimations];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [authors release];
    [texts release];
    [super dealloc];
}

@end
