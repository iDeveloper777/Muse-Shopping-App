//
//  Slide2VC.h
//  Muse
//
//  Created by Mike Tran on 25/11/14.
//  Copyright (c) 2014 Digi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryData.h"

@interface CategoryViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *catData01;
@property (nonatomic, strong) NSMutableArray *catData02;
@property (nonatomic, strong) NSMutableArray *catData03;
@property (nonatomic, strong) NSMutableArray *catData04;

@property (nonatomic, strong) NSMutableArray *arrayItems;
@property (nonatomic, strong) NSMutableArray *arrayTotalItems;

@property (nonatomic, strong)  UIActivityIndicatorView *indicatorView;

-(IBAction)pressProduct:(id)sender;

- (instancetype) initWithData:(NSMutableArray *) arryItems arrayTotalItems:(NSMutableArray *)arrayTotalItems;

@end
