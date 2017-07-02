//
//  DetailViewController.h
//  CakedMobile
//
//  Created by Hieu Do on 7/1/17.
//  Copyright © 2017 Hieu Do. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Types.h"

@interface DetailViewController : UITableViewController
- (void)setDetails:(NSString *)newcategory array:(NSMutableArray *) items;
@property (strong, nonatomic) NSString *category;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

