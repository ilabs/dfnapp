//
//  PickDateView.m
//  DFN
//
//  Created by Marcin Raburski on 25.04.2012.
//  Copyright (c) 2012 pawelqus@gmail.com. All rights reserved.
//

#import "PickDateView.h"

@interface PickDateView ()

@end

@implementation PickDateView

@synthesize parent;

-(IBAction)toggleFromPicker:(id)sender {
    [UIView beginAnimations:@"pickerFromToggle" context:NULL];
    [UIView setAnimationDuration:0.6];
    if([(UISwitch*)sender isOn]){
        lowerPart.frame = CGRectMake(lowerPart.frame.origin.x, lowerPart.frame.origin.y+220, lowerPart.frame.size.width, lowerPart.frame.size.height);
        dateFrom.alpha = 1.0;
    }else{
        lowerPart.frame = CGRectMake(lowerPart.frame.origin.x, lowerPart.frame.origin.y-220, lowerPart.frame.size.width, lowerPart.frame.size.height);
        dateFrom.alpha = 0.0;
    }
    [UIView commitAnimations];

}
-(IBAction)toggleToPicker:(id)sender {
    [UIView beginAnimations:@"pickerToToggle" context:NULL];
    [UIView setAnimationDuration:0.6];
    if([(UISwitch*)sender isOn]){
        dateTo.alpha = 1.0;
    }else{
        dateTo.alpha = 0.0;
    }
    [UIView commitAnimations];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil parent:(SimpleSearchView*)__parent {
    self.parent = __parent;
    return [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Wybierz terminy";

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor clearColor];
    conditionView.backgroundColor = [UIColor clearColor];
    lowerPart.backgroundColor = [UIColor clearColor];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.contentSize = CGSizeMake(conditionView.frame.size.width, conditionView.frame.size.height + conditionView.frame.origin.y);
    scrollView.frame = CGRectMake(0, 94, scrollView.frame.size.width, scrollView.frame.size.height-40);
    if(parent.fromDate != [NSDate distantPast]){
        lowerPart.frame = CGRectMake(lowerPart.frame.origin.x, lowerPart.frame.origin.y+220, lowerPart.frame.size.width, lowerPart.frame.size.height);
        dateFrom.alpha = 1.0;
        [from setOn:YES];
        [dateFrom setDate:parent.fromDate];
    }
    if(parent.toDate != [NSDate distantFuture]){
        dateTo.alpha = 1.0;
        [to setOn:YES];
        [dateTo setDate:parent.toDate];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    if([from isOn]){
        parent.fromDate = [dateFrom date];
    }else {
        parent.fromDate = [NSDate distantPast];
    }
    if([to isOn]){
        parent.toDate = [dateTo date];
    }else {
        parent.toDate = [NSDate distantFuture];
    }
    [parent refreshSearch];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
