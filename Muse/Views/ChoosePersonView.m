#import "ChoosePersonView.h"
#import "ImageLabelView.h"
#import "Person.h"

#import "apiconstants.h"
#import "MuseSingleton.h"
#import "LoginModel.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPRequestOperation.h"
#import "DetailViewController.h"
#import "BuyNowViewController.h"
#import "ChoosePersonViewController.h"

#import "BuyData.h"


static const CGFloat ChoosePersonViewImageLabelWidth = 42.f;

@interface ChoosePersonView ()
{
    int nDif;
}

@property (nonatomic, strong) UIView *indView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *brandnameLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIButton *buyButton;
@property (nonatomic, strong) UIButton *infoButton;


@end


@implementation ChoosePersonView
@synthesize navController;
@synthesize indicatorView;

#pragma mark - Object Lifecycle

- (instancetype)initWithFrame:(CGRect)frame
                       person:(Person *)person
                      options:(MDCSwipeToChooseViewOptions *)options
                     isReload:(int)isReload{
    self = [super initWithFrame:frame options:options isReload:isReload];
    if (self) {
        _person = person;
        
        // make the image from url.
        //        NSURL *imgURL = [NSURL URLWithString:_person.image];
        //        NSData *imgData = [NSData dataWithContentsOfURL:imgURL];
        //        self.imageView.image = [UIImage imageWithData:imgData];
        
        indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.bounds.size.width /2-10, self.bounds.size.height/2-10, 200, 200)];
        [self addSubview:indicatorView];
        [indicatorView sizeToFit];
        indicatorView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
        indicatorView.hidesWhenStopped  = YES;
        indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        indicatorView.color = [UIColor colorWithRed:255.f/255.f green:80.f/255.f blue:180.f/255.f alpha:1.0f];
        [indicatorView startAnimating];
        
        if (isReload == 1)
            nDif = 54;
        else
            nDif = 0;
        
        //blcok
        [self loadModelImage];
        //        [self constructInformationView];        
    }
    return self;
}

#pragma mark - Internal Methods
// Show Name
- (void) loadModelImage
{
    //block
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(concurrentQueue, ^{
        __block UIImage *image = nil;
        
        dispatch_sync(concurrentQueue, ^{
            NSURL *imgURL = [NSURL URLWithString:_person.image];
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
                
                self.imageView.image = image;
                [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
                
                [indicatorView stopAnimating];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadPeoples" object:nil];
                
            }else{
                NSLog(@"Image isn't downlaoded. Nothing to display.");
            }
        });
    });
    
    self.barImageView.image = [UIImage imageNamed:@"bar.png"];
    
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleBottomMargin;
    self.imageView.autoresizingMask = self.autoresizingMask;
    
    [self constructNameLabel];
    [self constructBrandNameLabel];
    [self constructPriceLabel];
    [self constructBuyButton];
    [self constructInfoButton];

}

- (void)constructNameLabel {
    CGFloat leftPadding = 20.f;
    CGFloat topPadding = 22.f;
    
    CGRect frame = CGRectMake(leftPadding,
                              (self.imageView.frame.size.height - nDif) / 12 * 11,
                              floorf(CGRectGetWidth(self.imageView.frame)/2),
                              topPadding);
    _nameLabel = [[UILabel alloc] initWithFrame:frame];
    _nameLabel.textAlignment = UITextAlignmentLeft;
    _nameLabel.text = [NSString stringWithFormat:@"%@", _person.name];
    _nameLabel.font = [UIFont fontWithName:@"Helvetica Light" size:19.0 ];
    _nameLabel.textColor = [UIColor colorWithRed:255.f/255.f
                                           green:255.f/255.f
                                            blue:255.f/255.f
                                           alpha:1.f];
    
    
    [self addSubview:_nameLabel];
    [self bringSubviewToFront:_nameLabel];
    
}
//Show Brand Name
- (void)constructBrandNameLabel {
    CGFloat leftPadding = 20.f;
    CGFloat topPadding = 24.f;
    
    CGRect frame = CGRectMake(leftPadding,
                              (self.imageView.frame.size.height - nDif) / 12 * 9.8,
                              floorf(CGRectGetWidth(self.imageView.frame)/2),
                              topPadding);
    _brandnameLabel = [[UILabel alloc] initWithFrame:frame];
    _brandnameLabel.text = [NSString stringWithFormat:@"%@", _person.brandname];
    _brandnameLabel.font = [UIFont fontWithName:@"Helvetica Light" size:21.0];
    _brandnameLabel.textColor = [UIColor colorWithRed:255.f/255.f
                                                green:255.f/255.f
                                                 blue:255.f/255.f
                                                alpha:1.f];
    
    
    [self addSubview:_brandnameLabel];
    [self bringSubviewToFront:_brandnameLabel];
    
}

//Show Price
- (void)constructPriceLabel {
    //    CGFloat leftPadding = 20.f;
    CGFloat topPadding = 28.f;
    
    CGRect frame = CGRectMake(CGRectGetWidth(self.imageView.frame) / 6 * 4,
                              (self.imageView.frame.size.height - nDif) / 12 * 9.8,
                              floorf(CGRectGetWidth(self.imageView.frame)/3 - 10),
                              topPadding);
    
    _priceLabel = [[UILabel alloc] initWithFrame:frame];
    
    //price change (without end 4 digits)
    
    NSString *subString, *strPrice;
    
    if (_person.products.discountPrice != nil && [_person.products.discountPrice isKindOfClass:[NSString class]] && ![_person.products.discountPrice isEqualToString:@"<null>"])
        strPrice = _person.products.discountPrice;
    else
        strPrice = _person.price;
    
    int strLength = (int)strPrice.length;
    subString = [strPrice substringWithRange:NSMakeRange(0,strLength - 4)];
    
    
    _priceLabel.text = [NSString stringWithFormat:@"Rp %@%@", subString, @"k"];
    _priceLabel.font = [UIFont fontWithName:@"Helvetica Light" size:23.0];
    _priceLabel.textAlignment = UITextAlignmentCenter;
    _priceLabel.textColor = [UIColor colorWithRed:255.f/255.f
                                            green:255.f/255.f
                                             blue:255.f/255.f
                                            alpha:1.f];
    [self addSubview:_priceLabel];
    [self bringSubviewToFront:_priceLabel];
    
}

//Show BuyButton
- (void)constructBuyButton
{
    CGRect frame = CGRectMake(CGRectGetWidth(self.imageView.frame) / 6 * 4,
                              (self.imageView.frame.size.height - nDif) / 12 * 11 - 4,
                              floorf(CGRectGetWidth(self.imageView.frame)/3 - 10),
                              floorf(CGRectGetHeight(self.imageView.frame)/15));
    
    _buyButton = [[UIButton alloc] initWithFrame:frame];
    [_buyButton setBackgroundImage:[UIImage imageNamed:@"buyButton.png" ] forState: UIControlStateNormal];
    
    [_buyButton addTarget:self action:@selector(pressBuyButton) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_buyButton];
    [self bringSubviewToFront:_buyButton];
}

//Show InfoButton
- (void)constructInfoButton
{
    CGRect frame = CGRectMake(CGRectGetWidth(self.imageView.frame) - 20 * 2,
                              15,
                              floorf(CGRectGetWidth(self.imageView.frame)/12),
                              floorf(CGRectGetWidth(self.imageView.frame)/12));
    
    _infoButton = [[UIButton alloc] initWithFrame:frame];
    [_infoButton setBackgroundImage:[UIImage imageNamed:@"infoButton.png" ] forState: UIControlStateNormal];
    
    [_infoButton addTarget:self action:@selector(pressInfoButton) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_infoButton];
    [self bringSubviewToFront:_infoButton];
}

// Press BuyButton
- (void) pressBuyButton
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BuyNowViewController *buyViewController = [storyboard instantiateViewControllerWithIdentifier:@"buyView"];
    
    [buyViewController initWithPerson:self.person];
    [navController pushViewController:buyViewController animated:TRUE];
}

- (void) pressInfoButton
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailViewController *detailViewController = [storyboard instantiateViewControllerWithIdentifier:@"detailView"];
    
    [detailViewController initWithPerson:self.person];
    [navController pushViewController:detailViewController animated:TRUE];
}


//- (ImageLabelView *)buildImageLabelViewLeftOf:(CGFloat)x image:(UIImage *)image text:(NSString *)text {
//    CGRect frame = CGRectMake(x - ChoosePersonViewImageLabelWidth,
//                              0,
//                              ChoosePersonViewImageLabelWidth,
//                              CGRectGetHeight(_informationView.bounds));
//    ImageLabelView *view = [[ImageLabelView alloc] initWithFrame:frame
//                                                           image:image
//                                                            text:text];
//    view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
//    return view;
//}

@end
