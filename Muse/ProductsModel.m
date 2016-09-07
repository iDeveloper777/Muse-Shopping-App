//
//  ShopModel.m
//  Muse
//
//  Created by Pasca Maulana on 12/10/14.
//  Copyright (c) 2014 Digi. All rights reserved.
//

#import "ProductsModel.h"

@implementation ProductsModel

- (instancetype) initWithJSONData:(NSDictionary *)jsondata
{
    MetaModel *metadata = [[MetaModel alloc] initWithJSONData:[jsondata objectForKey:@"meta"]];
    _meta = metadata;
    
    NSMutableArray *arraydata = [[NSMutableArray alloc] init];
    NSDictionary *tempRecords;
    
    tempRecords = [jsondata objectForKey:@"records"];
    
    NSDictionary *tRecord;
    
    for (tRecord in tempRecords)
    {
        [arraydata addObject:[[RecordsModel alloc] initWithJSONData:tRecord]];
    }
    
    _records = (NSArray<RecordsModel> *) arraydata;
    return self;
}

@end