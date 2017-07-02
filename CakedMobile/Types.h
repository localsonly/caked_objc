//
//  Types.h
//  CakedMobile
//
//  Created by Hieu Do on 7/1/17.
//  Copyright © 2017 Hieu Do. All rights reserved.
//

#ifndef Types_h
#define Types_h

@interface Category : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *id;
-(NSString *)description;
@end

@interface Item : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSString *itemDescription;
@property (strong, nonatomic) NSMutableArray *variations;
@property (strong, nonatomic) NSString *imageUrl;
-(NSString *)description;
@end

@interface Variation : NSObject
@property (strong, nonatomic) NSString *itemname;
@property (strong, nonatomic) NSString *varname;
@property (strong, nonatomic) NSNumber *price;
-(NSString *)description;
@end

@interface CartItem : NSObject
@property (strong, nonatomic) Variation* variation;
@property int amount;
-(NSString *)description;
@end

#endif /* Types_h */
