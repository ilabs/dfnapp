//
//  MainCategoryListView.m
//  DFN
//
//  Created by Radoslaw Wilczak on 17.03.2012.
//  Copyright (c) 2012 pawel.jankowski@me.com. All rights reserved.
//

#import "MainCategoryListView.h"

@implementation MainCategoryListView

@synthesize navigationController;

- (void)loadData
{
    list = [[NSMutableArray alloc] init];
    [list addObject:@"Imprezy wiodące XIV DFN"];   
    [list addObject:@"Nauki humanistyczne"];
    [list addObject:@"Obszary sztuki"];
    [list addObject:@"Człowiek i społeczeństwo"];
    [list addObject:@"Medycyna i zdrowie"];
    [list addObject:@"Ścieżkami biologii"];
    [list addObject:@"Niezwykły świat chemii"];
    [list addObject:@"Nauki o Ziemii"];
    [list addObject:@"Matematyka, fizyka, astronomia - trzy siostry"];
    [list addObject:@"Technika i technologia"];
    
    iconList = [[NSMutableArray alloc] init];
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"8" ofType:@"png"];
    [iconList addObject:[[UIImage alloc] initWithContentsOfFile:path1]];
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"2" ofType:@"png"];
    [iconList addObject:[[UIImage alloc] initWithContentsOfFile:path2]];
    NSString *path3 = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"png"];
    [iconList addObject:[[UIImage alloc] initWithContentsOfFile:path3]];
    NSString *path4 = [[NSBundle mainBundle] pathForResource:@"10" ofType:@"png"];
    [iconList addObject:[[UIImage alloc] initWithContentsOfFile:path4]];
    NSString *path5 = [[NSBundle mainBundle] pathForResource:@"3" ofType:@"png"];
    [iconList addObject:[[UIImage alloc] initWithContentsOfFile:path5]];
    NSString *path6 = [[NSBundle mainBundle] pathForResource:@"11" ofType:@"png"];
    [iconList addObject:[[UIImage alloc] initWithContentsOfFile:path6]];
    NSString *path7 = [[NSBundle mainBundle] pathForResource:@"4" ofType:@"png"];
    [iconList addObject:[[UIImage alloc] initWithContentsOfFile:path7]];
    NSString *path8 = [[NSBundle mainBundle] pathForResource:@"5" ofType:@"png"];
    [iconList addObject:[[UIImage alloc] initWithContentsOfFile:path8]];
    NSString *path9 = [[NSBundle mainBundle] pathForResource:@"6" ofType:@"png"];
    [iconList addObject:[[UIImage alloc] initWithContentsOfFile:path9]];
    NSString *path10 = [[NSBundle mainBundle] pathForResource:@"12" ofType:@"png"];
    [iconList addObject:[[UIImage alloc] initWithContentsOfFile:path10]];
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    [self loadData];
    self.title = @"Działy";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

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
    [cell.imageView setImage:[iconList objectAtIndex:[indexPath row]]];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //tu musisz zrobic kod do obslugi wybrania komórki 
    // Navigation logic may go here. Create and push another view controller.
    
    SubCategoryListView *subCategoryListView = [[SubCategoryListView alloc] initWithNibName:@"SubCategoryListView" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:subCategoryListView animated:YES];
    subCategoryListView.view.backgroundColor = [UIColor clearColor];
    [subCategoryListView release];
     
}

- (void)dealloc {
    [list release];
    [super dealloc];
}

@end
