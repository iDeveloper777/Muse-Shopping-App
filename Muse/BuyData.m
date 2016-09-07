//
//  BuyData.m
//  Muse
//
//  Created by Mike Tran on 21/11/14.
//  Copyright (c) 2014 Digi. All rights reserved.
//

#import "BuyData.h"

@implementation BuyData

#pragma mark - Object Lifecycle

- (instancetype)initWithData:(NSString *)phone
                      mobile:(NSString *)mobile
                     address:(NSString *)address
                        adm1:(NSString *)adm1
                        adm2:(NSString *)adm2
                  postalCode:(NSString *)postalCode
                       items:(NSArray *)items
{
    self = [super init];
    if (self)
    {
        _phone = phone;
        _mobile = mobile;
        _address = address;
        _adm1 = adm1;
        _adm2 = adm2;
        _postalCode = postalCode;
        _items = items;        
    }
    return self;
}
@end
