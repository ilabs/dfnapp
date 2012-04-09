//
//  LectureCalendarView.m
//  DFN
//
//  Created by Marcin Raburski on 30.03.2012.
//  Copyright (c) 2012 Pawel.Nuzka@gmail.com. All rights reserved.
//

#import "LectureCalendarView.h"
#import <EventKit/EventKit.h>

@implementation LectureCalendarView


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
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatterHour = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    [dateFormatterHour setDateFormat:@"HH:mm"];
    
    self.view.backgroundColor = [UIColor clearColor];
    tableView.backgroundColor = [UIColor clearColor];
    self.title = @"Kalendarz";
    //tableView.frame = CGRectMake(0, 40, 320, 460);
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"ROws ins selc : %d",[list count]);
    // Return the number of rows in the section.
    return [list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"KJHGASDKLHASD");   
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    EventDate *date = [list objectAtIndex:[indexPath row]];
    NSString *val = [NSString stringWithFormat:@"%@, %@ - %@" ,[dateFormatter stringFromDate:date.day], [dateFormatterHour stringFromDate:date.openingHour], [dateFormatterHour stringFromDate:date.closingHour]];
    //[dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    //NSLog(@"DATEFRMT: %@",[dateFormatter stringFromDate:date.openingHour]);
    [[cell textLabel] setText:val];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selected = [indexPath row];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Kalendarz" message:@"Czy na pewno chcesz dodać do kalendarza?" delegate:self cancelButtonTitle:@"Nie" otherButtonTitles:@"TAK", nil];
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex==1){
        EKEventStore *eventStore = [[[EKEventStore alloc] init] autorelease];
        EKEvent *nevent  = [EKEvent eventWithEventStore:eventStore];
        nevent.title     = event.title;
        EventDate *evdate = [list objectAtIndex:selected];
        nevent.startDate = evdate.openingHour;
        nevent.endDate   = evdate.closingHour;
        [nevent setCalendar:[eventStore defaultCalendarForNewEvents]];
        NSError *err;
        [eventStore saveEvent:nevent span:EKSpanThisEvent error:&err];       
    }
    [tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:selected inSection:0] animated:YES];

}

- (void)dealloc {
    [dateFormatter release];
    [dateFormatterHour release];
    [list release];
    [event release];
    [super dealloc];
}

@end
