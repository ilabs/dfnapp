//
//  LecturersView.m
//  DFN
//
//  Created by Marcin Raburski on 24.03.2012.
//  Copyright (c) 2012 pawel.jankowski@me.com. All rights reserved.
//

#import "LecturersView.h"
#import <QuartzCore/QuartzCore.h>

@implementation LecturersView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil lecture:(Event*)_event {
    if(self=[self initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        event = [_event retain];
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Prowadzący";
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
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor clearColor];
    
    UIView *round = [self.view viewWithTag:2];
    while(round!=nil){
        round.layer.borderWidth = 1;
        round.layer.cornerRadius = 12;
        round.layer.borderColor = [[UIColor grayColor] CGColor];
        round.backgroundColor = [UIColor whiteColor];
        round.tag = 0;
        round.alpha = 0.95;
        round.layer.shadowOffset = CGSizeMake(0,0);
        round.layer.shadowRadius = 8;
        round.layer.shadowOpacity = 0.2;
        round = [self.view viewWithTag:2];
    }
    list = [event.lecturer componentsSeparatedByString:@", "];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.frame = CGRectMake(0, 40, 320, 460);
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    [[cell textLabel] setText:[list objectAtIndex:[indexPath row]]];
    
    return cell;
}


- (void)dealloc {
    [event release];
    [super dealloc];
}

@end
