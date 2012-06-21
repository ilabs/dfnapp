//
//  MainCategoryListView.m
//  DFN
//
//  Created by Radoslaw Wilczak on 17.03.2012.
//  Copyright (c) 2012 Pawel.Nuzka@gmail.com. All rights reserved.
//

#import "MainCategoryListView.h"
#import "AboutUsView.h"
#import "DatabaseManager.h"
@implementation MainCategoryListView

//@synthesize navigationController;

- (void)loadData
{
//    list = [[NSMutableArray alloc] init];
    list = [[NSMutableArray alloc] initWithArray:[[DatabaseManager sharedInstance] getAllSections]];
//    [list addObject:@"Imprezy wiodące XIV DFN"];   
//    [list addObject:@"Nauki humanistyczne"];
//    [list addObject:@"Obszary sztuki"];
//    [list addObject:@"Człowiek i społeczeństwo"];
//    [list addObject:@"Medycyna i zdrowie"];
//    [list addObject:@"Ścieżkami biologii"];
//    [list addObject:@"Niezwykły świat chemii"];
//    [list addObject:@"Nauki o Ziemii"];
//    [list addObject:@"Matematyka, fizyka, astronomia - trzy siostry"];
//    [list addObject:@"Technika i technologia"];
    
    iconList = [[NSMutableArray alloc] init];
    for (Section * section in list)
    {
        [iconList addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", section.dbID]]];
    }
//    [iconList addObject:[UIImage imageNamed:@"2.png"]];
//    [iconList addObject:[UIImage imageNamed:@"1.png"]];
//    [iconList addObject:[UIImage imageNamed:@"10.png"]];
//    [iconList addObject:[UIImage imageNamed:@"3.png"]];
//    [iconList addObject:[UIImage imageNamed:@"11.png"]];
//    [iconList addObject:[UIImage imageNamed:@"4.png"]];
//    [iconList addObject:[UIImage imageNamed:@"5.png"]];
//    [iconList addObject:[UIImage imageNamed:@"6.png"]];
//    [iconList addObject:[UIImage imageNamed:@"12.png"]];
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
    infoImage = [[UIImage imageNamed:@"info.png"] retain];
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
    return 2;  
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(section==0){
        return [list count];
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    if(indexPath.section==0){
        [[cell textLabel] setText:[(Section *)[list objectAtIndex:[indexPath row]] name]];
        [cell.imageView setImage:[iconList objectAtIndex:[indexPath row]]];
    }else{
        [[cell textLabel] setText:@"O nas..."];
        [cell.imageView setImage:infoImage];
    }
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
    if(indexPath.section==0){ // standardowa kategoria
        //tu musisz zrobic kod do obslugi wybrania komórki 
        // Navigation logic may go here. Create and push another view controller.
        
        SubCategoryListView *subCategoryListView = [[SubCategoryListView alloc] initWithNibName:@"SubCategoryListView" bundle:nil];
         // ...
         // Pass the selected object to the new view controller.
        [subCategoryListView setSection:[list objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:subCategoryListView animated:YES];
       // subCategoryListView.navigationController = self.navigationController;
        subCategoryListView.view.backgroundColor = [UIColor clearColor];
        [subCategoryListView release];
    }else{ // About us
        AboutUsView *aboutUs = [[AboutUsView alloc] initWithNibName:@"AboutUsView" bundle:nil];
        [self.navigationController pushViewController:aboutUs animated:YES];
        aboutUs.view.backgroundColor = [UIColor clearColor];
        [aboutUs release];
        
    }
     
}

- (void)dealloc {
    [infoImage release];
    [list release];
    [iconList release];
    [super dealloc];
}

@end
