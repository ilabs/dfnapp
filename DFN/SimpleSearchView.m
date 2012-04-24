//
//  SimpleSearchView.m
//  DFN
//
//  Created by Marcin Raburski on 22.04.2012.
//  Copyright (c) 2012 pawel.jankowski@me.com. All rights reserved.
//

#import "SimpleSearchView.h"
#import "DatabaseManager.h"
#import "LectureView.h"
#import "PickDateView.h"

@interface SimpleSearchView ()

@end

@implementation SimpleSearchView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"według daty" style:UIBarButtonItemStylePlain target:self action:@selector(pickDate)];
    timer = nil;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setSearch:) name:@"Search" object:nil];
}

- (void)pickDate {
    PickDateView *pdv = [[[PickDateView alloc] initWithNibName:@"PickDateView" bundle:nil] autorelease];
    //[self presentModalViewController:pdv animated:YES];
    [(UINavigationController*)self.parentViewController pushViewController:pdv animated:YES];
    //[(UINavigationController*)self.parentViewController pre];
    pdv.view.backgroundColor = [UIColor clearColor];
}

- (void)setSearch:(NSNotification *) notification {
    [UIView beginAnimations:@"searchFade" context:NULL];
    [UIView setAnimationDuration:0.5];
    tableView.alpha = 0.5;
    [UIView commitAnimations];
    [sBar setText:[[notification userInfo] objectForKey:@"string"]];
    [(UITabBarController*)self.parentViewController.parentViewController setSelectedIndex:2];
    [(UINavigationController*)self.parentViewController popToRootViewControllerAnimated:YES];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(searchStart:) userInfo:[[notification userInfo] objectForKey:@"string"] repeats:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)searchStart:(NSTimer*)theTimer {
    NSDate *startDate = [NSDate distantPast], *endDate = [NSDate distantFuture];
    timer = nil;
    NSString *searchText = [theTimer userInfo];
    if ([searchText length]>1) {
        /*if([conditionDateSwitch isOn]) {
         NSCalendar *calendar = [NSCalendar currentCalendar];
         NSDateComponents *dC;
         dC = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:conditionDate.date];
         dC.hour = 0;
         dC.minute = 0;
         dC.second = 0;
         startDate = [calendar dateFromComponents:dC];
         dC.hour = 23;
         dC.minute = 59;
         dC.second = 59;
         endDate = [calendar dateFromComponents:dC];
         }*/


        NSArray *words = [searchText componentsSeparatedByString:@" "];
        NSMutableString *predicate = [[[NSMutableString alloc] initWithString:@"("] autorelease];
        NSMutableArray *args = [[[NSMutableArray alloc] init] autorelease];
        for(NSString *word in words) {
            if([words indexOfObject:word]>0)
                [predicate appendString:@" and "];
            [predicate appendString:@"((title like[cd] %@) or (descriptionContent like[cd] %@) or ((place.address like[cd] %@) or (place.city like[cd] %@)) or (lecturer.name like[cd] %@) or (organisation.name like[cd] %@) or (any forms.eventFormType.name like[cd] %@))"];
            /*[predicate appendFormat:@"(title like[cd] %@) or (descriptionContent like[cd] %@) or ((place.address like[cd] %@) or (place.city like[cd] %@)) or (lecturer.name like[cd] %@) or (organisation.name like[cd] %@) or (any forms.eventFormType.name like[cd] %@)",
             [NSString stringWithFormat:@"*%@*", word], 
             [NSString stringWithFormat:@"*%@*", word],
             [NSString stringWithFormat:@"*%@*", word],
             [NSString stringWithFormat:@"*%@*", word],
             [NSString stringWithFormat:@"*%@*", word],
             [NSString stringWithFormat:@"*%@*", word],
             [NSString stringWithFormat:@"*%@*", word]];
             */
            [args addObjectsFromArray:[NSArray arrayWithObjects:[NSString stringWithFormat:@"*%@*", word],[NSString stringWithFormat:@"*%@*", word],[NSString stringWithFormat:@"*%@*", word],[NSString stringWithFormat:@"*%@*", word],[NSString stringWithFormat:@"*%@*", word],[NSString stringWithFormat:@"*%@*", word],[NSString stringWithFormat:@"*%@*", word], nil]];
        }
        [predicate appendString:@") and !((none dates.day >= %@) or (none dates.day <= %@))"];
        [args addObjectsFromArray:[NSArray arrayWithObjects:startDate,endDate, nil]];
        //[NSPredicate pre];
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
        timer = [NSTimer scheduledTimerWithTimeInterval:0.7 target:self selector:@selector(searchStart:) userInfo:[NSMutableString stringWithString:searchText] repeats:NO];
    }else{
        [timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:0.7]];
        [(NSMutableString*)timer.userInfo setString:searchText];
    }
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self tableView:tableView titleForHeaderInSection:section] != nil) {
        return 40;
    }
    else {
        // If no section header title, no section header needed
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    
    // Create label with section title
    UILabel *label = [[[UILabel alloc] init] autorelease];
    label.frame = CGRectMake(20, 6, 300, 30);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    //label.shadowColor = [UIColor whiteColor];
    //label.shadowOffset = CGSizeMake(0.0, 1.0);
    label.font = [UIFont boldSystemFontOfSize:16];
    label.text = sectionTitle;
    
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [view autorelease];
    [view addSubview:label];
    
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if([listEvents count]==0)
        return 0;
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Wykłady";
            break;
        case 1:
            return @"Kategorie";
            break;    
        case 2:
            return @"Wykładowcy";
            break; 
        default:
            break;
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
