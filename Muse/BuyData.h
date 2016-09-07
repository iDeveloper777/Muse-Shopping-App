//
//  BuyData.h
//  Muse
//
//  Created by Mike Tran on 21/11/14.
//  Copyright (c) 2014 Digi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuyData: NSObject

@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, assign) NSString *address;
@property (nonatomic, assign) NSString *adm1;
@property (nonatomic, assign) NSString *adm2;
@property (nonatomic, assign) NSString *postalCode;
@property (nonatomic, assign) NSArray *items;

- (instancetype)initWithData:(NSString *)phone
                      mobile:(NSString *)mobile
                     address:(NSString *)address
                        adm1:(NSString *)adm1
                        adm2:(NSString *)adm2
                  postalCode:(NSString *)postalCode
                       items:(NSArray *)items;

@end
