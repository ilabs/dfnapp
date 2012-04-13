//
//  AboutAuthorsView.m
//  DFN
//
//  Created by Radoslaw Wilczak on 11.04.2012.
//  Copyright (c) 2012 pawel.jankowski@me.com. All rights reserved.
//

#import "AboutAuthorsView.h"

@implementation AboutAuthorsView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setAuthor:(NSString*)description onButton:(UIButton*)button
{
    [button setTitle:description forState:UIControlStateNormal];
    [button.titleLabel setLineBreakMode:UILineBreakModeWordWrap];
    [button.titleLabel setTextAlignment:UITextAlignmentCenter];
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
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self setAuthor:@"Paweł Nużka\npawelqus@gmail.com" onButton:button1];
    [self setAuthor:@"Radek Wilczak\nradekwilczak@gmail.com" onButton:button2];
    [self setAuthor:@"Michał Jodko\nthe.kazior@gmail.com" onButton:button3];
    [self setAuthor:@"Marcin Raburski\nvxc.phoenix@gmail.com" onButton:button4];
    [self setAuthor:@"Eugeniusz Keptia\nedzio27@gmail.com" onButton:button5];
    // Do any additional setup after loading the view from its nib.
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

@end
