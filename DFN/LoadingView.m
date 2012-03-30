//
//  LoadingView.m
//  DFN
//
//  Created by Marcin Raburski on 30.03.2012.
//  Copyright (c) 2012 pawel.jankowski@me.com. All rights reserved.
//

#import "LoadingView.h"

@implementation LoadingView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    self.view.frame = CGRectMake(0, 20, 320, 460);
    texts = [[NSArray arrayWithObjects:@"Nauka jest zbiorem wypróbowanych przepisów.", 
              @"A ona się jednak porusza!", 
              @"Dajcie mi punkt oparcia, a poruszę ziemię.", 
              nil] retain];
    authors = [[NSArray arrayWithObjects:@"Paul Ambroise Valery", 
                @"Galileusz",
                @"Archimedes z Syrakuz", nil] retain];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated {
    int randomIndex = arc4random() % [texts count];
    randomText.text = [texts objectAtIndex:randomIndex];
    authorLabel.text = [authors objectAtIndex:randomIndex];
    [indicator startAnimating];
    self.view.backgroundColor = [UIColor clearColor];
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
