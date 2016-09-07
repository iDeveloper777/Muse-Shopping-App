//
//  ShopModel.h
//  Muse
//
//  Created by Pasca Maulana on 12/10/14.
//  Copyright (c) 2014 Digi. All rights reserved.
//

#ifndef Muse_ShopModel_h
#define Muse_ShopModel_h

#import "MetaModel.h"
#import "RecordsModel.h"

@protocol ProductsModel
@end

@interface ProductsModel : JSONModel

@property (strong, nonatomic) MetaModel* meta;
@property (strong, nonatomic) NSArray<RecordsModel>* records;

-(instancetype)initWithJSONData:(NSDictionary *) jsondata;

@end

#endif
