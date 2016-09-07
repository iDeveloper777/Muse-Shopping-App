//
//  ShopColor.h
//  Muse
//
//  Created by Mike Tran on 30/11/14.
//  Copyright (c) 2014 Digi. All rights reserved.
//

#ifndef Muse_ShopColor_h
#define Muse_ShopColor_h

#import "JSONModel.h"

@protocol ShopColor
@end

@interface ShopColor : JSONModel

@property (strong, nonatomic) NSString* hex;
@property (strong, nonatomic) NSMutableArray* images;
@property (strong, nonatomic) NSString* id;

-(instancetype)initWithJSONData:(NSDictionary *) jsondata;

@end

#endif
