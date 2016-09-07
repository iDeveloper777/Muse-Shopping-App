//
//  MetaModel.m
//  Muse
//
//  Created by Pasca Maulana on 12/10/14.
//  Copyright (c) 2014 Digi. All rights reserved.
//

#import "MetaModel.h"


@implementation MetaModel

- (instancetype) initWithJSONData:(NSDictionary *)jsondata
{
    _total = [NSString stringWithFormat:@"%@", [jsondata objectForKey:@"total"]];
    return self;
}

@end
