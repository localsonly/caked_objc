//
//  UITableViewController+CartViewController.m
//  CakedMobile
//
//  Created by Hieu Do on 7/2/17.
//  Copyright © 2017 Hieu Do. All rights reserved.
//

#import "CartViewController.h"
#import "Types.h"

@interface CartViewController()
@property NSMutableDictionary *objects;
@end

@implementation CartViewController

- (void)configureView {
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CartItem"];
}

- (void) addCartItem:(Variation*)var amount:(int)amount {
    
    CartItem *cartItem = [self.objects objectForKey:var.description];
    
    if(cartItem == nil) {
        cartItem = [[CartItem alloc] init];
        [self.objects setObject:cartItem forKey:var.description];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
    if (!self.objects) {
        self.objects = [[NSMutableDictionary alloc] init];
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CartItem" forIndexPath:indexPath];
    
    NSArray* keys = [self.objects allKeys]; // TODO: Does the dictionary become out of sync?? On (add) function where a new item is added or one is remove, we must check
    
    // TODO: How to get another cell text label?
    cell.textLabel.text = [[keys objectAtIndex:[indexPath row]] description];

    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


@end
