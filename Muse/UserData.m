//
//  UserData.m
//  Muse
//
//  Created by Mike Tran on 21/11/14.
//  Copyright (c) 2014 Digi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserData.h"

@implementation UserData

#pragma mark - Object Lifecycle

- (instancetype)initWithData:(NSString *)userid
                    username:(NSString *)username
                       email:(NSString *)email
                        fbId:(NSString *)fbId
          gcmRegisterationId:(NSString *)gcmRegisterationId
                       phone:(NSString *)phone
                      mobile:(NSString *)mobile
                     address:(NSString *)address
                        adm1:(NSString *)adm1
                        adm2:(NSString *)adm2
                  postalCode:(NSString *)postalCode
{
    self = [super init];
    if (self)
    {
        _userid = userid;
        _username = username;
        _email = email;
        _fbId = fbId;
        _gcmRegisterationId = gcmRegisterationId;
        _phone = phone;
        _mobile = mobile;
        _address = address;
        _adm1 = adm1;
        _adm2 = adm2;
        _postalCode = postalCode;
    }
    return self;
}
@end
