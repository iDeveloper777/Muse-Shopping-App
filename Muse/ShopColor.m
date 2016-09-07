//
//  ShopColor.m
//  Muse
//
//  Created by Mike Tran on 30/11/14.
//  Copyright (c) 2014 Digi. All rights reserved.
//

#import "ShopColor.h"

@implementation ShopColor

- (instancetype) initWithJSONData:(NSDictionary *)jsondata
{
    _hex = [jsondata objectForKey:@"hex"];
    _images = [jsondata objectForKey:@"images"];
    _id = [jsondata objectForKey:@"_id"];
    
    NSMutableArray *arraydata = [[NSMutableArray alloc] init];
    NSDictionary *tempdata = [jsondata objectForKey:@"images"];
    NSString *tdata;
    
    for (tdata in tempdata)
    {
        [arraydata addObject:tdata];
    }
    _images = arraydata;
    return self;
}
@end