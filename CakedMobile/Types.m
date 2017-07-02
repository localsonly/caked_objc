//
//  Types.m
//  CakedMobile
//
//  Created by Hieu Do on 7/1/17.
//  Copyright © 2017 Hieu Do. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Types.h"

@implementation Category

-(NSString *)description {
    return [NSString stringWithFormat:@"%@", _name];
}

@end

@implementation Item

-(NSString *)description {
    return [NSString stringWithFormat:@"%@", _name];
}

@end

@implementation Variation

-(NSString *)description {
    return [NSString stringWithFormat:@"%@ (%@)", _itemname, _varname];
}

@end

@implementation CartItem

-(NSString *)description {
    return [NSString stringWithFormat:@"%@", _variation.description];
}

@end
