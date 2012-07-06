//
//  SimpleSearchView.m
//  DFN
//
//  Created by Marcin Raburski on 22.04.2012.
//  Copyright (c) 2012 pawelqus@gmail.com. All rights reserved.
//

#import "SimpleSearchView.h"
#import "DatabaseManager.h"
#import "LectureView.h"
#import "PickDateView.h"

@interface SimpleSearchView ()

@end

@implementation SimpleSearchView

@synthesize fromDate = _fromDate;
@synthesize toDate = _toDate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.fromDate = [NSDate distantPast];
        self.toDate = [NSDate distantFuture];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Szukaj";
    tableView.backgroundColor = [UIColor clearColor];
    listEvents = [[NSArray alloc] init];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Ramy czasowe" style:UIBarButtonItemStylePlain target:self action:@selector(pickDate)] autorelease];
    timer = nil;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setSearch:) name:@"Search" object:nil];

}

- (void)pickDate {
    PickDateView *pdv = [[[PickDateView alloc] initWithNibName:@"PickDateView" bundle:nil parent:self] autorelease];
    [(UINavigationController*)self.parentViewController pushViewController:pdv animated:YES];
}

- (void)setSearch:(NSNotification *) notification {
    
    [UIView beginAnimations:@"searchFade" context:NULL];
    [UIView setAnimationDuration:0.5];
    tableView.alpha = 0.5;
    [UIView commitAnimations];
    [sBar setText:[[notification userInfo] objectForKey:@"string"]];
    [(UITabBarController*)self.parentViewController.parentViewController setSelectedIndex:2];
    [(UINavigationController*)self.parentViewController popToRootViewControllerAnimated:YES];
    DLog(@"PRE timer krash!");
    timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(searchStart:) userInfo:[[notification userInfo] objectForKey:@"string"] repeats:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)searchStart:(NSTimer*)theTimer {
    
    timer = nil;
    NSString *searchText = [theTimer userInfo];
    if ([searchText length]>1) {

        NSArray *words = [searchText componentsSeparatedByString:@" "];
        NSMutableString *predicate = [[[NSMutableString alloc] initWithString:@"("] autorelease];
        NSMutableArray *args = [[[NSMutableArray alloc] init] autorelease];
        for(NSString *word in words) {
            if([words indexOfObject:word]>0)
                [predicate appendString:@" and "];
            [predicate appendString:@"((title like[cd] %@) or (descriptionContent like[cd] %@) or ((place.address like[cd] %@) or (place.city like[cd] %@)) or (lecturer.name like[cd] %@) or (organisation.name like[cd] %@) or (any forms.eventFormType.name like[cd] %@))"];
            [args addObjectsFromArray:[NSArray arrayWithObjects:[NSString stringWithFormat:@"*%@*", word],[NSString stringWithFormat:@"*%@*", word],[NSString stringWithFormat:@"*%@*", word],[NSString stringWithFormat:@"*%@*", word],[NSString stringWithFormat:@"*%@*", word],[NSString stringWithFormat:@"*%@*", word],[NSString stringWithFormat:@"*%@*", word], nil]];
        }
        [predicate appendString:@") and ((any dates.day >= %@) and (any dates.day <= %@))"];
        [args addObjectsFromArray:[NSArray arrayWithObjects:self.fromDate,self.toDate, nil]];
        NSArray *events = [[DatabaseManager sharedInstance] fetchedManagedObjectsForEntity:@"Event" withPredicate:[NSPredicate predicateWithFormat:predicate argumentArray:args]];

        [listEvents autorelease];
        listEvents = [events retain];
        [tableView reloadData];
        tableView.alpha = 1.0;
    }

}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if(timer==nil){
        [UIView beginAnimations:@"searchFade" context:NULL];
        [UIView setAnimationDuration:0.7];
        tableView.alpha = 0.5;
        [UIView commitAnimations];
        timer = [NSTimer scheduledTimerWithTimeInterval:0.7 target:self selector:@selector(searchStart:) userInfo:searchText repeats:NO];
    }else{
        [timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:0.7]];
        [(NSMutableString*)timer.userInfo setString:searchText];
    }
    
}

- (void)refreshSearch {
    
    [self searchBar:sBar textDidChange:sBar.text];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    // only show the status bar’s cancel button while in edit mode
    [sBar setShowsCancelButton:YES animated:YES];
    //sBar.showsSearchResultsButton = YES;
    sBar.autocorrectionType = UITextAutocorrectionTypeNo;

}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [sBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    // if a valid search was entered but the user wanted to cancel, bring back the main list content
    [sBar resignFirstResponder];
    //sBar.text = @”";
}
// called when Search (in our case “Done”) button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

/*
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self tableView:tableView titleForHeaderInSection:section] != nil) {
        return 40;
    }
    else {
        // If no section header title, no section header needed
        return 0;
    }
}*/

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    
    // Create label with section title
    UILabel *label = [[[UILabel alloc] init] autorelease];
    label.frame = CGRectMake(20, 0, 280, 30);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.text = sectionTitle;
    label.textAlignment = UITextAlignmentCenter;
    
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [view autorelease];
    [view addSubview:label];
    
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if([listEvents count]==0){
            return @"Brak wyników";
    } else {
        return nil;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return [listEvents count];
            break;
            
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.textLabel.backgroundColor = [UIColor clearColor];
    // Configure the cell...
    if(indexPath.section==0)
        [[cell textLabel] setText:[[listEvents objectAtIndex:[indexPath row]] title]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
    LectureView *detailViewController = [[LectureView alloc] initWithNibName:@"LectureView" bundle:nil lecture:[listEvents objectAtIndex:indexPath.row]];
    // ...
    // Pass the selected object to the new view controller.
    [sBar resignFirstResponder];
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [timer release];
    [listEvents release];
    [super dealloc];
}

@end
