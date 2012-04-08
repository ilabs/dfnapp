//
//  MainCategoryListView.h
//  DFN
//
//  Created by Radoslaw Wilczak on 17.03.2012.
//  Copyright (c) 2012 pawel.jankowski@me.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubCategoryListView.h"

@interface MainCategoryListView : UITableViewController
{
    NSMutableArray *list;
    NSMutableArray *iconList;
    UIImage *infoImage;
}
@end 
