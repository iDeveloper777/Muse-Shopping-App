//
//  ShopDatas.h
//  Muse
//
//  Created by Mike Tran on 30/11/14.
//  Copyright (c) 2014 Digi. All rights reserved.
//

#ifndef Muse_ShopDatas_h
#define Muse_ShopDatas_h

#import "JSONModel.h"

#include "ShopProduct.h"

@protocol ShopDatas
@end

@interface ShopDatas : JSONModel

@property (strong, nonatomic) ShopProduct* product;
@property (strong, nonatomic) NSString* seqNum;
@property (strong, nonatomic) NSString* source;
@property (strong, nonatomic) NSString* sourceUrl;

-(instancetype)initWithJSONData:(NSDictionary *) jsondata;
@end

#endif
