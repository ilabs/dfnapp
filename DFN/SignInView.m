//
//  SignInView.m
//  DFN
//
//  Created by Marcin Raburski on 20.04.2012.
//  Copyright (c) 2012 pawelqus@gmail.com. All rights reserved.
//

#import "SignInView.h"
#import "LectureRecordView.h"
#import "LectureView.h"
#import "SubscriptionMaker.h"

@interface SignInView ()

@end

@implementation SignInView

int lastChosenIndex;

@synthesize parent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil lecture:(Event*)_event {
    if(self=[self initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        event = [_event retain];
        list = [[[DatabaseManager sharedInstance] getAllDatesForEvent:event] retain];
    }
    return self;
}

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
    self.title = @"Wybierz datę";
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatterHour = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    [dateFormatterHour setDateFormat:@"HH:mm"];
    
    self.view.backgroundColor = [UIColor clearColor];
    tableView.backgroundColor = [UIColor clearColor];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(successfullySubscribed) name:@"Subscribed" object:nil];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{ 
    
    static NSString *CellIdentifier = @"Cell";
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UITableViewCell *cell = nil;
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    EventDate *date = [list objectAtIndex:[indexPath row]];
    NSString *val = [NSString stringWithFormat:@"%@, %@ - %@" ,[dateFormatter stringFromDate:date.day], [dateFormatterHour stringFromDate:date.openingHour], [dateFormatterHour stringFromDate:date.closingHour]];
    [[cell textLabel] setText:val];
    if ([[DatabaseManager sharedInstance] isEventDateSubscribed:date])
    {
        cell.textLabel.textColor = [UIColor colorWithRed:52.0/256 green:156.0/256 blue:0.0 alpha:1.0];
    }
    return cell;
}



- (void)successfullySubscribed
{
    EventDate *evDate = (EventDate*)[list objectAtIndex:lastChosenIndex];
    [event addSubscribedDatesObject:evDate];
    [(LectureView*)self.parent addToWatched:nil];
    [tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // tutaj DO Stuff
    EventDate *evDate = (EventDate*)[list objectAtIndex:indexPath.row];
    //DLog(@"evdate: %@",[[DatabaseManager sharedInstance] hasAlreadySubscribedAtDay:evDate.day andOpeningHour:evDate.openingHour]);
    if ([[DatabaseManager sharedInstance] hasAlreadySubscribedAtDay:evDate.day andOpeningHour:evDate.openingHour])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ostrzeżenie" message:@"Jesteś już zapisany na inne wydarzenie w tym czasie!" delegate:self cancelButtonTitle:@"Rozumiem" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else {
        SubscriptionMaker *subMaker = [[SubscriptionMaker alloc] init];
        [subMaker subscribeWithSubscripiton:event.subscription withDate:evDate withTitle:event.title withLecturer:event.lecturer andNavigationView:self.navigationController];
        [subMaker release];
    }
    [tableView reloadData];
    lastChosenIndex = indexPath.row;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [dateFormatter release];
    [dateFormatterHour release];
    [list release];
    [event release];
    [super dealloc];
}

@end
