//
//  UserData.h
//  Muse
//
//  Created by Mike Tran on 21/11/14.
//  Copyright (c) 2014 Digi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserData: NSObject

@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, assign) NSString *email;
@property (nonatomic, assign) NSString *fbId;
@property (nonatomic, assign) NSString *gcmRegisterationId;
@property (nonatomic, assign) NSString *phone;
@property (nonatomic, assign) NSString *mobile;
@property (nonatomic, assign) NSString *address;
@property (nonatomic, assign) NSString *adm1;
@property (nonatomic, assign) NSString *adm2;
@property (nonatomic, assign) NSString *postalCode;

- (instancetype)initWithData:(NSString *)userid
                    username:(NSString *)username
                       email:(NSString *)email
                        fbId:(NSString *)fbId
          gcmRegisterationId:(NSString *)gcmRegisterationId
                       phone:(NSString *) phone
                      mobile:(NSString *)mobile
                     address:(NSString *)address
                        adm1:(NSString *)adm1
                        adm2:(NSString *)adm2
                  postalCode:(NSString *) postalCode;
@end