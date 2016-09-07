//
//  ShopList.h
//  Muse
//
//  Created by Mike Tran on 30/11/14.
//  Copyright (c) 2014 Digi. All rights reserved.
//

#ifndef Muse_ShopList_h
#define Muse_ShopList_h

#import "JSONModel.h"

#import "MetaModel.h"
#import "ShopDatas.h"

@protocol ShopList
@end

@interface ShopList: JSONModel

@property (strong, nonatomic) MetaModel* meta;
@property (strong, nonatomic) NSArray<ShopDatas>* data;

-(instancetype)initWithJSONData:(NSDictionary *) jsondata  bFlag:(int) bFlag;

@end

#endif
