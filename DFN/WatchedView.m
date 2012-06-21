//
//  WatchedView.m
//  DFN
//
//  Created by Marcin Raburski on 07.04.2012.
//  Copyright (c) 2012 Pawel.Nuzka@gmail.com. All rights reserved.
//

#import "WatchedView.h"
#import "DatabaseManager.h"
#import "LectureView.h"
#import "DFNAppDelegate.h"

@implementation WatchedView

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
    // Do any additional setup after loading the view from its nib.
    tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor clearColor];
    nothingWatchedView.backgroundColor = [UIColor clearColor];
    self.title = @"Obserwowane";
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.editButtonItem.title = @"Edytuj";
    changed = nil;
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshData)] autorelease];
    
}

- (void)refreshData {
    // Aktualizacja danych
    // Loading view commituje krotka animacja i wywoluje (void)loadData
    [((DFNAppDelegate*)[UIApplication sharedApplication].delegate) showLoadingView:NO];
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
    static NSString *CellIdentifier = @"CellWatched";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    [[cell textLabel] setText:((Event*)[list objectAtIndex:[indexPath row]]).title];
    if([((Event*)[list objectAtIndex:[indexPath row]]).showAsUpdated boolValue]){
        // znika po nacisniciu cell'a
        if(changed == nil){
            changed = [[UIImage imageNamed:@"changed.png"] retain];
        }
        cell.imageView.image = changed;
    }
    return cell;
}
 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    Event *event = (Event*)[list objectAtIndex:indexPath.row];
    LectureView *detailViewController = [[LectureView alloc] initWithNibName:@"LectureView" bundle:nil lecture:event];
    // ...
    // Pass the selected object to the new view controller.
    if([event.showAsUpdated boolValue]){
        [event setShowAsUpdated:[NSNumber numberWithBool:NO]];
    }    
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [tableView setEditing:editing animated:YES];
}

- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // If row is deleted, remove it from the list.
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[DatabaseManager sharedInstance] removeFromWatchedEntities:[list objectAtIndex:indexPath.row]];
        list = [[[DatabaseManager sharedInstance] getAllWatched] retain];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if([list count]==0){
            nothingWatchedView.alpha = 0.0;
            [self.view addSubview:nothingWatchedView];
            [UIView beginAnimations:@"nothingWatchedFade" context:NULL];
            [UIView setAnimationDuration:0.7];
            nothingWatchedView.alpha = 1.0;
            [UIView commitAnimations];
            [self setEditing:NO animated:YES];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    list = [[[DatabaseManager sharedInstance] getAllWatched] retain];
    [tableView reloadData];
    self.editing = NO;
    if([list count]==0){
        [self.view addSubview:nothingWatchedView];
    }else {
        [nothingWatchedView removeFromSuperview];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [list release];
}
- (void)dealloc{
    //[list release];
    [changed release];
    [super dealloc];
}

@end
