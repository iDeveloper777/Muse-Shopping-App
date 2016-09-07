//
//  RecordsModel.h
//  Muse
//
//  Created by Pasca Maulana on 12/10/14.
//  Copyright (c) 2014 Digi. All rights reserved.
//

#ifndef Muse_RecordsModel_h
#define Muse_RecordsModel_h

#import "JSONModel.h"
#import "BrandModel.h"
#import "CategoryModel.h"
#import "ShopColor.h"
#import "ItemsModel.h"

@protocol RecordsModel
@end

@interface RecordsModel : JSONModel

@property (strong, nonatomic) NSString* id;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) BrandModel* brand;
@property (strong, nonatomic) CategoryModel* category;
@property (strong, nonatomic) NSString* desc;
@property (strong, nonatomic) NSString* seqNum;
@property (strong, nonatomic) NSArray<ShopColor>* color;
@property (strong, nonatomic) NSString* source;
@property (strong, nonatomic) NSString* sourceUrl;
@property (strong, nonatomic) NSString* productId;
@property (strong, nonatomic) NSString* sku;
@property (strong, nonatomic) NSString* price;
@property (strong, nonatomic) NSString* discountPrice;
@property (strong, nonatomic) NSString* created;
@property (strong, nonatomic) NSString* updated;

-(instancetype)initWithJSONData:(NSDictionary *) jsondata;
@end

#endif
