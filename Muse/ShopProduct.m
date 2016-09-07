//
//  ShopProduct.m
//  Muse
//
//  Created by Mike Tran on 30/11/14.
//  Copyright (c) 2014 Digi. All rights reserved.
//


#import "ShopProduct.h"

@implementation ShopProduct

- (instancetype) initWithJSONData:(NSDictionary *)jsondata
{
    _id = [jsondata objectForKey:@"id"];
    _name = [jsondata objectForKey:@"name"];
    
    //brand
    _brand = [[BrandModel alloc] initWithJSONData:[jsondata objectForKey:@"brand"]];

    _desc = [jsondata objectForKey:@"desc"];
    
    _source = [jsondata objectForKey:@"source"];
    _sourceUrl = [jsondata objectForKey:@"sourceUrl"];
    _productId = [jsondata objectForKey:@"productId"];
    _sku = [jsondata objectForKey:@"sku"];
    _price = [NSString stringWithFormat:@"%@", [jsondata objectForKey:@"price"]];
    _discountPrice = [NSString stringWithFormat:@"%@", [jsondata objectForKey:@"discountPrice"] ];
    
    NSMutableArray *arraydata = [[NSMutableArray alloc] init];
    NSDictionary *tempdata = [jsondata objectForKey:@"color"];
    NSDictionary *tdata;
    
    for (tdata in tempdata)
    {
        ShopColor *tempColor = [[ShopColor alloc] initWithJSONData:tdata];
        [arraydata addObject:tempColor];
    }
    
    _color = (NSArray<ShopColor> *)arraydata;
    
    return self;
}
@end