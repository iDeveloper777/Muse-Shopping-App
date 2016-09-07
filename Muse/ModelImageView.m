//
//  ModelImageView.m
//  Muse
//
//  Created by Mike Tran on 24/11/14.
//  Copyright (c) 2014 Digi. All rights reserved.
//

#import "ModelImageView.h"
#import <MessageUI/MessageUI.h>

@implementation ModelImageView
@synthesize navController, frameImage;
@synthesize indicatorView;

#pragma mark - Object Lifecycle

- (instancetype) initWithFrame:(CGRect)frame
                  currentProduct:(ShopProduct *)currentProduct
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _currentProduct = currentProduct;
        
        [self showModelImages];
    }
    return self;
}

-  (void) showModelImages
{
    //model image
    ShopColor *shopColor;
    shopColor = [_currentProduct.color objectAtIndex:0];
    
    indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.bounds.size.width/2-10, self.bounds.size.height/2-10, 50, 50)];
    [self addSubview:indicatorView];
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
            NSURL *imgURL = [NSURL URLWithString:[shopColor.images objectAtIndex:0]];
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
                self.image = image;
                
                [self showComponents];
            }else{
                NSLog(@"Image isn't downlaoded. Nothing to display.");
            }
        });
    });
    
}

- (void) showComponents
{
    int imgWidth = self.bounds.size.width;
    int imgHeight = self.bounds.size.height;
    
    //bar Image
    UIImageView *barImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, imgHeight / 4 * 3, imgWidth, imgHeight / 4 - 5)];
    barImageView.image = [UIImage imageNamed:@"subbar.png"];
    barImageView.alpha = 0.7f;
    [self addSubview:barImageView];
    
    //brand Name
    UILabel *brandnameLabel = [[UILabel alloc] initWithFrame: CGRectMake(5, imgHeight / 4 * 3 + 5, 60, 20)];
    brandnameLabel.text = [NSString stringWithFormat:@"%@", _currentProduct.brand.name];
    brandnameLabel.font = [UIFont fontWithName:@"Helvetica Light" size:12.0];
    brandnameLabel.textColor = [UIColor whiteColor];
    [self addSubview:brandnameLabel];
    
    // Name
    UILabel *nameLabel = [[UILabel alloc] initWithFrame: CGRectMake(5, imgHeight / 4 * 3 + 20, 60, 20)];
    nameLabel.text = [NSString stringWithFormat:@"%@", _currentProduct.name];
    nameLabel.font = [UIFont fontWithName:@"Helvetica Light" size:10.0];
    nameLabel.textColor = [UIColor whiteColor];
    [self addSubview:nameLabel];
    
    //Price
    NSString *subString, *strPrice;
    strPrice = _currentProduct.discountPrice;
    if (strPrice != nil && [strPrice isKindOfClass:[NSString class]] && ![strPrice isEqualToString:@"<null>"])
    {
        int strLength = (int)_currentProduct.price.length;
        subString = [_currentProduct.price substringWithRange:NSMakeRange(0,strLength - 4)];
        
        UILabel *priceLabel = [[UILabel alloc] initWithFrame: CGRectMake(imgWidth - 55, imgHeight / 4 * 3 + 8, 50, 20)];
        priceLabel.text = [NSString stringWithFormat:@"Rp %@%@", subString, @"k"];
        priceLabel.font = [UIFont fontWithName:@"Helvetica Light" size:8.0];
        priceLabel.textAlignment = NSTextAlignmentRight;
        priceLabel.textColor = [UIColor whiteColor];
        [self addSubview:priceLabel];
        
        //bar
        UIImageView *barImageView = [[UIImageView alloc] initWithFrame:CGRectMake(imgWidth - 15-strLength*3, imgHeight/4*3 + 18, strLength*3+12, 1)];
        [barImageView setBackgroundColor: [UIColor colorWithRed:132.f/255.f green:2.f/255.f blue:0.f/255.f alpha:0.8f]];
        [self addSubview:barImageView];

        
        strLength = (int)_currentProduct.discountPrice.length;
        subString = [_currentProduct.discountPrice substringWithRange:NSMakeRange(0,strLength - 4)];
        
        UILabel *discountpriceLabel = [[UILabel alloc] initWithFrame: CGRectMake(imgWidth - 55, imgHeight / 4 * 3 + 20, 50, 20)];
        discountpriceLabel.text = [NSString stringWithFormat:@"Rp %@%@", subString, @"k"];
        discountpriceLabel.font = [UIFont fontWithName:@"Helvetica Light" size:12.0];
        discountpriceLabel.textAlignment = NSTextAlignmentRight;
        discountpriceLabel.textColor = [UIColor whiteColor];
        [self addSubview:discountpriceLabel];
        
        //discountRate Image
        UIImageView *discountRateView = [[UIImageView alloc] initWithFrame:CGRectMake(imgWidth/7*5-7, 7, imgWidth/7*2, imgWidth/7*2)];
        discountRateView.image = [UIImage imageNamed:@"discountRate.png"];
        [self addSubview:discountRateView];
        
        UILabel *discountLabel = [[UILabel alloc] initWithFrame: CGRectMake(5, discountRateView.bounds.size.height/2 - 10, discountRateView.bounds.size.width- 10, 10)];
        discountLabel.text = [NSString stringWithFormat:@"DISCOUNT"];
        discountLabel.font = [UIFont fontWithName:@"Helvetica Light" size:4.0];
        discountLabel.textAlignment = NSTextAlignmentCenter;
        discountLabel.textColor = [UIColor whiteColor];
        [discountRateView addSubview:discountLabel];
        
        int discountRate =(int)([_currentProduct.discountPrice floatValue]/[_currentProduct.price floatValue]*100);
        discountLabel = [[UILabel alloc] initWithFrame: CGRectMake(3, discountRateView.bounds.size.height/2 - 8, discountRateView.bounds.size.width- 6, 20)];
        discountLabel.text = [[NSString stringWithFormat:[NSString stringWithFormat:@"%d", discountRate]] stringByAppendingString:@"%"];
        discountLabel.font = [UIFont fontWithName:@"Helvetica Light" size:10.0];
        discountLabel.textAlignment = NSTextAlignmentCenter;
        discountLabel.textColor = [UIColor whiteColor];
        [discountRateView addSubview:discountLabel];
    }
    else
    {
        int strLength = (int)_currentProduct.price.length;
        subString = [_currentProduct.price substringWithRange:NSMakeRange(0,strLength - 4)];
        
        UILabel *priceLabel = [[UILabel alloc] initWithFrame: CGRectMake(imgWidth - 55, imgHeight / 4 * 3 + 20, 50, 20)];
        priceLabel.text = [NSString stringWithFormat:@"Rp %@%@", subString, @"k"];
        priceLabel.font = [UIFont fontWithName:@"Helvetica Light" size:12.0];
        priceLabel.textAlignment = NSTextAlignmentRight;
        priceLabel.textColor = [UIColor whiteColor];
        [self addSubview:priceLabel];
        
    }
    frameImage = [[UIImageView alloc] initWithFrame:CGRectMake(0 , 0, imgWidth, imgHeight)];
    frameImage.image = [UIImage imageNamed:@"frame.png"];
    [self addSubview:frameImage];
    self.frameImage.hidden = YES;
    
    [indicatorView stopAnimating];
}

#pragma mark - Internal Methods
@end
