//
//  BuyNowViewController.h
//  Muse
//
//  Created by Mike Tran on 5/12/14.
//  Copyright (c) 2014 Digi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"
#import "ShopDatas.h"

@interface BuyNowViewController : UIViewController<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *buyWebView;
@property (nonatomic, strong) Person *currentPerson;
@property (nonatomic, strong) ShopDatas *currentData;
@property (nonatomic, strong)  UIActivityIndicatorView *indicatorView;

- (instancetype) initWithPerson:(Person *)person;
- (instancetype) initWithData:(ShopProduct *) currentProducts;

@end
