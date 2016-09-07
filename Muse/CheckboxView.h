//
//  CheckboxView.h
//  Muse
//
//  Created by Mike Tran on 25/11/14.
//  Copyright (c) 2014 Digi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ShopProduct.h"

@interface CheckboxView : UIImageView

@property (nonatomic, strong) UINavigationController  *navController;
@property (nonatomic, strong) ShopProduct *currentProduct;
@property (nonatomic, strong) UIImageView *checkboxImage01;
@property (nonatomic, strong) UIImageView *checkboxImage02;
@property (nonatomic, assign) BOOL bStatus;

- (instancetype)initWithFrame:(CGRect)frame
               currentProduct:(ShopProduct *)currentProduct;

@end
