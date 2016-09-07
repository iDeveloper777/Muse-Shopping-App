//
//  ShopList.m
//  Muse
//
//  Created by Mike Tran on 30/11/14.
//  Copyright (c) 2014 Digi. All rights reserved.
//

#import "ShopList.h"

@implementation ShopList

- (instancetype) initWithJSONData:(NSDictionary *)jsondata
                            bFlag:(int) bFlag
{
    MetaModel *metadata = [[MetaModel alloc] initWithJSONData:[jsondata objectForKey:@"meta"]];
    _meta = metadata;
    
    NSMutableArray *arraydata = [[NSMutableArray alloc] init];
    NSDictionary *tempdata;
    
    if (bFlag == 0)
        tempdata = [jsondata objectForKey:@"records"];
    else
        tempdata = [jsondata objectForKey:@"records"];
    
    NSDictionary *tdata;
    
    for (tdata in tempdata)
    {
        [arraydata addObject:[[ShopDatas alloc] initWithJSONData:tdata]];
    }
    
    _data = (NSArray<ShopDatas> *)arraydata;
    return self;
}
@end