//
//  apiconstants.h
//  Muse
//
//  Created by Pasca Maulana on 30/9/14.
//  Copyright (c) 2014 Digi. All rights reserved.
//

#ifndef Muse_apiconstants_h
#define Muse_apiconstants_h

#define iMuseBaseUrl                        @"http://api.muse.co.id"
//#define iMuseBaseUrl                        @"http://ec2-54-179-134-178.ap-southeast-1.compute.amazonaws.com:3000"

#define apiPostSignInFacebook               @"/api/session/facebook"
//#define apiGetUsers                         @"/api/users/%@"

//#define apiGetProducts                      @"/api/products/%@"
//#define apiGetItems                         @"/api/%@/items?count=10"
//#define apiPostActions                      @"/api/actions"
//#define apiGetAddFavorites                  @"/api/%@/favorites?page=%@"
//#define apiGetDeleteFavorites               @"/api/%@/favorites"
//#define apiGetCategories                    @"/api/%@/categories"
//#define apiGetPayment                       @"/api/payment/%@"

#define apiGetUsers                         @"/api/users/me"
#define apiFeedBack                         @"/api/feedbacks"
#define apiPostBuy                          @"/api/%@/buy"
#define apiGetShopList                      @"/api/customers/%@/shoplist"
#define apiGetProducts                      @"/api/products/%@"
#define apiPostActions                      @"/api/actions"
#define apiGetCategories                    @"/api/%@/categories"
#define apiGetAddFavorites                  @"/api/%@/favorites?page=%d&count=9"
#define apiGetDeleteFavorites               @"/api/%@/removefavorites"

#endif
