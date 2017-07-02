//
//  MasterViewController.m
//  CakedMobile
//
//  Created by Hieu Do on 7/1/17.
//  Copyright © 2017 Hieu Do. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "Types.h"

@interface MasterViewController ()

@property NSMutableArray *objects;
@property NSMutableDictionary *categories;
@end

NSString *categoryUrl = @"https://connect.squareup.com/v1/34T664QSMKC6D/categories";
NSString *itemsUrl = @"https://connect.squareup.com/v1/34T664QSMKC6D/items";
NSString *personalToken = @"sq0atp-KOI6SGfEm63Dj2H7cgWtKg";
NSString *authValue = @"Bearer sq0atp-KOI6SGfEm63Dj2H7cgWtKg"; // personal access token here

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    if (!self.objects) {
        self.objects = [[NSMutableArray alloc] init];
    }

    UIBarButtonItem *cartButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(goToCart:)];
    self.navigationItem.rightBarButtonItem = cartButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    [self getAllItems];
}

- (void) getAllItems {
    self.categories = [NSMutableDictionary new];
    
    // HTTP ping square to add to table view
    // 1 create URL session
    NSURL *url = [NSURL URLWithString:itemsUrl];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    // 2 create the HTTP request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"GET"];
    
    
    // 3 execute task and handle
    NSURLSessionTask *urlTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        NSError *localError = nil;
        NSArray *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
        
        [self.tableView performSelectorOnMainThread:@selector(beginUpdates) withObject:nil waitUntilDone:true];
        
        for(NSDictionary *dic in parsedObject) {

            NSDictionary *category = [dic valueForKey:@"category"];
            NSString *categoryName = [category valueForKey:@"name"];
            
            if(![self.categories objectForKey:categoryName]) {
                [self.categories setObject:[[NSMutableArray alloc] init] forKey:categoryName];
                
                // Add the category to the master list
                [self.objects addObject:categoryName];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.objects count]-1 inSection:0];
                [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            
            // Add the item to the categorical array
            NSMutableArray *items = [self.categories objectForKey:categoryName];
            
            Item *item = [[Item alloc] init];
            [item setName: [dic valueForKey:@"name"]];
            [item setCategory:categoryName];
            [item setId:[dic valueForKey:@"id"]];
            [item setImageUrl:[[dic objectForKey:@"master_image"] valueForKey:@"url"]];
            [item setItemDescription:[dic valueForKey:@"description"]];
            [item setVariations:[[NSMutableArray alloc] init]];
            
            NSMutableArray *itemVariations = item.variations;
            
            NSMutableArray *variations = [dic objectForKey:@"variations"];
            for(NSDictionary *var in variations) {
                NSDictionary *price = [var valueForKey:@"price_money"];
                
                Variation *v = [[Variation alloc] init];
                v.price = [price valueForKey:@"amount"];
                v.varname = [var valueForKey:@"name"];
                v.itemname = [item valueForKey:@"name"];
                
                [itemVariations addObject:v];
            }
            
            [items addObject:item];
            
        }

        [self.tableView performSelectorOnMainThread:@selector(endUpdates) withObject:nil waitUntilDone:false];
        
    }];

    [urlTask resume];
}

- (void) getCategories {
    // HTTP ping square to add to table view
    // 1 create URL session
    NSURL *url = [NSURL URLWithString:categoryUrl];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    // 2 create the HTTP request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"GET"];
    
    // 3 execute task and handle
    NSURLSessionTask *urlTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        // Print the reply string:
        //NSString *reply = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        
        NSError *localError = nil;
        NSArray *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
        
        [self.tableView beginUpdates];
        
        for(NSDictionary *data in parsedObject) {
            Category *cat = [[Category alloc] init];
            
            for (NSString *key in data) {
                if ([cat respondsToSelector:NSSelectorFromString(key)]) {
                    [cat setValue:[data valueForKey:key] forKey:key];
                }
            }
            
            [self.objects addObject:cat];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.objects count]-1 inSection:0];
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
        [self.tableView endUpdates];
        
    }];
    
    [urlTask resume];
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)goToCart:(id)sender {

}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        NSString *category = self.objects[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetails:category array:[self.categories objectForKey:category]];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
    
    if ([[segue identifier] isEqualToString:@"showCart"]) {
        // Get handle for SINGLE cart instance and show
    }
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    Category *object = self.objects[indexPath.row];
    cell.textLabel.text = [object description];
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}


@end
