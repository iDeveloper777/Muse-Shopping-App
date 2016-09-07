//
//  MuseSingleton.h
//  Muse
//
//  Created by Pasca Maulana on 8/10/14.
//  Copyright (c) 2014 Digi. All rights reserved.
//

#ifndef Muse_MuseSingleton_h
#define Muse_MuseSingleton_h

#import "LoginModel.h"
#import "ProductsModel.h"
#import "UserData.h"
#import "ShopList.h"

@interface MuseSingleton : NSObject{
    LoginModel *logindata;
    ProductsModel *productdata;
    
    UserData *userData;
    ShopList *shoplist;
}

+(MuseSingleton*) getInstance;

//getter setter logindata
-(void)setLoginData:(LoginModel*)parameter;
-(LoginModel*)getLoginData;

//getter setter shopdata
-(void)setProductsData:(ProductsModel*)parameter;
-(ProductsModel*)getProductsData;

//getter setter userdata
-(void)setUserData:(UserData *)parameter;
-(UserData *)getUserData;

//getter setter shoplist
-(void)setShopList:(ShopList*)parameter;
-(ShopList*)getShopList;

@end

#endif
