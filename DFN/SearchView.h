//
//  SearchView.h
//  DFN
//
//  Created by Michał Jodko on 15.04.2012.
//  Copyright (c) 2012 jodko.michal@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchView : UIViewController {
    IBOutlet UITextField *conditionCategory, *conditionDescription, *conditionTitle, *conditionForm, *conditionPlace, *conditionLecturer, *conditionOrganisation;
    IBOutlet UIDatePicker *conditionDate;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIView *conditionsView;
    IBOutlet UISwitch *conditionDateSwitch;
    UITextField *currentTextField;
    UIBarButtonItem *searchButton;
}

- (IBAction)textFieldTouched:(id)sender;

@end
