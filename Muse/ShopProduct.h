//
//  ShopProduct.h
//  Muse
//
//  Created by Mike Tran on 30/11/14.
//  Copyright (c) 2014 Digi. All rights reserved.
//

#ifndef Muse_ShopProduct_h
#define Muse_ShopProduct_h

#import "JSONModel.h"

#include "ShopColor.h"
#include "BrandModel.h"

@protocol ShopProduct
@end

@interface ShopProduct : JSONModel

@property (strong, nonatomic) NSString* id;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) BrandModel *brand;
@property (strong, nonatomic) NSString* desc;
@property (strong, nonatomic) NSArray<ShopColor>* color;
@property (strong, nonatomic) NSString* source;
@property (strong, nonatomic) NSString* sourceUrl;
@property (strong, nonatomic) NSString* productId;
@property (strong, nonatomic) NSString* sku;
@property (strong, nonatomic) NSString* price;
@property (strong, nonatomic) NSString* discountPrice;

-(instancetype)initWithJSONData:(NSDictionary *) jsondata;
@end



#endif
