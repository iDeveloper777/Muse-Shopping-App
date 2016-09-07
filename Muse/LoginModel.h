//
//  LoginModel.h
//  Muse
//
//  Created by Pasca Maulana on 8/10/14.
//  Copyright (c) 2014 Digi. All rights reserved.
//

#ifndef Muse_LoginModel_h
#define Muse_LoginModel_h

#import "JSONModel.h"

@interface LoginModel : JSONModel

@property (strong, nonatomic) NSString* id;
@property (strong, nonatomic) NSString* created;
@property (strong, nonatomic) NSString* email;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* role;
@property (strong, nonatomic) NSString* token;
//@property (strong, nonatomic) NSString* cookie;

@end

#endif
