//
//  SubCategoryListView.h
//  DFN
//
//  Created by Radoslaw Wilczak on 17.03.2012.
//  Copyright (c) 2012 Pawel.Nuzka@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseManager.h"

@interface SubCategoryListView : UITableViewController
{
    NSMutableArray *list;
    Section *section;
}
@property (nonatomic, retain) Section *section;
@end
