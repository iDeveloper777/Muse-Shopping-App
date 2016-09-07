#import "ChoosePersonViewController.h"
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPRequestOperation.h"
#import "Utils.h"

#import "MuseSingleton.h"
#import "LoginModel.h"
#import "Person.h"

#import "apiconstants.h"
#import "RecordsModel.h"
#import "UserData.h"

#import "ShopList.h"
#import "ShopDatas.h"
#import "AppDelegate.h"
#import "DetailViewController.h"
#import "ProgressHUD.h"

static const CGFloat ChoosePersonButtonHorizontalPadding = 70.f;
static const CGFloat ChoosePersonButtonVerticalPadding = 20.f;

@interface ChoosePersonViewController ()

@end

@implementation ChoosePersonViewController
@synthesize arrayPeoples;
@synthesize screenSize;

#pragma mark - Object Lifecycle

- (instancetype)init {
    self = [super init];
    if (self) {
        _people = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - UIViewController Overrides

- (void)viewDidLoad {
    [super viewDidLoad];
    
    screenSize = [[UIScreen mainScreen] bounds];
    
    [self.view setBackgroundColor: [UIColor colorWithRed:239.f/255.f
                                                   green:239.f/255.f
                                                    blue:239.f/255.f
                                                   alpha:1.f]];
    UIImage *myIcon = [Utils imageWithImage:[UIImage imageNamed:@"logo.png"] scaledToSize:CGSizeMake(76, 17)];
    UIImageView *titleView = [[UIImageView alloc] initWithImage:myIcon];
    [self.navigationController.navigationBar.topItem setTitleView:titleView];
    
    //    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
//    [self performSelector:@selector(showProgress) withObject:nil afterDelay:0.2];
    [ProgressHUD show:@"Loading..."];
    
    arrayPeoples = [[NSMutableArray alloc] init];
    
    AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    if (appDelegate.shopModelListItems.count != 0 && appDelegate.shopModelList.count == 0)
        [self loadPeoplesFromItems];
    else
        [self loadPeoples];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadPeoples) name:@"reLoadPeoples" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestLike) name:@"requestLike" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestDislike) name:@"requestDislike" object:nil];
}

- (void) showProgress
{
    [ProgressHUD show:@"Loading..."];
}

- (void) loadPeoples
{
    
//    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    if(appDelegate.shopModelList.count == 0)
    {
        MuseSingleton* singleton = [MuseSingleton getInstance];
        LoginModel* logindata = [singleton getLoginData];
        //Get Items
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager setResponseSerializer:[[AFJSONResponseSerializer alloc] init]];
        [manager setRequestSerializer:[[AFJSONRequestSerializer alloc] init]];
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@ %@",@"Bearer",logindata.token] forHTTPHeaderField:@"authorization"];
        
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        NSString * strApiURL = [NSString stringWithFormat:@"%@%@", iMuseBaseUrl, [NSString stringWithFormat:apiGetShopList, logindata.id]];
        //        NSLog(strApiURL);
        
        [manager GET:strApiURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             ShopList *shoplist = [[ShopList alloc] initWithJSONData:responseObject bFlag:0];
             [singleton setShopList:shoplist];
             
             _people = [[NSMutableArray alloc] init];
             _people = [[self defaultPeople] mutableCopy];
             
             Person *tPerson = [[Person alloc] init];
             arrayPeoples = [[NSMutableArray alloc] init];
             for (tPerson in _people)
             {
                 [arrayPeoples addObject:tPerson];
             }
             
             self.frontCardView = [self popPersonViewWithFrame:[self frontCardViewFrame] bFlag:0 isReload:0];
             self.frontCardView.tag = 1;
             
             [self.view addSubview:self.frontCardView];
             
             self.backCardView = [self popPersonViewWithFrame:[self backCardViewFrame] bFlag:1 isReload:0];
             [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
             [self constructNopeButton];
             [self constructLikedButton];
             
             [ProgressHUD dismiss];
             
         }failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"Failure! %@", error.description);
             
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Notification!" message:@"Server Error!" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
             [alertView show];
             
             [ProgressHUD dismiss];
         }];
    }
    else
    {
        _people = appDelegate.shopModelList;
        
        Person *tPerson;
        arrayPeoples = [[NSMutableArray alloc] init];
        for (int i=0; i <_people.count; i++)
        {
            [arrayPeoples addObject:[_people objectAtIndex:i]];
        }
        
        CGRect rectView = [self frontCardViewFrame];
        if (appDelegate.isReload == 1)
            rectView.size.height = rectView.size.height + 54;
        
        self.frontCardView = [self popPersonViewWithFrame:rectView bFlag:0 isReload:appDelegate.isReload];
        self.frontCardView.tag = 1;
        
        [self.view addSubview:self.frontCardView];
        
        self.backCardView = [self popPersonViewWithFrame:[self backCardViewFrame] bFlag:1 isReload:0];
        [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
        [self constructNopeButton];
        [self constructLikedButton];
        
        [ProgressHUD dismiss];
//        [self performSelector:@selector(hideProgress) withObject:nil afterDelay:0.2];
        
    }
}

- (void) hideProgres
{
    [ProgressHUD dismiss];
}
- (void) loadPeoplesFromItems
{
    NSArray *arrayItems = [[NSUserDefaults standardUserDefaults] objectForKey:@"shopModelListItems"];
    NSMutableArray *tempPeoplesArray =[[NSMutableArray alloc] init];
    NSMutableArray *tempProductArray = [[NSMutableArray alloc] init];
    NSMutableArray *countArray = [[NSMutableArray alloc] init];
    
    MuseSingleton* singleton = [MuseSingleton getInstance];
    LoginModel* logindata = [singleton getLoginData];

    for (int i = 0; i < arrayItems.count; i++)
    {
        [tempProductArray addObject:[[ShopProduct alloc] init]];
        [tempPeoplesArray addObject:[[Person alloc] init]];
        
        //Get Items
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager setResponseSerializer:[[AFJSONResponseSerializer alloc] init]];
        [manager setRequestSerializer:[[AFJSONRequestSerializer alloc] init]];
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@ %@",@"Bearer",logindata.token] forHTTPHeaderField:@"authorization"];
        
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        NSString * strApiURL = [NSString stringWithFormat:@"%@%@", iMuseBaseUrl, [NSString stringWithFormat:apiGetProducts, [arrayItems objectAtIndex:i]]];
//        NSLog(strApiURL);
        
        [manager GET:strApiURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             ShopProduct *productData = [[ShopProduct alloc] initWithJSONData:responseObject];
             [tempProductArray setObject:productData atIndexedSubscript:i];
             
             Person *tPerson;
             ShopColor *shopColor;
             
             tPerson = [[Person alloc] init];
             
             shopColor = [productData.color objectAtIndex:0];
             
             [tPerson initWithName: productData.name
                             image: [shopColor.images objectAtIndex:0]
                         productid: productData.id
                          products: productData
                         brandname: [productData.brand name]
                             price: productData.price
                             token: logindata.token];
             
             [tempPeoplesArray setObject:tPerson atIndexedSubscript:i];
             
             [countArray addObject:tPerson];
             
             if (countArray.count == arrayItems.count)
             {
                 ShopList *shopList = [[ShopList alloc] init];
                 NSMutableArray *tempArray = [[NSMutableArray alloc] init];
                 
                 for (int j=0; j<tempProductArray.count; j++)
                 {
                     ShopProduct *tProduct = [tempProductArray objectAtIndex:j];
                     
                     ShopDatas *sData = [[ShopDatas alloc] init];
                     sData.product = tProduct;
                     
                     [tempArray addObject:sData];
                 }
                 
                 shopList.data = (NSArray<ShopDatas> *)tempArray;
                 [singleton setShopList:shopList];
                 
                 AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
                 appDelegate.shopModelList = tempPeoplesArray;
                 
                 [self loadPeoples];
             }

         }failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"Failure! %@", error.description);
             
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Notification!" message:@"Server Error!" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
             [alertView show];
         }];
    }
    
}

- (void) reloadPeoples
{
    //    NSLog(@"%d", (int)self.people.count);
    //    if (arrayPeoples.count == 0)
    //        [self loadPeoples];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - MDCSwipeToChooseDelegate Protocol Methods

- (void)viewDidCancelSwipe:(UIView *)view {
    //    NSLog(@"You couldn't decide on %@.", self.currentPerson.name);
}

- (void)view:(UIView *)view wasChosenWithDirection:(MDCSwipeDirection)direction {
    
    [arrayPeoples removeObjectAtIndex:0];
    
    MuseSingleton *singleton = [MuseSingleton getInstance];
    LoginModel *logindata = [singleton getLoginData];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    //    [manager setResponseSerializer:[[AFJSONResponseSerializer alloc] init]];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@ %@",@"Bearer",logindata.token] forHTTPHeaderField:@"authorization"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:logindata.id forKey:@"_user"];
    
    //Get Product id
    Person *tempPerson = self.frontCardView.person;
    
    [parameters setValue:tempPerson.productid forKey:@"_product"];
    
    if (direction == MDCSwipeDirectionLeft)
        [parameters setValue:@"dislike" forKey:@"status"];
    else
        [parameters setValue:@"like" forKey:@"status"];
    
    [manager POST:[NSString stringWithFormat:@"%@%@", iMuseBaseUrl, apiPostActions] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"Success!");
         
     }failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Failure! %@", error.description);
         
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Notification!" message:@"Server Error!" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
         [alertView show];
     }];
    
    self.frontCardView = self.backCardView;
    self.frontCardView.tag = 1;
//    [self.frontCardView.indicatorView stopAnimating];
//    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
    if ((self.backCardView = [self popPersonViewWithFrame:[self backCardViewFrame] bFlag:1 isReload:0])) {
        
        self.backCardView.alpha = 0.f;
        [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.backCardView.alpha = 1.f;
                         } completion:nil];
        
    }
    
    if (self.people.count == 3)
    {
        MuseSingleton* singleton = [MuseSingleton getInstance];
        LoginModel* logindata = [singleton getLoginData];
        //Get Items
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager setResponseSerializer:[[AFJSONResponseSerializer alloc] init]];
        [manager setRequestSerializer:[[AFJSONRequestSerializer alloc] init]];
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@ %@",@"Bearer",logindata.token] forHTTPHeaderField:@"authorization"];
        
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        NSString * strApiURL = [NSString stringWithFormat:@"%@%@", iMuseBaseUrl, [NSString stringWithFormat:apiGetShopList, logindata.id]];
        //        NSLog(strApiURL);
        
        [manager GET:strApiURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             ShopList *tempShopList = [singleton getShopList];
             NSMutableArray *tempShopDatas = [[NSMutableArray alloc] init];
             NSMutableArray *newShopDatas = [[NSMutableArray alloc] init];
             
             for (ShopDatas *tShopData in tempShopList.data)
             {
                 [tempShopDatas addObject:tShopData];
             }
             
             ShopList *shoplist = [[ShopList alloc] initWithJSONData:responseObject bFlag:0];
             for (ShopDatas *tShopData in shoplist.data)
             {
                 [tempShopDatas addObject:tShopData];
                 [newShopDatas addObject:tShopData];
             }
             tempShopList.data = (NSArray<ShopDatas> *)tempShopDatas;
             [singleton setShopList:tempShopList];
             
             ShopProduct *shopproduct;
             ShopColor *shopcolor;
             ShopDatas *sdata;
             Person *tPerson, *tt;
             
             for (sdata in newShopDatas)
             {
                 tPerson = [[Person alloc] init];
                 shopproduct = sdata.product;
                 shopcolor = [shopproduct.color objectAtIndex:0];
                 
                 tt = [tPerson initWithName: shopproduct.name
                                      image: [shopcolor.images objectAtIndex:0]
                                  productid: shopproduct.id
                                   products: shopproduct
                                  brandname: [shopproduct.brand name]
                                      price: shopproduct.price
                                      token: logindata.token];
                 
                 [_people addObject:tt];
                 [arrayPeoples addObject:tt];
             }
             
         }failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"Failure! %@", error.description);
             
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Notification!" message:@"Server Error!" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
             [alertView show];
             
         }];
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    [super touchesBegan:touches withEvent:event];
    
    if ([touch view] == [self.frontCardView viewWithTag:1])
    {
        CGPoint touchLocation = [touch locationInView:self.frontCardView];
        
        if (touchLocation.x > self.frontCardView.frame.size.width/2-200 &&
            touchLocation.x < self.frontCardView.frame.size.width/2+250 &&
            touchLocation.y > self.frontCardView.frame.size.height/2-200 &&
            touchLocation.y < self.frontCardView.frame.size.height/2+250)
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            DetailViewController *detailViewController = [storyboard instantiateViewControllerWithIdentifier:@"detailView"];
            
            [detailViewController initWithPerson:self.frontCardView.person];
            [self.navigationController pushViewController:detailViewController animated:TRUE];
        }
        
    }
    
}
#pragma mark - Internal Methods

- (void)setFrontCardView:(ChoosePersonView *)frontCardView {
    _frontCardView = frontCardView;
    self.currentPerson = frontCardView.person;
    
}

- (NSArray *)defaultPeople {
    
    NSMutableArray *tempPerson = [[NSMutableArray alloc] init];
    Person *tPerson;
    MuseSingleton* singleton = [MuseSingleton getInstance];
    LoginModel *logindata = [singleton getLoginData];
    ShopList *shoplist = [singleton getShopList];
    ShopProduct *shopproduct;
    ShopColor *shopcolor;
    ShopDatas *sdata;
    
    if (arrayPeoples.count > 0)
    {
        [tempPerson addObject:[arrayPeoples objectAtIndex:0]];
        [tempPerson addObject:[arrayPeoples objectAtIndex:1]];
        [tempPerson addObject:[arrayPeoples objectAtIndex:2]];
    }
    for (sdata in shoplist.data)
    {
        tPerson = [[Person alloc] init];
        shopproduct = sdata.product;
        shopcolor = [shopproduct.color objectAtIndex:0];
        
        [tPerson initWithName: shopproduct.name
                        image: [shopcolor.images objectAtIndex:0]
                    productid: shopproduct.id
                     products: shopproduct
                    brandname: [shopproduct.brand name]
                        price: shopproduct.price
                        token: logindata.token];
        
        [tempPerson addObject:tPerson];
    }
    
    return tempPerson;
}

- (ChoosePersonView *)popPersonViewWithFrame:(CGRect)frame bFlag:(int)bFlag isReload:(int)isReload{
    
    if ([self.people count] == 0)
    {
        return nil;
    }
    
    MDCSwipeToChooseViewOptions *options = [MDCSwipeToChooseViewOptions new];
    options.delegate = self;
    options.threshold = 160.f;
    options.onPan = ^(MDCPanState *state){
        CGRect frame = [self backCardViewFrame];
        self.backCardView.frame = CGRectMake(frame.origin.x,
                                             frame.origin.y - (state.thresholdRatio * 10.f),
                                             CGRectGetWidth(frame),
                                             CGRectGetHeight(frame));
    };
    
    ChoosePersonView *personView = [[ChoosePersonView alloc] initWithFrame:frame
                                                                    person:[self.people objectAtIndex:0]
                                                                   options:options
                                                                  isReload:isReload];
//    [personView.indicatorView startAnimating];
//        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    personView.navController = self.navigationController;
    [self.people removeObjectAtIndex:0];
    
    return personView;
    
}

#pragma mark View Contruction

- (CGRect)frontCardViewFrame {
    CGFloat horizontalPadding = 20.f;
    CGFloat topPadding = 20.f;
    CGFloat bottomPadding = 130.f;
    
    return CGRectMake(horizontalPadding,
                      topPadding,
                      screenSize.size.width - (horizontalPadding * 2),
                      screenSize.size.height - bottomPadding - 64);
}

- (CGRect)backCardViewFrame {
    CGRect frontFrame = [self frontCardViewFrame];
    return CGRectMake(frontFrame.origin.x,
                      frontFrame.origin.y + 10.f,
                      CGRectGetWidth(frontFrame),
                      CGRectGetHeight(frontFrame));
}

- (void)constructNopeButton {
    
    //    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIButton *button = [[UIButton alloc] init];
    
    UIImage *image = [UIImage imageNamed:@"delikeButton.png"];
    button.frame = CGRectMake(ChoosePersonButtonHorizontalPadding,
                              CGRectGetMaxY(self.backCardView.frame) + ChoosePersonButtonVerticalPadding,
                              self.frontCardView.frame.size.width / 6,
                              self.frontCardView.frame.size.width / 6);
    [button setImage:image forState:UIControlStateNormal];
    //    [button setTintColor:[UIColor colorWithRed:247.f/255.f
    //                                         green:91.f/255.f
    //                                          blue:37.f/255.f
    //                                         alpha:1.f]];
    [button addTarget:self
               action:@selector(nopeFrontCardView)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)constructLikedButton {
    
    //    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIButton *button = [[UIButton alloc] init];
    UIImage *image = [UIImage imageNamed:@"likeButton.png"];
    button.frame = CGRectMake(CGRectGetMaxX(self.view.frame) - self.backCardView.frame.size.width / 6 - ChoosePersonButtonHorizontalPadding,
                              CGRectGetMaxY(self.backCardView.frame) + ChoosePersonButtonVerticalPadding,
                              self.backCardView.frame.size.width / 6,
                              self.backCardView.frame.size.width / 6);
    [button setImage:image forState:UIControlStateNormal];
    //    [button setTintColor:[UIColor colorWithRed:29.f/255.f
    //                                         green:245.f/255.f
    //                                          blue:106.f/255.f
    //                                         alpha:1.f]];
    [button addTarget:self
               action:@selector(likeFrontCardView)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

#pragma mark Control Events

- (void) requestLike
{
    NSLog(@"Like");
    [self performSelector:@selector(likeFrontCardView) withObject:self afterDelay:0.5];
}

- (void) requestDislike
{
    NSLog(@"Dislike");
    [self performSelector:@selector(nopeFrontCardView) withObject:self afterDelay:0.5];
}

- (void)nopeFrontCardView {
    [self.frontCardView mdc_swipe:MDCSwipeDirectionLeft];
}

- (void)likeFrontCardView {
    [self.frontCardView mdc_swipe:MDCSwipeDirectionRight];
}

- (void) viewWillDisappear:(BOOL)animated
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    NSMutableArray *tempItemsArray = [[NSMutableArray alloc] init];
    Person *tPerson;
    
    for (tPerson in arrayPeoples)
    {
        [tempArray addObject:tPerson];
        [tempItemsArray addObject:tPerson.productid];
    }
    
    AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    appDelegate.shopModelList = tempArray;
    appDelegate.isReload = 1;
    //    [self.frontCardView.indicatorView stopAnimating];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithArray:tempItemsArray] forKey:@"shopModelListItems"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [ProgressHUD dismiss];
}
@end
