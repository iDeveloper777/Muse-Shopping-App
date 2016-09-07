//
//  DetailViewController.h
//  Muse
//
//  Created by Mike Tran on 21/11/14.
//  Copyright (c) 2014 Digi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utils.h"
#import <UIKit/UIKit.h>

#import "Person.h"
#import "ShopDatas.h"
#import "ShopProduct.h"

@interface DetailViewController : UIViewController

@property (nonatomic, strong) Person *currentPerson;
@property (nonatomic, strong) ShopProduct *currentData;
@property (nonatomic, strong)  UIActivityIndicatorView *indicatorView;
@property (nonatomic, assign) CGRect screenSize;

@property (nonatomic, strong) UIButton *likeBtn;
@property (nonatomic, strong) UIButton *dislikeBtn;

- (instancetype) initWithPerson:(Person *)person;
- (instancetype) initWithData:(ShopProduct *) currentProducts;


@end
