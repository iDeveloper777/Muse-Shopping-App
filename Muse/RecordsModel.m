//
//  RecordsModel.m
//  Muse
//
//  Created by Pasca Maulana on 12/10/14.
//  Copyright (c) 2014 Digi. All rights reserved.
//

#import "RecordsModel.h"

@implementation RecordsModel

- (instancetype) initWithJSONData:(NSDictionary *)jsondata
{
    _id = [jsondata objectForKey:@"id"];
    _name = [jsondata objectForKey:@"name"];

    //brand
    _brand = [[BrandModel alloc] initWithJSONData:[jsondata objectForKey:@"brand"]];
    
    _desc = [jsondata objectForKey:@"desc"];
    _seqNum = [NSString stringWithFormat:@"%@", [jsondata objectForKey:@"seqNum"]];
    
    //category
    NSDictionary *tempCategory = [jsondata objectForKey:@"category"];
    // confirm isNULL
    if (tempCategory != nil && [tempCategory isKindOfClass:[NSDictionary class]])
        _category = [[CategoryModel alloc] initWithJSONData:[jsondata objectForKey:@"category"]];
   
    //color
    NSMutableArray *arrayColor = [[NSMutableArray alloc] init];
    NSDictionary *tempColor = [jsondata objectForKey:@"color"];
    NSDictionary *tColor;
    for (tColor in tempColor)
    {
        [arrayColor addObject:[[ShopColor alloc] initWithJSONData:tColor]];
    }
    _color = (NSArray<ShopColor> *)arrayColor;
    
    _source = [jsondata objectForKey:@"source"];
    _sourceUrl = [jsondata objectForKey:@"sourceUrl"];
    _productId = [jsondata objectForKey:@"productId"];
    _sku = [jsondata objectForKey:@"sku"];
    _price = [NSString stringWithFormat:@"%@", [jsondata objectForKey:@"price"]];
    _discountPrice = [NSString stringWithFormat:@"%@", [jsondata objectForKey:@"discountPrice"]];
    _created = [jsondata objectForKey:@"created"];
    _updated = [jsondata objectForKey:@"updated"];
    
    return self;
}
@end