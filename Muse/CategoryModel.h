//
//  CategoryModel.h
//  Muse
//
//  Created by Pasca Maulana on 12/10/14.
//  Copyright (c) 2014 Digi. All rights reserved.
//

#ifndef Muse_CategoryModel_h
#define Muse_CategoryModel_h

#import "JSONModel.h"

@protocol CategoryModel
@end

@interface CategoryModel : JSONModel

@property (strong, nonatomic) NSString* id;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* parent;
@property (strong, nonatomic) NSString* sortOrder;
@property (strong, nonatomic) NSString* created;

-(instancetype)initWithJSONData:(NSDictionary *) jsondata;
@end

#endif
