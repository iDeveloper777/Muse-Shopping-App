//
//  AppDelegate.h
//  Muse
//
//  Created by Pasca Maulana on 29/9/14.
//  Copyright (c) 2014 Digi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainVC.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic) BOOL isLogedin;
@property (strong, nonatomic) NSMutableArray *shopModelList;
@property (strong, nonatomic) NSArray *shopModelListItems;
@property (strong, nonatomic) NSMutableArray *shopCategoryList;
@property (strong, nonatomic) NSMutableArray *shopModelListImages;
@property (assign, nonatomic) int isSetCategory;
@property (assign, nonatomic) int isReload;

@property (strong, nonatomic) NSString *token;

@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) MainVC *mainVC;

@end

