//
//  LectureView.m
//  DFN
//
//  Created by Marcin Raburski on 08.03.2012.
//  Copyright (c) 2012 rabursky@gmail.com. All rights reserved.
//

#import "LectureView.h"
#import "SignInView.h"
#import <EventKit/EventKit.h>
#import "DescriptionView.h"


@implementation LectureView


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil lecture:(Event*)_event {
    if(self=[self initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        event = [_event retain];
    }
    return self;
}

- (IBAction)addToWatched:(id)sender {
    DatabaseManager *m = [DatabaseManager sharedInstance];
    if(![m isWatched:event]){
        [m addToWatchedEntities:event];
        [watchButton setEnabled:NO];
        [dodanoLabel setHidden:NO];
        [datesTableView reloadData];
    }
}

- (IBAction)showOnMap:(id)sender {
    NSString *url;
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    if([language isEqual:@"pl"] || [language isEqual:@"pol"]){
        language = @"Bieżące położenie";
    }else{
        language = @"Current Location";
    }
    if([event.place.gpsCoordinates length]>0){
        url = [NSString stringWithFormat:@"http://maps.google.com/maps?daddr=%@&saddr=%@",event.place.gpsCoordinates, language];
    }else{
        url = [NSString stringWithFormat:@"http://maps.google.com/maps?daddr=%@&saddr=%@, %@",event.place.address, event.place.city, language];
    }
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    /*LectureMapView *lview = [[[LectureMapView alloc] initWithNibName:@"LectureMapView" bundle:nil lecture:event] autorelease];
     [self.navigationController pushViewController:lview animated:YES];*/
}
- (IBAction)showDescription:(id)sender {
    DescriptionView *lview = [[[DescriptionView alloc] initWithNibName:@"DescriptionView" bundle:nil lecture:event] autorelease];
    [self.navigationController pushViewController:lview animated:YES];
}
- (IBAction)signIn:(id)sender {
    SignInView *lview = [[[SignInView alloc] initWithNibName:@"SignInView" bundle:nil lecture:event] autorelease];
    lview.parent = self;
    [self.navigationController pushViewController:lview animated:YES];
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
    // Do any additional setup after loading the view from its nib.
    scrollView.frame = CGRectMake(0, 20, 320, 460);
    
    dates = [[[DatabaseManager sharedInstance] getAllDatesForEvent:event] retain];
    
    [titleLabel setText:event.title];
    [placeLabel setText:[event.place.address stringByReplacingOccurrencesOfString:@", " withString:@"\r\n"]];
    [placeCityLabel setText:event.place.city];
    if(![event.place.numberOfFreePlaces isEqualToString:@"0"]){
        [numberOfPlacesLabel setText:event.place.numberOfFreePlaces];
    }else{
        [numberOfPlacesLabel setText:@"∞"];
        numberOfPlacesLabel.font = [UIFont systemFontOfSize:32];
    }
    [organisationLabel setText:event.organisation.name];
    
    NSMutableString *tekst = [[[NSMutableString alloc] init] autorelease];
    for(EventForm* form in event.forms)
    {
        if([tekst length]>0)
            [tekst appendString:@", "];
        [tekst appendString: [((EventFormType*) form.eventFormType) name]];
    }
    [eventFormLabel setText:tekst];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatterHour = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    [dateFormatterHour setDateFormat:@"HH:mm"];
    
    self.title = @"Impreza";
    if([[DatabaseManager sharedInstance] isWatched:event]){
        [watchButton setEnabled:NO];
        [dodanoLabel setHidden:NO];
    }
    lecturersList = [[event.lecturer componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@",;|"]] retain];
    tableView.backgroundColor = [UIColor clearColor];
    UIView *obj;
    int secondPartTAG = 3; // po dostosowaniu do lecturers TAG view dolnych się zmieni
    int rowHeight = 30;
    if([lecturersList count]>1){ // dostosowanie polozenia innych VIEW do ilosci wykladowcow
        secondPartTAG = 1;
        tableView.frame = CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, tableView.frame.size.height+rowHeight*(lecturersList.count-1));
        tableViewBackground.frame = CGRectMake(tableViewBackground.frame.origin.x, tableViewBackground.frame.origin.y, tableViewBackground.frame.size.width, tableViewBackground.frame.size.height+rowHeight*(lecturersList.count-1));
        viewBase.frame = CGRectMake(viewBase.frame.origin.x, viewBase.frame.origin.y, viewBase.frame.size.width, viewBase.frame.size.height+rowHeight*(lecturersList.count-1));
        obj = nil;
        obj = [viewBase viewWithTag:2];
        while (obj!=nil) {
            obj.frame = CGRectMake(obj.frame.origin.x, obj.frame.origin.y+rowHeight*(lecturersList.count-1), obj.frame.size.width, obj.frame.size.height);
            obj.tag -= 2;
            obj = [viewBase viewWithTag:2];
        }
        obj = [viewBase viewWithTag:3];
        while (obj!=nil) {
            obj.frame = CGRectMake(obj.frame.origin.x, obj.frame.origin.y+rowHeight*(lecturersList.count-1), obj.frame.size.width, obj.frame.size.height);
            obj.tag -= 2;
            obj = [viewBase viewWithTag:3];
        }
    }
    if([dates count]>1){ // dostosowanie polozenia innych VIEW do ilosci DAT
        datesTableView.frame = CGRectMake(datesTableView.frame.origin.x, datesTableView.frame.origin.y, datesTableView.frame.size.width, datesTableView.frame.size.height+rowHeight*(dates.count-1));
        datesTableViewBackground.frame = CGRectMake(datesTableViewBackground.frame.origin.x, datesTableViewBackground.frame.origin.y, datesTableViewBackground.frame.size.width, datesTableViewBackground.frame.size.height+rowHeight*(dates.count-1));
        viewBase.frame = CGRectMake(viewBase.frame.origin.x, viewBase.frame.origin.y, viewBase.frame.size.width, viewBase.frame.size.height+rowHeight*(dates.count-1));
        obj = nil;
        obj = [viewBase viewWithTag:secondPartTAG];
        while (obj!=nil) {
            obj.frame = CGRectMake(obj.frame.origin.x, obj.frame.origin.y+rowHeight*(dates.count-1), obj.frame.size.width, obj.frame.size.height);
            obj.tag -= 2;
            obj = [viewBase viewWithTag:secondPartTAG];
        }
    }
    
    if((event.subscription != nil && event.subscription.length>1) || [event.subscription rangeOfString:@"grup powyżej"].location != NSNotFound ){
        [signinButton setEnabled:YES];
        [signinLabel setHidden:YES];
        [signinImage setHidden:NO];
        if([event.subscription rangeOfString:@"@"].location == NSNotFound)
        {
            [signinImage setImage:[UIImage imageNamed:@"phone@2x.png"]];
        }
    }else{
        if([event.subscription rangeOfString:@"na bieżąco"].location != NSNotFound || [event.subscription rangeOfString:@"trakcie imprezy"].location){
            [signinLabel setText:@"Zapisy w trakcie imprezy."];
        }
    }
    if (!([event.descriptionContent length]>1)) {
        [descriptionButton setHidden:YES];
    }
    viewBase.backgroundColor = [UIColor clearColor];
    datesTableView.backgroundColor = [UIColor clearColor];
    scrollView.contentSize = viewBase.frame.size;
    [scrollView addSubview:viewBase];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(tableView==datesTableView){
        return [dates count];
    }else {
        return [lecturersList count];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    if(tableView==datesTableView){
        EventDate *evdate = (EventDate*)[dates objectAtIndex:indexPath.row];
        [[cell textLabel] setText:[NSString stringWithFormat:@"%@, %@ - %@\r\n" ,[dateFormatter stringFromDate:evdate.day], [dateFormatterHour stringFromDate:evdate.openingHour], [dateFormatterHour stringFromDate:evdate.closingHour]] ];
        if ([[DatabaseManager sharedInstance] isEventDateSubscribed:evdate])
        {
            cell.textLabel.textColor = [UIColor colorWithRed:52.0/256 green:156.0/256 blue:0.0 alpha:1.0];
        }
    }else{
        NSString *lecturer = [lecturersList objectAtIndex:[indexPath row]];
        if([lecturer characterAtIndex:0]==' ')
            lecturer = [lecturer substringFromIndex:1];
        [[cell textLabel] setText:lecturer];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selected = [indexPath row];
    if(tableView==datesTableView){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Kalendarz" message:@"Czy na pewno chcesz dodać to wydarzenie do kalendarza?" delegate:self cancelButtonTitle:@"Nie" otherButtonTitles:@"TAK", nil];
        [alert show];
        [alert release];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Prowadzący" message:@"Czy chcesz wyszukać inne wydarzenia prowadzone przez tego prowadzącego?" delegate:self cancelButtonTitle:@"Nie" otherButtonTitles:@"TAK", nil];
        [alert show];
        [alert release];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if([alertView.title isEqual:@"Kalendarz"])
    {
        if(buttonIndex==1){
            EKEventStore *eventStore = [[[EKEventStore alloc] init] autorelease];
            EKEvent *nevent  = [EKEvent eventWithEventStore:eventStore];
            nevent.title     = event.title;
            EventDate *evdate = [dates objectAtIndex:selected];
            nevent.startDate = evdate.openingHour;
            nevent.endDate   = evdate.closingHour;
            [nevent setCalendar:[eventStore defaultCalendarForNewEvents]];
            NSError *err;
            [eventStore saveEvent:nevent span:EKSpanThisEvent error:&err];       
        }
        [datesTableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:selected inSection:0] animated:YES];
    }else{ // Prowadzacy
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Search" object:nil userInfo:[NSDictionary dictionaryWithObject:[lecturersList objectAtIndex:selected] forKey:@"string"]];
        [tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:selected inSection:0] animated:YES];
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [dateFormatter release];
    [dateFormatterHour release];
    [event release];
    [lecturersList release];
    [dates release];
    [super dealloc];
}

@end