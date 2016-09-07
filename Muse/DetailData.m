//
//  DetailData.m
//  Muse
//
//  Created by Mike Tran on 22/11/14.
//  Copyright (c) 2014 Digi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DetailData.h"


@implementation DetailData

#pragma mark - Object Lifecycle

- (instancetype) initWithName:(NSString *)productid
                         name:(NSString *)name
                      brandid:(NSString *)brandid
                    brandname:(NSString *)brandname
                 brandcreated:(NSString *)brandcreated
                     category:(NSArray<CategoryModel> *)category
                         desc:(NSString *)desc
                       seqNum:(NSString *)seqNum
                        items:(NSArray<ItemsModel> *)items
                      created:(NSString *)created
                      updated:(NSString *)updated
{
    self = [super init];
    if (self)
    {
        _productid = productid;
        _name = name;
        _brandid = brandid;
        _brandname = brandname;
        _brandcreated = brandcreated;
        _category = category;
        _desc = desc;
        _seqNum = seqNum;
        _items = items;
        _created = created;
        _updated = updated;
    }
    return self;
}
@end
