//
//  ShopDatas.m
//  Muse
//
//  Created by Mike Tran on 30/11/14.
//  Copyright (c) 2014 Digi. All rights reserved.
//


#import "ShopDatas.h"

@implementation ShopDatas

- (instancetype) initWithJSONData:(NSDictionary *)jsondata
{
    _seqNum = [NSString stringWithFormat:@"%@", [jsondata objectForKey:@"seqNum"]];
    _source = [jsondata objectForKey:@"source"];
    _sourceUrl = [jsondata objectForKey:@"sourceUrl"];
    
    ShopProduct *shopproduct = [[ShopProduct alloc] initWithJSONData:[jsondata objectForKey:@"product"]];
    _product = shopproduct;
    
    return self;
}
@end