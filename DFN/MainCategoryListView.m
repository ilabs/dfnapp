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
    [list addObject:@"IMPREZY WIODĄCE XIV DFN"];   
    [list addObject:@"NAUKI HUMANISTYCZNE"];
    [list addObject:@"OBSZARY SZTUKI"];
    [list addObject:@"CZŁOWIEK I SPOŁECZEŃSTWO"];
    [list addObject:@"MEDYCYNA I ZDROWIE"];
    [list addObject:@"SCIEŻKAMI BIOLOGII"];
    [list addObject:@"NIEZWYKŁY ŚWIAT CHEMII"];
    [list addObject:@"NAUKI O ZIEMI"];
    [list addObject:@"MATEMATYKA, FIZYKA, ASTRONOMIA - TRZY SIOSTRY"];
    [list addObject:@"TECHNIKA I TECHNOLOGIA"];
    
    iconList = [[NSMutableArray alloc] init];
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"1331600213_gimp2" ofType:@"png"];
    [iconList addObject:[[UIImage alloc] initWithContentsOfFile:path1]];
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
    self.title = @"kategoria";
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
    [cell.imageView setImage:[iconList objectAtIndex:0]];
    
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
