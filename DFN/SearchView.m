//
//  SearchView.h
//  DFN
//
//  Created by Michał Jodko on 15.04.2012.
//  Copyright (c) 2012 jodko.michal@gmail.com. All rights reserved.
//

#import "SearchView.h"
#import "DatabaseManager.h"
#import "LecturesListView.h"

@implementation SearchView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        searchButton = [[UIBarButtonItem alloc] initWithTitle:@"Szukaj" style:UIBarButtonItemStyleDone target:self action:@selector(performSearch:)];
        self.navigationItem.rightBarButtonItem = searchButton;
    }
    
    return self;
}

- (void)viewDidLoad {
    scrollView.contentSize = CGSizeMake(conditionsView.frame.size.width, conditionsView.frame.size.height + conditionsView.frame.origin.y);
}

- (void)dealloc {
    [searchButton release];
    [super dealloc];
}

- (IBAction)textFieldTouched:(id)sender {
    if(currentTextField == nil) {
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(editingEnded:)] autorelease];
        CGSize scrollViewContentSize = scrollView.contentSize;
        scrollViewContentSize.height += 167.0f;
        scrollView.contentSize = scrollViewContentSize;
    }
    
    currentTextField = sender;
}

- (void)editingEnded:(id)sender {
    [currentTextField resignFirstResponder];
    self.navigationItem.rightBarButtonItem = searchButton;
    CGSize scrollViewContentSize = scrollView.contentSize;
    scrollViewContentSize.height -= 167.0f;
    scrollView.contentSize = scrollViewContentSize;
    currentTextField = nil;
}

- (void)performSearch:(id)sender {
    NSDate *startDate = [NSDate distantPast], *endDate = [NSDate distantFuture];
    
    if([conditionDateSwitch isOn]) {
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
    }
    
    NSPredicate *predicate = 
        [NSPredicate predicateWithFormat:@"(title like[cd] %@) and (category.name like[cd] %@) and (descriptionContent like[cd] %@) and ((place.address like[cd] %@) or (place.city like[cd] %@)) and (lecturer.name like[cd] %@) and (organisation.name like[cd] %@) and (any forms.eventFormType.name like[cd] %@) and !((none dates.day >= %@) or (none dates.day <= %@))",
         [NSString stringWithFormat:@"*%@*", conditionTitle.text], 
         [NSString stringWithFormat:@"*%@*", conditionCategory.text],
         [NSString stringWithFormat:@"*%@*", conditionDescription.text],
         [NSString stringWithFormat:@"*%@*", conditionPlace.text],
         [NSString stringWithFormat:@"*%@*", conditionPlace.text],
         [NSString stringWithFormat:@"*%@*", conditionLecturer.text],
         [NSString stringWithFormat:@"*%@*", conditionOrganisation.text],
         [NSString stringWithFormat:@"*%@*", conditionForm.text],
         startDate, endDate];
    
    NSArray *events = [[DatabaseManager sharedInstance] fetchedManagedObjectsForEntity:@"Event" withPredicate:predicate];
    if(events) {
        LecturesListView *lecturesList = [[[LecturesListView alloc] initWithNibName:@"LecturesListView" bundle:nil events:events] autorelease];
        [self.navigationController pushViewController:lecturesList animated:YES];
    } else {
        NSLog(@"not found");
        [[[[UIAlertView alloc] initWithTitle:@"Wyszukiwanie" message:@"Brak wyników wyszukiwania według ustalonych kryteriów!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
    }
}

@end
