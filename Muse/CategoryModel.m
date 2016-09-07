//
//  CategoryModel.m
//  Muse
//
//  Created by Pasca Maulana on 12/10/14.
//  Copyright (c) 2014 Digi. All rights reserved.
//

#import "CategoryModel.h"

@implementation CategoryModel

- (instancetype) initWithJSONData:(NSDictionary *)jsondata
{
    _id = [jsondata objectForKey:@"id"];
    _name = [jsondata objectForKey:@"name"];
    _parent = [jsondata objectForKey:@"parent"];
    _sortOrder = [NSString stringWithFormat:@"%@", [jsondata objectForKey:@"sortOrder"]];
    _created = [NSString stringWithFormat:@"%@", [jsondata objectForKey:@"created"]];
    
    return self;
}
@end

