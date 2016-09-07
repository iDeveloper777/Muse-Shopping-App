//
//  BrandModel.h
//  Muse
//
//  Created by Pasca Maulana on 12/10/14.
//  Copyright (c) 2014 Digi. All rights reserved.
//

#ifndef Muse_BrandModel_h
#define Muse_BrandModel_h

#import "JSONModel.h"


@protocol BrandModel
@end


@interface BrandModel : JSONModel

@property (strong, nonatomic) NSString* id;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* created;

-(instancetype)initWithJSONData:(NSDictionary *) jsondata;

@end

#endif
