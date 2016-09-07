#import "Utils.h"
#import "FavoriteViewController.h"
#import "UIViewController+AMSlideMenu.h"
#import "UIColor+CreateMethods.h"

#import "DetailViewController.h"
#import "CategoryViewController.h"
#import "CategoryModel.h"
#import "AppDelegate.h"
#import "ProgressHUD.h"

@interface FavoriteViewController ()<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UIPageControl *_pgControl;
    NSMutableArray *_images;
    NSMutableArray *_bgImageView;
    
    UIImageView *_barImageView;
    UILabel *_nameLabel;
    UILabel *_brandnameLabel;
    UILabel *_priceLabel;
    UIButton *_buyButton;
    UILabel *_descLabel;
    
    UIScrollView *_bgScrollView;
    
    int totalItems;
    int totalPages;
    int totalRows;
    int deleteItems;
    int itemID;
    NSMutableArray *arrayItems;
    NSMutableArray *arrayTotalItems;
    NSMutableArray *arrayDeleteItems;
    NSMutableArray *arrayModelImageView;
    NSMutableArray *arrayCheckboxView;
    NSMutableArray *arrayCategories;
    NSMutableArray *arrayPreviousCategories;
}
@end

@implementation FavoriteViewController
@synthesize recycleBtn, filterBtn;
@synthesize currentProducts;

- (void)viewDidLoad
{
    [self initDatas];
}

- (void) initDatas
{
    [super viewDidLoad];
    
    [self layoutNavigationBar];
    arrayPreviousCategories = [[NSMutableArray alloc] init];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    arrayCategories = [[NSMutableArray alloc] init];
    AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    CategoryModel *tCategory;
    for (tCategory in appDelegate.shopCategoryList)
    {
        [arrayCategories addObject:tCategory];
    }
    
    //Compare current and previous
    CategoryModel *tPreviousCategory;
    if ((arrayPreviousCategories.count != 0 || arrayCategories.count != 0) && (arrayCategories.count == arrayPreviousCategories.count))
    {
        int bFlag1 = 0;
        int totalFlag1 = 1;
        for (tCategory in arrayCategories)
        {
            bFlag1 = 0;
            for (tPreviousCategory in arrayPreviousCategories)
            {
                if ([tCategory.name isEqualToString:tPreviousCategory.name] && [tCategory.parent isEqualToString:tPreviousCategory.parent])
                    bFlag1 = 1;
            }
            
            if (bFlag1 == 0)
               totalFlag1 = 0;
        }
        
        int bFlag2 = 0;
        int totalFlag2 = 1;
        for (tPreviousCategory in arrayPreviousCategories)
        {
            bFlag2 = 0;
            for (tCategory in arrayCategories)
            {
                if ([tCategory.name isEqualToString:tPreviousCategory.name] && [tCategory.parent isEqualToString:tPreviousCategory.parent])
                    bFlag2 = 1;
            }
            if (bFlag2 == 0)
                totalFlag2 = 0;
        }
        
        if (totalFlag1 == 1 && totalFlag2 == 1)
            return;
    }

    if (arrayCategories.count > 0 && appDelegate.isSetCategory == 0 && arrayPreviousCategories.count == 0)
        return;
    
    //come back from detail page.
    if (arrayCategories.count == 0 && arrayItems.count > 0)
        return;
    //----Compare End----
    
    //delet all objects
    NSArray *viewToRemove = [self.view subviews];
    for (UIView *v in viewToRemove)
        [v removeFromSuperview];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    backgroundImageView.image = [UIImage imageNamed:@"main_background.png"];
    [self.view addSubview:backgroundImageView];
    
//    [self performSelector:@selector(showProgress) withObject:nil afterDelay:0.3];
    [ProgressHUD show:@"Loading..."];
    
    [self getFavoriteList];
    
//    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
}

- (void) showProgress
{
    [ProgressHUD show:@"Loading..."];
}

- (void) getFavoriteList
{
    deleteItems = 0;
    totalItems = 0;
    totalPages = 0;
    arrayDeleteItems = [[NSMutableArray alloc] init];
    arrayItems = [[NSMutableArray alloc] init];
    arrayTotalItems = [[NSMutableArray alloc] init];
    arrayModelImageView = [[NSMutableArray alloc] init];
    arrayCheckboxView = [[NSMutableArray alloc] init];
    
    _bgImageView = [[NSMutableArray alloc] init];
    self.currentProducts = [[ProductsModel alloc] init];
    
    MuseSingleton* singleton = [MuseSingleton getInstance];
    LoginModel* logindata = [singleton getLoginData];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[[AFJSONResponseSerializer alloc] init]];
    [manager setRequestSerializer:[[AFJSONRequestSerializer alloc] init]];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@ %@",@"Bearer", logindata.token] forHTTPHeaderField:@"authorization"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    NSString * strApiURL = [NSString stringWithFormat:@"%@%@", iMuseBaseUrl, [NSString stringWithFormat:apiGetAddFavorites , logindata.id, 1]];
//    NSLog(strApiURL);
    
    [manager GET:strApiURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"Favorite!!! Success!");
         
         ProductsModel *productsList = [[ProductsModel alloc] initWithJSONData:responseObject];
         self.currentProducts = productsList;
         
         RecordsModel *tRecords;
         
         for (tRecords in productsList.records)
             [arrayTotalItems addObject:tRecords];
         
         CategoryModel *tCategory;
         for (tRecords in productsList.records)
         {
             if (arrayCategories.count == 0)
                 [arrayItems addObject:tRecords];
             else
             {
                 int bFlag = 0;
                 for (tCategory in arrayCategories)
                 {
                     if ([tRecords.category.name isEqualToString:tCategory.name] && [tRecords.category.parent isEqualToString:tCategory.parent])
                         bFlag = 1;
                 }
                 if (bFlag == 1)
                     [arrayItems addObject:tRecords];
             }
         }
         
         totalItems = (int)[productsList.meta.total integerValue];
         if (totalItems == 0)
         {
             [ProgressHUD dismiss];
//             [[UIApplication sharedApplication] endIgnoringInteractionEvents];
             return;
         }
         
         if (totalItems % 3 > 0)
             totalRows = (int)(totalItems/3) + 1;
         else
             totalRows = (int)(totalItems/3);
         
         if (totalItems % 9 > 0)
             totalPages = (int)(totalItems/9) + 1;
         else
             totalPages = (int)(totalItems/9);
         
         if (totalPages == 1)
             [self layoutComponents];
         
         for (int i=2; i<=totalPages; i++)
         {
             NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
             NSString * strApiURL = [NSString stringWithFormat:@"%@%@", iMuseBaseUrl, [NSString stringWithFormat:apiGetAddFavorites , logindata.id, i]];
//             NSLog(strApiURL);
             
             [manager GET:strApiURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
              {
                  ProductsModel *productsList = [[ProductsModel alloc] initWithJSONData:responseObject];
                  RecordsModel *tRecords;
                  
                  for (tRecords in productsList.records)
                      [arrayTotalItems addObject:tRecords];
                  
                  CategoryModel *tCategory;
                  for (tRecords in productsList.records)
                  {
                      if (arrayCategories.count == 0)
                          [arrayItems addObject:tRecords];
                      else
                      {
                          int bFlag = 0;
                          for (tCategory in arrayCategories)
                          {
                              if ([tRecords.category.name isEqualToString:tCategory.name] && [tRecords.category.parent isEqualToString:tCategory.parent])
                                  bFlag = 1;
                          }
                          if (bFlag == 1)
                              [arrayItems addObject:tRecords];
                      }
                  }
                  
                  if (i == totalPages)
                  {
                      if (arrayItems.count == 0)
                      {
                          [ProgressHUD dismiss];
//                          [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                          return;
                      }

                      [self layoutComponents];
                  }
              }failure:^(AFHTTPRequestOperation *operation, NSError *error)
              {
                  NSLog(@"Failure! %@", error.description);
                  
                  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Notification!" message:@"Server Error!" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
                  [alertView show];
                  
                  [ProgressHUD dismiss];
              }];
         }
//         [self layoutComponents];
         
         
     }failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Failure! %@", error.description);
         
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Notification!" message:@"Server Error!" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
         [alertView show];
         
         [ProgressHUD dismiss];
     }];
    
    //PreviousCategories Settings.
    CategoryModel *tCategory;
    arrayPreviousCategories = [[NSMutableArray alloc] init];
    for (tCategory in arrayCategories)
    {
        [arrayPreviousCategories addObject:tCategory];
    }
    
    AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (tCategory in appDelegate.shopCategoryList)
    {
        [tempArray addObject:tCategory];
    }
    appDelegate.shopCategoryList = tempArray;
}

- (void) layoutNavigationBar
{
//    UIImage *myIcon = [Utils imageWithImage:[UIImage imageNamed:@"logo.png"] scaledToSize:CGSizeMake(76, 17)];
//    UIImageView *titleView = [[UIImageView alloc] initWithImage:myIcon];
//    [self.navigationController.navigationBar.topItem setTitleView:titleView];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(20.0f, 30.0f, 80.0f, 44.0f)];
    
    recycleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    recycleBtn.frame = CGRectMake( 41, 0, 44, 44);
    [recycleBtn addTarget:self action:@selector(pressRecycleButton) forControlEvents:UIControlEventTouchUpInside];
    [recycleBtn setImage:[UIImage imageNamed:@"recycle01.png"] forState:UIControlStateNormal];
    [recycleBtn setImage:[UIImage imageNamed:@"recycle02.png"] forState:UIControlStateHighlighted];
    [rightView addSubview:recycleBtn];

    filterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    filterBtn.frame = CGRectMake( 0, 0, 44, 44);
    [filterBtn addTarget:self action:@selector(pressFilterButton) forControlEvents:UIControlEventTouchUpInside];
    [filterBtn setImage:[UIImage imageNamed:@"filter01.png"] forState:UIControlStateNormal];
    [filterBtn setImage:[UIImage imageNamed:@"filter02.png"] forState:UIControlStateHighlighted];
    [rightView addSubview:filterBtn];
    //    [filterBtn setImage:[UIImage imageNamed:@"recycle02.png"] forState:UIControlEventTouchUpOutside];
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    [rightButtonItem setTarget:self];
    
    [self.navigationController.navigationBar.topItem setRightBarButtonItem:rightButtonItem];
}

- (void) pressRecycleButton
{
    NSLog(@"press Recycle Button!");
    [recycleBtn setImage:[UIImage imageNamed:@"recycle02.png"] forState:UIControlStateNormal];
    [filterBtn setImage:[UIImage imageNamed:@"filter01.png"] forState:UIControlStateNormal];
    
    if (deleteItems == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Notification!" message:@"Please choose items to delete!" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alertView show];
    
        return;
    }
    
    [ProgressHUD show:@"Loading..."];
    
    MuseSingleton* singleton = [MuseSingleton getInstance];
    LoginModel* logindata = [singleton getLoginData];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    //    [manager setResponseSerializer:[[AFJSONResponseSerializer alloc] init]];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@ %@",@"Bearer",logindata.token] forHTTPHeaderField:@"authorization"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    NSString *deleteItemsString = @"";
    for (int i=0; i<arrayDeleteItems.count; i++)
        deleteItemsString = [NSString stringWithFormat:@"%@%@, ", deleteItemsString, [arrayDeleteItems objectAtIndex:i]];
    deleteItemsString = [NSString stringWithFormat:@"%@%@", deleteItemsString, [arrayDeleteItems objectAtIndex:arrayDeleteItems.count-1]];
//    NSLog(deleteItemsString);
    
    [parameters setValue:deleteItemsString forKey:@"items"];
    
    NSString * strApiURL = [NSString stringWithFormat:@"%@%@", iMuseBaseUrl, [NSString stringWithFormat:apiGetDeleteFavorites, logindata.id]];
//    NSLog(strApiURL);
    [manager POST:strApiURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSLog(@"Success!");
        if(_bgScrollView != nil)
           [_bgScrollView removeFromSuperview];
        [self getFavoriteList];
         
    }failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"Failure! %@", error.description);
         
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Notification!" message:@"Server Error!" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
         [alertView show];
    }];
}

- (void) pressFilterButton
{
    NSLog(@"press Filter Button!");
    [filterBtn setImage:[UIImage imageNamed:@"filter02.png"] forState:UIControlStateNormal];
    [recycleBtn setImage:[UIImage imageNamed:@"recycle01.png"] forState:UIControlStateNormal];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CategoryViewController *categoryViewController = [storyboard instantiateViewControllerWithIdentifier:@"categoryView"];
    
    [categoryViewController initWithData:arrayItems arrayTotalItems:arrayTotalItems];
    [self.navigationController pushViewController:categoryViewController animated:TRUE];
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //[[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
    [[self mainSlideMenu] unfixStatusBarView];
    
    [ProgressHUD dismiss];
}

-(void) tapDetected:(UIGestureRecognizer *)gestureRecognizer
{
    ModelImageView *modelImageView = (ModelImageView*)[gestureRecognizer view];
    modelImageView.frameImage.hidden = NO;
    
    //delete frame of other images
    for (int i=0; i<_bgImageView.count; i++)
    {
        ModelImageView *tempImageView = [_bgImageView objectAtIndex:i];
        if (tempImageView != modelImageView)
        {
            int bFlag = 0;
            
            for (int j=0; j<arrayDeleteItems.count; j++)
            {
                if (tempImageView.currentProduct.id == [arrayDeleteItems objectAtIndex:j])
                    bFlag = 1;
            }
            
            if (bFlag == 0)
                tempImageView.frameImage.hidden = YES;
        }
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailViewController *detailViewController = [storyboard instantiateViewControllerWithIdentifier:@"detailView"];
    
//    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    [detailViewController initWithData:modelImageView.currentProduct];
    [self.navigationController pushViewController:detailViewController animated:TRUE];

}

- (void) checktapDetected:(UIGestureRecognizer *)gestureRecognizer
{
    CheckboxView *checkboxView = (CheckboxView *)[gestureRecognizer view];
    ModelImageView *modelImageView, *tempModel;
    
    for (int i=0; i<_bgImageView.count; i++)
    {
        tempModel = [_bgImageView objectAtIndex:i];
        if (tempModel.currentProduct.id == checkboxView.currentProduct.id)
            modelImageView = tempModel;
    }
    
    if (checkboxView.bStatus == FALSE)
    {
        checkboxView.bStatus = TRUE;
        checkboxView.checkboxImage02.hidden = NO;
        modelImageView.frameImage.hidden = NO;
        
        [arrayDeleteItems addObject:modelImageView.currentProduct.id];
        deleteItems ++;
    }
    else
    {
        checkboxView.bStatus = FALSE;
        checkboxView.checkboxImage02.hidden = YES;
        modelImageView.frameImage.hidden = YES;
        
        for (int i=0; i<arrayDeleteItems.count; i++)
        {
            if ([arrayDeleteItems objectAtIndex:i] == modelImageView.currentProduct.id)
                [arrayDeleteItems removeObjectAtIndex:i];
        }
        deleteItems --;
    }
    
}

- (void) layoutComponents
{
    
    totalItems = (int)arrayItems.count;
    if (totalItems % 3 > 0)
        totalRows = (int)(totalItems/3) + 1;
    else
        totalRows = (int)(totalItems/3);
    
    if (totalItems % 9 > 0)
        totalPages = (int)(totalItems/9) + 1;
    else
        totalPages = (int)(totalItems/9);
    
    CGFloat topPadding = 5.f;
    CGFloat leftPadding = 5.f;
    CGFloat centerPadding = 5.f;
    
    CGPoint bgSPoint = CGPointMake(self.view.bounds.size.width, self.view.bounds.size.height);
    _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(leftPadding, topPadding, bgSPoint.x - leftPadding * 2, bgSPoint.y - topPadding * 2)];
    [_bgScrollView setBackgroundColor:[UIColor colorWithRed:239.f/255.f
                                                      green:239.f/255.f
                                                       blue:239.f/255.f
                                                      alpha:0.5f]];
    if (totalItems == 0)
        _bgScrollView.contentSize = CGSizeMake(bgSPoint.x - leftPadding * 2, self.view.bounds.size.height-  - topPadding * 2);
    else
    {
        
        _bgScrollView.contentSize = CGSizeMake(bgSPoint.x - leftPadding * 2, (self.view.bounds.size.height  - topPadding * 2)/ 3 * totalRows);
    }
    _bgScrollView.pagingEnabled = true;
    _bgScrollView.bounces = false;
    _bgScrollView.delegate = self;
    _bgScrollView.layer.borderWidth = 0.5f;
    _bgScrollView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    _bgScrollView.showsHorizontalScrollIndicator = false;
    _bgScrollView.layer.cornerRadius = 2;
    
    [self.view addSubview:_bgScrollView];

    ShopProduct *prouctData;
   
    int currWidth = _bgScrollView.bounds.size.width;
    int currHeight =  _bgScrollView.bounds.size.height;
    int imgWidth = (currWidth - leftPadding * 2 - centerPadding) / 3;
    int imgHeight = (currHeight - topPadding * 2 - centerPadding) / 3;
    
    int rCount = 0;
    int rowID, colID;
    
    for (prouctData in arrayItems)
    {
        rowID = rCount / 3;
        colID = rCount % 3;
        
        CGPoint locPoint = CGPointMake((imgWidth + centerPadding) * colID, (imgHeight + centerPadding) * rowID);
        ModelImageView *modelImageView = [[ModelImageView alloc] initWithFrame:CGRectMake(locPoint.x, locPoint.y, imgWidth, imgHeight) currentProduct:prouctData];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
        singleTap.numberOfTapsRequired = 1;
        [modelImageView setUserInteractionEnabled:YES];
        [modelImageView addGestureRecognizer:singleTap];
        [arrayModelImageView addObject:modelImageView];
//        [_bgScrollView addSubview:modelImageView];
        
        [_bgImageView addObject:modelImageView];
        
        CheckboxView *checkboxView = [[CheckboxView alloc] initWithFrame:CGRectMake(locPoint.x + 10, locPoint.y + 10, 20, 16) currentProduct:prouctData];
        UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checktapDetected:)];
        singleTap1.numberOfTapsRequired = 1;
        [checkboxView setUserInteractionEnabled:YES];
        [checkboxView addGestureRecognizer:singleTap1];
        [arrayCheckboxView addObject:checkboxView];
//        [_bgScrollView addSubview:checkboxView];
        
        rCount ++;
    }
    
    //Display
    int bFlag = 0;
    while (bFlag == 0)
    {
        for (int i=0; i<arrayModelImageView.count; i++)
        {
            ModelImageView *tempModelImageView = [arrayModelImageView objectAtIndex:i];
            UIImage *tempImage = tempModelImageView.image;
        
            bFlag = 1;
           
            if ([tempImage isKindOfClass:[UIImage class]])
                bFlag = 0;
            else
            {
                if (bFlag == 1)
                    bFlag = 1;
            }
        }
    }
    
    for (int i = 0; i < arrayModelImageView.count; i++)
    {
        [_bgScrollView addSubview:[arrayModelImageView objectAtIndex:i]];
        [_bgScrollView addSubview:[arrayCheckboxView objectAtIndex:i]];
    }
    
    [ProgressHUD dismiss];
//    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

- (void)fixStatusBar
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        view.backgroundColor = [UIColor colorWithHex:@"#FFFFFF" alpha:1];
        
        [[self mainSlideMenu] fixStatusBarWithView:view];
    }
}

@end
