//
//  ModelImageView.h
//  Muse
//
//  Created by Mike Tran on 24/11/14.
//  Copyright (c) 2014 Digi. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ShopProduct.h"

@interface ModelImageView : UIImageView

@property (nonatomic, strong) UINavigationController  *navController;
@property (nonatomic, strong) ShopProduct *currentProduct;
@property (nonatomic, strong) UIImageView * frameImage;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

- (instancetype)initWithFrame:(CGRect)frame
               currentProduct:(ShopProduct *)currentProduct;

@end
