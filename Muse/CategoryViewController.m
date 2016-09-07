//
//  Slide2VC.m
//  Muse
//
//  Created by Mike Tran on 25/11/14.
//  Copyright (c) 2014 Digi. All rights reserved.
//

#import "CategoryViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "apiconstants.h"
#import "Utils.h"
#import "AppDelegate.h"

#import "MuseSingleton.h"
#import "LoginModel.h"
#import "RecordsModel.h"

@interface CategoryViewController ()<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    NSMutableArray *_bgImageView;
    NSMutableArray *prodButtonArray;
    NSMutableArray *barImageArray;
    NSMutableArray *barStatusArray;
    
    UIScrollView *_bgScrollView;
    
    int itemID;
    NSMutableArray *arrayProductTypes;
    NSMutableArray *arrayProductCategories;
    NSMutableArray *arrayCategories;
    int isSetCategory;
}
@end

@implementation CategoryViewController
@synthesize catData01, catData02, catData03, catData04;
@synthesize indicatorView;
@synthesize arrayItems, arrayTotalItems;

- (instancetype) initWithData:(NSMutableArray *) arryItems arrayTotalItems:(NSMutableArray *) arrayTotalItems
{
    self = [super init];
    if (self)
    {
        self.arrayItems = arryItems;
        self.arrayTotalItems = arrayTotalItems;
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    catData01 = [[NSMutableArray alloc] init];
    catData02 = [[NSMutableArray alloc] init];
    catData03 = [[NSMutableArray alloc] init];
    catData04 = [[NSMutableArray alloc] init];
    
    prodButtonArray = [[NSMutableArray alloc] init];
    barImageArray = [[NSMutableArray alloc] init];
    barStatusArray = [[NSMutableArray alloc] init];
    arrayProductTypes = [[NSMutableArray alloc] init];
    arrayProductCategories = [[NSMutableArray alloc] init];
    
    arrayCategories = [[NSMutableArray alloc] init];
    isSetCategory = 0;
    
    [self.view setBackgroundColor: [UIColor colorWithRed:239.f/255.f
                                                   green:239.f/255.f
                                                    blue:239.f/255.f
                                                   alpha:1.f]];
    UILabel *strLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    strLabel.font = [UIFont boldSystemFontOfSize:20.0];
    strLabel.textAlignment = NSTextAlignmentCenter;
    strLabel.textColor = [UIColor redColor];
    strLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    
    //    self.navigationController.navigationBar.topItem.titleView = strLabel;
    strLabel.text = @"Categories";
    [strLabel sizeToFit];
    
    //    self.navigationController.navigationBar.topItem.title = @"Details";
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:110.f/255.f
                                                                        green:110.f/255.f
                                                                         blue:110.f/255.f
                                                                        alpha:1.f];
    
    UIImage *myIcon = [Utils imageWithImage:[UIImage imageNamed:@"logo.png"] scaledToSize:CGSizeMake(76, 17)];
    UIImageView *titleView = [[UIImageView alloc] initWithImage:myIcon];
    self.navigationItem.titleView = titleView;

    //Sort Datas
    [self sortDatas];
    [self layoutComponents];
//    [indicatorView stopAnimating];
}

- (void) sortDatas
{
    RecordsModel * rData;
    CategoryModel * tempCategory;
    int bFlag = 0;
    
    for (rData in arrayTotalItems)
    {
        if ([rData.category.parent isEqualToString:@"Clothing"])
        {
            bFlag = 0;
            for (tempCategory in catData01){
                if ([tempCategory.name isEqualToString:rData.category.name])
                    bFlag = 1;
            }
            if (bFlag == 0)
                [catData01 addObject:rData.category];
        }else if ([rData.category.parent isEqualToString:@"Shoes"])
        {
            bFlag = 0;
            for (tempCategory in catData02){
                if ([tempCategory.name isEqualToString:rData.category.name])
                    bFlag = 1;
            }
            if (bFlag == 0)
                [catData02 addObject:rData.category];
        }else if ([rData.category.parent isEqualToString: @"Bags"])
        {
            bFlag = 0;
            for (tempCategory in catData03){
                if ([tempCategory.name isEqualToString:rData.category.name])
                    bFlag = 1;
            }
            if (bFlag == 0)
                [catData03 addObject:rData.category];
        }else if ([rData.category.parent isEqualToString:@"Accessories"])
        {
            bFlag = 0;
            for (tempCategory in catData04){
                if ([tempCategory.name isEqualToString:rData.category.name])
                    bFlag = 1;
            }
            if (bFlag == 0)
                [catData04 addObject:rData.category];
        }
    }
    
    for (tempCategory in catData01){
        [arrayProductTypes addObject:tempCategory];
    }
    for (tempCategory in catData02){
        [arrayProductTypes addObject:tempCategory];
    }
    for (tempCategory in catData03){
        [arrayProductTypes addObject:tempCategory];
    }
    for (tempCategory in catData04){
        [arrayProductTypes addObject:tempCategory];
    }
    
    AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    if (appDelegate.shopCategoryList.count > 0)
    {
        for (tempCategory in appDelegate.shopCategoryList)
        {
            [arrayCategories addObject:tempCategory];
        }
    }
    else
    {
        for (tempCategory in arrayProductTypes)
        {
            [arrayCategories addObject:tempCategory];
        }
    }
}

- (void) layoutComponents
{
    CGFloat topPadding = 25.f;
    CGFloat leftPadding = 25.f;
    
    CGFloat catHeight = 50.f;
//    CGFloat cellHeight = 25.f;
    CGFloat barHeight = 10.f;
    
    CGFloat prodHeight = 40.f;
    CGFloat prodCellHeight = 20.f;
    CGFloat prodBarHeight = 10.f;
    CGFloat prodCellWidth = (self.view.bounds.size.width - leftPadding*2) / 3;
    
    CGFloat scrollHeight = (catHeight + barHeight) * 4 + (ceil((double)catData01.count / 3)+ceil((double)catData02.count / 3)+ceil((double)catData03.count / 3)+ceil((double)catData04.count / 3))* (prodHeight+ prodBarHeight)+50;
    
    CGPoint bgSPoint = CGPointMake(self.view.bounds.size.width, self.view.bounds.size.height);
    _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, bgSPoint.x, bgSPoint.y)];
    _bgScrollView.contentSize = CGSizeMake(bgSPoint.x, scrollHeight);
    _bgScrollView.pagingEnabled = true;
    _bgScrollView.bounces = false;
    _bgScrollView.delegate = self;
    _bgScrollView.layer.borderWidth = 0.5f;
    _bgScrollView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    _bgScrollView.layer.cornerRadius = 2;
    
    CategoryModel *rData;
    NSString *currentParent = @"";
    int parentCount = 0;
    int prodCellCount = 0;
    int prodRowCount = 0;
    int prodCount = 0;
    CGRect imageRect;
    
    for (rData in arrayProductTypes)
    {
        //If New Parent;...
        
        if (![rData.parent isEqual:currentParent])
        {
            int nIndex = 0;
            if ([rData.parent isEqualToString:@"Clothing"])
                nIndex = 1;
            if ([rData.parent isEqualToString:@"Shoes"])
                nIndex = 2;
            if ([rData.parent isEqualToString:@"Bags"])
                nIndex = 3;
            if ([rData.parent isEqualToString:@"Accessories"])
                nIndex = 4;
                
            prodCellCount = 0;
            
            UIImage *parentImage;
            
            switch (nIndex)
            {
                case 1:
                    parentImage = [UIImage imageNamed:@"clothing_cat.png"];
                    break;
                case 2:
                    parentImage = [UIImage imageNamed:@"shoes_cat.png"];
                    prodRowCount ++;
                    break;
                case 3:
                    parentImage = [UIImage imageNamed:@"bags_cat.png"];
                    prodRowCount ++;
                    break;
                case 4:
                    parentImage = [UIImage imageNamed:@"accessories_cat"];
                    prodRowCount ++;
                    break;
                default:
                    break;
            }
            
            int tempHeight = parentCount*(catHeight+barHeight)+prodRowCount*(prodHeight+prodBarHeight)+topPadding;
            imageRect = CGRectMake(leftPadding, tempHeight, 40.f+[rData.parent length]*12, catHeight - topPadding);
            UIImageView *parentImageView = [[UIImageView alloc] initWithFrame:imageRect];

            parentImageView.image = parentImage;
            [_bgScrollView addSubview:parentImageView];
            
            //bar
            UIImageView *catbarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(leftPadding,
                                                                         tempHeight + catHeight -topPadding + barHeight - 2,
                                                                          self.view.bounds.size.width - leftPadding * 2,
                                                                          1)];
            [catbarImageView setBackgroundColor: [UIColor colorWithRed:183.f/255.f
                                                               green:183.f/255.f
                                                                blue:183.f/255.f
                                                               alpha:1.f]];
            [_bgScrollView addSubview:catbarImageView];
            currentParent = rData.parent;
            parentCount ++;
        }
        
        if (prodCellCount > 0 && prodCellCount % 3 == 0)
        {
            prodRowCount++;
        }
        
        int tempHeight = parentCount*(catHeight+barHeight)+prodRowCount*(prodHeight+prodBarHeight)+topPadding;
        imageRect = CGRectMake(leftPadding + (prodCellCount % 3)*prodCellWidth, tempHeight, prodCellWidth, prodCellHeight);
        
        
        UIButton *prodBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        prodBtn.frame = imageRect;
        [prodBtn addTarget:self action:@selector(pressProduct:) forControlEvents:UIControlEventTouchUpInside];
        prodBtn.tag = prodCount;
        [prodBtn setTitle:rData.name forState:UIControlStateNormal];
        [prodBtn setTitleColor:[UIColor colorWithRed:110.f/255.f green:110.f/255.f blue:110.f/255.f alpha:1.f] forState:UIControlStateNormal];
        prodBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica Light" size:18.0];
        [_bgScrollView addSubview:prodBtn];
        [prodButtonArray addObject:prodBtn];
        [arrayProductCategories addObject:rData];
        
        //bar
        int bFlag = 0;
        for (int i = 0; i<arrayCategories.count; i++)
        {
            CategoryModel *tCategory = [arrayCategories objectAtIndex:i];
            if ([rData.name isEqualToString:tCategory.name])
                bFlag = 1;
        }
        
        if (bFlag == 0)
        {
            UIImageView *prodbarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(leftPadding + prodCellWidth * (prodCellCount % 3),
                                                                                          tempHeight + prodHeight -topPadding + prodBarHeight - 2,
                                                                                          prodCellWidth - 3,
                                                                                          1.5f)];
            [prodbarImageView setBackgroundColor: [UIColor colorWithRed:183.f/255.f green:183.f/255.f blue:183.f/255.f alpha:0.5f]];
            [_bgScrollView addSubview:prodbarImageView];
            
            [barImageArray addObject:prodbarImageView];
            [barStatusArray addObject:@"OFF"];
        }
        else
        {
            UIImageView *prodbarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(leftPadding + prodCellWidth * (prodCellCount % 3),
                                                                                          tempHeight + prodHeight -topPadding + prodBarHeight - 2,
                                                                                          prodCellWidth - 3,
                                                                                          1.5f)];
            [prodbarImageView setBackgroundColor: [UIColor colorWithRed:232.f/255.f green:56.f/255.f blue:129.f/255.f alpha:1.f]];
            [_bgScrollView addSubview:prodbarImageView];
            
            [barImageArray addObject:prodbarImageView];
            
            [barStatusArray addObject:@"ON"];
        }

        prodCellCount ++;
        prodCount ++;
    }

    [self.view addSubview:_bgScrollView];
    
}

-(IBAction)pressProduct:(id)sender
{
    UIImageView *currentBar = [barImageArray objectAtIndex:[sender tag]];
    NSString *currentStatus = [barStatusArray objectAtIndex:[sender tag]];
    CategoryModel *currentProductCategory = [arrayProductCategories objectAtIndex:[sender tag]];
    
    if ([currentStatus isEqual:@"OFF"])
    {
        [currentBar setBackgroundColor:[UIColor colorWithRed:232.f/255.f green:56.f/255.f blue:129.f/255.f alpha:1.f]];
        [barStatusArray setObject:@"ON" atIndexedSubscript:[sender tag]];
        
        int bFlag = 0;
        for (CategoryModel *tCategory in arrayCategories)
        {
            if ([tCategory.name isEqualToString:currentProductCategory.name])
               bFlag = 1;
        }
        
        if (bFlag == 0)
        {
            [arrayCategories addObject:currentProductCategory];
        }
    }
    else
    {
        [currentBar setBackgroundColor:[UIColor colorWithRed:183.f/255.f green:183.f/255.f blue:183.f/255.f alpha:1.f]];
        [barStatusArray setObject:@"OFF" atIndexedSubscript:[sender tag]];
        
        for (int i=0; i<arrayCategories.count; i++)
        {
            CategoryModel *tCategory = [arrayCategories objectAtIndex:i];
            
            if ([tCategory.name isEqualToString:currentProductCategory.name])
                [arrayCategories removeObjectAtIndex:i];
        }
    }
    isSetCategory = 1;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    appDelegate.shopCategoryList = arrayCategories;
    if (appDelegate.isSetCategory == 0)
        appDelegate.isSetCategory = isSetCategory;
    
}
@end