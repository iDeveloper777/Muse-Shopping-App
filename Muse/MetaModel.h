//
//  MetaModel.h
//  Muse
//
//  Created by Pasca Maulana on 12/10/14.
//  Copyright (c) 2014 Digi. All rights reserved.
//

#ifndef Muse_MetaModel_h
#define Muse_MetaModel_h

#import "JSONModel.h"

@protocol MetaModel
@end

@interface MetaModel : JSONModel

@property (strong, nonatomic) NSString* total;

-(instancetype)initWithJSONData:(NSDictionary *) jsondata;
@end


#endif
