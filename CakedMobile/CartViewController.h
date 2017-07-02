//
//  UITableViewController+CartViewController.h
//  CakedMobile
//
//  Created by Hieu Do on 7/2/17.
//  Copyright © 2017 Hieu Do. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Types.h"

@interface CartViewController : UITableViewController

- (void) addCartItem:(CartItem*)var amount:(int)amount;

@end
