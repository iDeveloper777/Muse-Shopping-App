//
//  MuseSingleton.m
//  Muse
//
//  Created by Pasca Maulana on 8/10/14.
//  Copyright (c) 2014 Digi. All rights reserved.
//

#import "MuseSingleton.h"


@implementation MuseSingleton

static MuseSingleton *singletonInstance;

+ (MuseSingleton*)getInstance{
    if (singletonInstance == nil) {
        singletonInstance = [[super alloc] init];
    }
    return singletonInstance;
}

-(void)setLoginData:(LoginModel*)parameter{
    logindata = parameter;
}

-(LoginModel*)getLoginData{
    return logindata;
}


-(void)setProductsData:(ProductsModel *)parameter{
    productdata = parameter;
}

-(ProductsModel*)getProductsData{
    return productdata;
}

-(void)setUserData:(UserData *)parameter
{
    userData = parameter;
}

-(UserData *)getUserData
{
    return userData;
}

-(void)setShopList:(ShopList *)parameter
{
    shoplist = parameter;
}

-(ShopList*)getShopList{
    return shoplist;
}


@end