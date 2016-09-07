//
//  DetailViewController.m
//  Muse
//
//  Created by Mike Tran on 21/11/14.
//  Copyright (c) 2014 Digi. All rights reserved.
//

#import "DetailViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "apiconstants.h"

#import "MuseSingleton.h"
#import "LoginModel.h"
#import "ItemsModel.h"
#import "RecordsModel.h"
#import "ShopProduct.h"
#import "BuyNowViewController.h"
#import "ChoosePersonViewController.h"

@interface DetailViewController ()<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UIPageControl *_pgControl;
    NSMutableArray *_images;
    UIView *_bgImageView;
    
    UIImageView *_barImageView;
    UILabel *_nameLabel;
    UILabel *_brandnameLabel;
    UILabel *_priceLabel;
    UILabel *_discountpriceLabel;
    UIButton *_buyButton;
    UIImageView *_colorImageView;
    UITextView *_descTextView;;
    
    UIScrollView *_bgScrollView;
   
    int itemID;
    int isFavorite;
    NSMutableArray *arrayImageViews;
}

@end

@implementation DetailViewController
@synthesize indicatorView;
@synthesize likeBtn, dislikeBtn;
@synthesize currentPerson, currentData;
@synthesize screenSize;

 - (instancetype) initWithPerson:(Person *)person
{
    self = [super init];
    if (self)
    {
        currentPerson = person;
        
        //set currentModel
        MuseSingleton *singleton = [MuseSingleton getInstance];
        ShopList *shopList;
        ShopDatas *sData;

        shopList = [singleton getShopList];
        
        for (sData in shopList.data)
        {
            if (currentPerson.productid == sData.product.id)
            {
                self.currentData = sData.product;
            }
        }
        itemID = 0;
    }
    return self;
}

- (instancetype) initWithData:(ShopProduct *) currentProducts
{
    self = [super init];
    if (self)
    {
        self.currentData = [[ShopProduct alloc] init];
        self.currentData = currentProducts;
        
        self.currentPerson = [[Person alloc] init];
        self.currentPerson.name = self.currentData.name;
        self.currentPerson.productid = self.currentData.id;
        isFavorite = 1;
        
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
 
    screenSize = [[UIScreen mainScreen] bounds];
    
    arrayImageViews = [[NSMutableArray alloc] init];
    
    [self.view setBackgroundColor: [UIColor colorWithRed:239.f/255.f
                                                   green:239.f/255.f
                                                    blue:239.f/255.f
                                                   alpha:1.f]];
    UILabel *strLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    strLabel.font = [UIFont boldSystemFontOfSize:20.0];
    strLabel.textAlignment = NSTextAlignmentCenter;
    strLabel.textColor = [UIColor redColor];
    strLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    
//    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [self layoutNavigationBar];
    
    [self layoutComponents];
}

- (void) layoutNavigationBar
{
    if (isFavorite != 1)
    {
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(20.0f, 30.0f, 80.0f, 44.0f)];
    
        likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        likeBtn.frame = CGRectMake( 41, 0, 44, 44);
        [likeBtn addTarget:self action:@selector(pressLikeButton) forControlEvents:UIControlEventTouchUpInside];
        [likeBtn setImage:[UIImage imageNamed:@"like01.png"] forState:UIControlStateNormal];
        [likeBtn setImage:[UIImage imageNamed:@"like02.png"] forState:UIControlStateHighlighted];
        [rightView addSubview:likeBtn];
    
        dislikeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        dislikeBtn.frame = CGRectMake( 0, 0, 44, 44);
        [dislikeBtn addTarget:self action:@selector(pressDisLikeButton) forControlEvents:UIControlEventTouchUpInside];
        [dislikeBtn setImage:[UIImage imageNamed:@"dislike01.png"] forState:UIControlStateNormal];
        [dislikeBtn setImage:[UIImage imageNamed:@"dislike02.png"] forState:UIControlStateHighlighted];
        [rightView addSubview:dislikeBtn];
        //    [filterBtn setImage:[UIImage imageNamed:@"recycle02.png"] forState:UIControlEventTouchUpOutside];
        
        UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
        [rightButtonItem setTarget:self];
        
        self.navigationItem.rightBarButtonItem = rightButtonItem;
    }
    
    UIImage *myIcon = [Utils imageWithImage:[UIImage imageNamed:@"logo.png"] scaledToSize:CGSizeMake(76, 17)];
    UIImageView *titleView = [[UIImageView alloc] initWithImage:myIcon];
    self.navigationItem.titleView = titleView;

    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"< Back" style:UIBarButtonItemStyleBordered target:self action:@selector(onBackBtnPressed)];
    [leftButtonItem setWidth:30];
    [leftButtonItem setTintColor:[UIColor colorWithRed:110.f/255.f green:110.f/255.f blue:110.f/255.f alpha:1.f]];
    [leftButtonItem setAccessibilityFrame:CGRectMake(10, 10, 30, 30)];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
}

- (void) onBackBtnPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) pressLikeButton
{
    [likeBtn setImage:[UIImage imageNamed:@"like02.png"] forState:UIControlStateNormal];
    [dislikeBtn setImage:[UIImage imageNamed:@"dislike01.png"] forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"requestLike" object:nil];

    [self.navigationController popViewControllerAnimated:YES];
}

- (void) pressDisLikeButton
{
    [likeBtn setImage:[UIImage imageNamed:@"like01.png"] forState:UIControlStateNormal];
    [dislikeBtn setImage:[UIImage imageNamed:@"dislike02.png"] forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"requestDislike" object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) layoutComponents
{
    ShopColor *shopColor;
    shopColor = [self.currentData.color objectAtIndex:0];
    
    CGFloat topPadding = 15.f;
    CGFloat leftPadding = 15.f;
    
    CGPoint bgSPoint = CGPointMake(screenSize.size.width - leftPadding * 2, screenSize.size.height - 64 - topPadding *2);
//    NSLog(@"%d", (int)screenSize.size.height);
//    NSLog(@"%d", (int)self.view.bounds.size.height);
    _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(leftPadding, topPadding, bgSPoint.x, bgSPoint.y)];
//    [_bgScrollView setBackgroundColor:[UIColor colorWithRed:255.f/255.f
//                                                    green:80.f/255.f
//                                                     blue:180.f/255.f
//                                                    alpha:0.5f]];
    [_bgScrollView setBackgroundColor:[UIColor colorWithRed:255.f/255.f green:255.f/255.f blue:255.f/255.f alpha:1.f]];
    _bgScrollView.contentSize = CGSizeMake(bgSPoint.x, (screenSize.size.height-64) / 3 * 4);
    _bgScrollView.pagingEnabled = true;
    _bgScrollView.bounces = false;
    _bgScrollView.delegate = self;
    _bgScrollView.layer.borderWidth = 0.5f;
    _bgScrollView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    _bgScrollView.showsHorizontalScrollIndicator = false;
    _bgScrollView.layer.cornerRadius = 2;
    [self.view addSubview:_bgScrollView];
    
    _bgImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _bgScrollView.contentSize.width, _bgScrollView.contentSize.height)];
    _bgImageView.backgroundColor = [UIColor whiteColor];
    [_bgScrollView addSubview:_bgImageView];
    
    CGRect svrect_ = CGRectZero;
    svrect_.size.height = _bgImageView.bounds.size.height / 2 - 10;
    svrect_.size.width = _bgImageView.bounds.size.width - 20;
    CGPoint svcenter_ = CGPointZero;
    svcenter_.x = _bgImageView.bounds.size.width / 2;
    svcenter_.y = svrect_.size.height / 2 + 5;
    CGSize svconsize = CGSizeZero;
    svconsize.height = svrect_.size.height;
    svconsize.width = svrect_.size.width * shopColor.images.count;
    
    CGPoint pgconcenter_ = CGPointZero;
    pgconcenter_.x = _bgImageView.center.x;
    pgconcenter_.y = svcenter_.y + (svrect_.size.height / 2) + 15;
    
    //        UIImage *fill = createImageFromUIColor([UIColor colorWithWhite:0.9 alpha:1]);
    
    //Views
    
    _scrollView = [[UIScrollView alloc] initWithFrame:svrect_];
    _scrollView.center = svcenter_;
    [_scrollView setBackgroundColor:[UIColor colorWithRed:255.f/255.f green:255.f/255.f blue:255.f/255.f alpha:1.f]];
    _scrollView.contentSize = svconsize;
    _scrollView.pagingEnabled = true;
    _scrollView.bounces = false;
    _scrollView.delegate = self;
    _scrollView.layer.borderWidth = 0.5f;
    _scrollView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    _scrollView.showsHorizontalScrollIndicator = false;
    _scrollView.layer.cornerRadius = 2;
    [_scrollView setScrollEnabled:FALSE];
    [_bgImageView addSubview:_scrollView];
    
    _pgControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, _scrollView.bounds.size.width, _scrollView.bounds.size.height)];
    _pgControl.pageIndicatorTintColor = [UIColor colorWithWhite:0.6 alpha:1];
    _pgControl.currentPageIndicatorTintColor = [UIColor colorWithRed:255.f/255.f green:30.f/255.f  blue:150.f/255.f alpha:1.f];
    _pgControl.numberOfPages = shopColor.images.count;
    _pgControl.currentPage = 0;
    [_pgControl sizeToFit];
    [_pgControl sizeForNumberOfPages:10];
    _pgControl.center = pgconcenter_;
    [_bgImageView addSubview:_pgControl];
    
    //bar
    _barImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,
                                                                  pgconcenter_.y + 12,
                                                                  self.view.bounds.size.width - leftPadding * 2 -20,
                                                                  1)];
    
    [_barImageView setBackgroundColor: [UIColor colorWithRed:239.f/255.f  green:239.f/255.f blue:239.f/255.f alpha:1.f]];
    [_bgImageView addSubview:_barImageView];
    
    //brand name
    _brandnameLabel = [[UILabel alloc] initWithFrame: CGRectMake(15, pgconcenter_.y + 25, self.view.bounds.size.width /2, 30)];
    _brandnameLabel.text = [NSString stringWithFormat:@"%@", currentData.brand.name];
    _brandnameLabel.font = [UIFont fontWithName:@"Helvetica Light" size:20.0];
    _brandnameLabel.textColor = [UIColor colorWithRed:110.f/255.f green:110.f/255.f blue:110.f/255.f alpha:1.f];
    [_bgImageView addSubview:_brandnameLabel];

    
    
   //price
    NSString *subString, *strPrice;
    //discountprice
    strPrice = currentData.discountPrice;
    if (strPrice != nil && [strPrice isKindOfClass:[NSString class]] && ![strPrice isEqualToString:@"<null>"])
    {
        
        int strLength = (int)strPrice.length;
        subString = [strPrice substringWithRange:NSMakeRange(0,strLength - 4)];
        
        //price name
        _discountpriceLabel = [[UILabel alloc] initWithFrame: CGRectMake(_bgImageView.bounds.size.width -80 -15-10, pgconcenter_.y + 60, 80, 20)];
        _discountpriceLabel.text = [NSString stringWithFormat:@"Rp %@%@", subString, @"k"];
        _discountpriceLabel.font = [UIFont fontWithName:@"Helvetica Light" size:18.0];
        _discountpriceLabel.textAlignment = UITextAlignmentRight;
        _discountpriceLabel.textColor = [UIColor colorWithRed:230.f/255.f green:56.f/255.f blue:132.f/255.f alpha:1.f];
        [_bgImageView addSubview:_discountpriceLabel];
        
        strPrice = currentData.price;
        if (strPrice != nil && [strPrice isKindOfClass:[NSString class]] && ![strPrice isEqualToString:@"<null>"])
        {
            
            int strLength = (int)strPrice.length;
            subString = [strPrice substringWithRange:NSMakeRange(0,strLength - 4)];
            
            //price name
            _priceLabel = [[UILabel alloc] initWithFrame: CGRectMake(_bgImageView.bounds.size.width -80 -15-10, pgconcenter_.y + 25, 80, 20)];
            _priceLabel.text = [NSString stringWithFormat:@"Rp %@%@", subString, @"k"];
            _priceLabel.font = [UIFont fontWithName:@"Helvetica Light" size:18.0];
            _priceLabel.textAlignment = UITextAlignmentRight;
            _priceLabel.textColor = [UIColor colorWithRed:110.f/255.f green:110.f/255.f blue:110.f/255.f alpha:1.f];
            [_bgImageView addSubview:_priceLabel];
            
            //bar
            _barImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_bgImageView.bounds.size.width -15-8-strLength*10, pgconcenter_.y + 35, strLength * 10, 1)];
            
            [_barImageView setBackgroundColor: [UIColor colorWithRed:230.f/255.f green:56.f/255.f blue:132.f/255.f alpha:1.f]];
            [_bgImageView addSubview:_barImageView];
        }
        
        //buyButton2
        _buyButton = [[UIButton alloc] initWithFrame:CGRectMake(_bgImageView.bounds.size.width -100-15, pgconcenter_.y + 100, 100, 28)];
        [_buyButton setBackgroundImage:[UIImage imageNamed:@"buyButton02.png" ] forState: UIControlStateNormal];
        [_buyButton addTarget:self action:@selector(pressBuyButton) forControlEvents:UIControlEventTouchUpInside];
        [_bgImageView addSubview:_buyButton];
    }
    else
    {
        strPrice = currentData.price;
        int strLength = (int)strPrice.length;
        subString = [strPrice substringWithRange:NSMakeRange(0,strLength - 4)];
        
        //price name
        _priceLabel = [[UILabel alloc] initWithFrame: CGRectMake(_bgImageView.bounds.size.width -80 -15-10, pgconcenter_.y + 25, 80, 20)];
        _priceLabel.text = [NSString stringWithFormat:@"Rp %@%@", subString, @"k"];
        _priceLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18.0];
        _priceLabel.textAlignment = UITextAlignmentRight;
        _priceLabel.textColor = [UIColor colorWithRed:110.f/255.f green:110.f/255.f blue:110.f/255.f alpha:1.f];
        [_bgImageView addSubview:_priceLabel];
        
        //buyButton2
        _buyButton = [[UIButton alloc] initWithFrame:CGRectMake(_bgImageView.bounds.size.width -100-15, pgconcenter_.y + 60, 100, 28)];
        [_buyButton setBackgroundImage:[UIImage imageNamed:@"buyButton02.png" ] forState: UIControlStateNormal];
        [_buyButton addTarget:self action:@selector(pressBuyButton) forControlEvents:UIControlEventTouchUpInside];
        [_bgImageView addSubview:_buyButton];
    }

    //name
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, pgconcenter_.y + 60, self.view.bounds.size.width/2, 30)];
    _nameLabel.text = [NSString stringWithFormat:@"%@", self.currentData.name];
    _nameLabel.font = [UIFont fontWithName:@"Helvetica Light" size:16.0];
    _nameLabel.textColor = [UIColor colorWithRed:110.f/255.f green:110.f/255.f blue:110.f/255.f alpha:1.f];
    [_bgImageView addSubview:_nameLabel];
    
    //color
    if ([shopColor.hex isKindOfClass:[NSString class]])
    {
        _colorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(23, pgconcenter_.y +100-2, 27, 27)];
        [_colorImageView setBackgroundColor:[UIColor whiteColor]];
        [_colorImageView.layer setBorderColor:[[UIColor colorWithRed:110.f/255.f green:110.f/255.f blue:110.f/255.f alpha:1.f] CGColor]];
        [_colorImageView.layer setBorderWidth:0.7f];
        [_bgImageView addSubview:_colorImageView];
        
        _colorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(25, pgconcenter_.y + 100, 23, 23)];
        [_colorImageView setBackgroundColor:[self setColorWithHex:shopColor.hex alpha:1]];
        [_bgImageView addSubview:_colorImageView];
    }
    
    //Descreption
    NSString *strTemp;
    if ([self.currentData.source isKindOfClass:[NSString class]])
        strTemp = [NSString stringWithFormat:@"%@<br><br><b>%@</b>", self.currentData.desc, self.currentData.source];
    else
        strTemp = [NSString stringWithFormat:@"%@", self.currentData.desc];
    
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[strTemp dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];

    strPrice = currentData.discountPrice;
    int tempHeight;
    if ([shopColor.hex isKindOfClass:[NSString class]])
    {
        tempHeight = _colorImageView.frame.origin.y + _colorImageView.frame.size.height + 15;
        _descTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, tempHeight, self.view.bounds.size.width - 60 , _bgImageView.frame.size.height- tempHeight-10)];
    }else if (strPrice != nil && [strPrice isKindOfClass:[NSString class]] && ![strPrice isEqualToString:@"<null>"])
    {
        tempHeight = _buyButton.frame.origin.y + _buyButton.frame.size.height + 15;
        _descTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, tempHeight, self.view.bounds.size.width - 60 , _bgImageView.frame.size.height- tempHeight-10)];
    }else
    {
        tempHeight = _buyButton.frame.origin.y + _buyButton.frame.size.height + 15;
        _descTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, _buyButton.frame.origin.y + _buyButton.frame.size.height + 15, self.view.bounds.size.width - 60 , _bgImageView.frame.size.height- tempHeight-10)];
    }
    
    _descTextView.attributedText = attrStr;
    _descTextView.backgroundColor = [UIColor whiteColor];
    _descTextView.textColor = [UIColor colorWithRed:110.f/255.f green:110.f/255.f blue:110.f/255.f alpha:1.5f];
    _descTextView.font = [UIFont fontWithName:@"Helvetica Light" size:15.0];
    _descTextView.scrollEnabled = NO;
    _descTextView.editable = NO;
    _descTextView.selectedRange = NSMakeRange(0, 0);
    _descTextView.tintColor = [UIColor colorWithRed:110.f/255.f green:110.f/255.f blue:110.f/255.f alpha:1.f];
    _descTextView.tag = 1;
    [_descTextView sizeToFit];
    
    [_bgImageView addSubview:_descTextView];
    
    _bgScrollView.contentSize = CGSizeMake(bgSPoint.x, tempHeight + _descTextView.frame.size.height + 10);
    _bgImageView.frame = CGRectMake(0, 0, _bgScrollView.contentSize.width, _bgScrollView.contentSize.height);
    
    //image Loading
    for (int i = 0; i< shopColor.images.count; i++)
    {
        [self loadImages:i];
    }
    [_scrollView setScrollEnabled:TRUE];
//    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
//    [self performSelector:@selector(loadImages) withObject:self afterDelay:0.01];
}

//Load Images Function
- (void) loadImages:(int) imageIndex
{
    ShopColor *shopColor;
    shopColor = [self.currentData.color objectAtIndex:0];
    
    CGRect ivrect_ = CGRectMake(_scrollView.bounds.size.width * imageIndex + 25,
                                0,
                                _scrollView.bounds.size.width - 50,
                                _scrollView.bounds.size.height);
    UIImageView *iv_ = [[UIImageView alloc] initWithFrame:ivrect_];
    iv_.contentMode = UIViewContentModeScaleAspectFill;
    iv_.clipsToBounds = true;
    
    indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(_scrollView.bounds.size.width * imageIndex + _scrollView.bounds.size.width/2-10, _scrollView.bounds.size.height/2- 10, 200, 200)];
    [_scrollView addSubview:indicatorView];
    [indicatorView sizeToFit];
    indicatorView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    indicatorView.hidesWhenStopped  = YES;
    indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    indicatorView.color = [UIColor colorWithRed:255.f/255.f green:80.f/255.f blue:180.f/255.f alpha:1.0f];
    [indicatorView startAnimating];
    
    //block
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(concurrentQueue, ^{
        __block UIImage *image = nil;
        
        dispatch_sync(concurrentQueue, ^{
            NSURL *imgURL = [NSURL URLWithString:[shopColor.images objectAtIndex:imageIndex]];
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:imgURL];
            NSError *downloadError = nil;
            NSData *imgData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:&downloadError];
            
            if (downloadError == nil && imgData != nil){
                image = [UIImage imageWithData:imgData];
            }else if (downloadError != nil){
                NSLog(@"Error happend = %@", downloadError);
            }else{
                NSLog(@"No data could get download from the URL.");
            }
        });
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (image != nil)
            {
                iv_.image = image;
                iv_.clipsToBounds = YES;
                [arrayImageViews addObject:iv_];
                
                [indicatorView stopAnimating];
                [_scrollView addSubview:iv_];
            }else{
                NSLog(@"Image isn't downlaoded. Nothing to display.");
//                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            }
        });
    });
    
}

// Press BuyButton
- (void) pressBuyButton
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BuyNowViewController *buyViewController = [storyboard instantiateViewControllerWithIdentifier:@"buyView"];
    
//    [buyViewController initWithPerson:self.currentPerson];
    [buyViewController initWithData:self.currentData];
    [self.navigationController pushViewController:buyViewController animated:TRUE];
}

- (UIColor*) setColorWithHex:(NSString*)hex alpha:(CGFloat)alpha {
    
    if (7 != [hex length])
        return [UIColor whiteColor];
    
    if ('#' != [hex characterAtIndex:0])
        return [UIColor whiteColor];
    
    NSString *redHex = [NSString stringWithFormat:@"0x%@", [hex substringWithRange:NSMakeRange(1, 2)]];
    NSString *greenHex = [NSString stringWithFormat:@"0x%@", [hex substringWithRange:NSMakeRange(3, 2)]];
    NSString *blueHex = [NSString stringWithFormat:@"0x%@", [hex substringWithRange:NSMakeRange(5, 2)]];
    
    unsigned redInt = 0;
    NSScanner *rScanner = [NSScanner scannerWithString:redHex];
    [rScanner scanHexInt:&redInt];
    
    unsigned greenInt = 0;
    NSScanner *gScanner = [NSScanner scannerWithString:greenHex];
    [gScanner scanHexInt:&greenInt];
    
    unsigned blueInt = 0;
    NSScanner *bScanner = [NSScanner scannerWithString:blueHex];
    [bScanner scanHexInt:&blueInt];
    
    return [UIColor colorWithRed:(redInt/255.0) green:(greenInt/255.0) blue:(blueInt/255.0) alpha:alpha];
}


- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page_ = (int)round(scrollView.contentOffset.x / scrollView.frame.size.width);
    
    _pgControl.currentPage = page_;
}

- (void) viewDidAppear:(BOOL)animated
{
//    NSLog(@"Exit Detail!");
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    [super touchesBegan:touches withEvent:event];
    
    if ([touch view] == [_descTextView viewWithTag:1])
    {
        NSLog(@"Sdfa");
    }
    
}

@end
