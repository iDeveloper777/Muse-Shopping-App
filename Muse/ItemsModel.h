//
//  ItemsModel.h
//  Muse
//
//  Created by Pasca Maulana on 12/10/14.
//  Copyright (c) 2014 Digi. All rights reserved.
//

#ifndef Muse_ItemsModel_h
#define Muse_ItemsModel_h

#import "JSONModel.h"

@protocol ItemsModel
@end

@interface ItemsModel : JSONModel

@property (strong, nonatomic) NSString* size;
@property (strong, nonatomic) NSString* stock;
@property (strong, nonatomic) NSString* price;
//@property (strong, nonatomic) NSString* discountPrice;
@property (strong, nonatomic) NSString* _id;
@property (strong, nonatomic) NSArray* images;
@property (strong, nonatomic) NSString* color;


@end

#endif
