//
//  CheckboxView.m
//  Muse
//
//  Created by Mike Tran on 25/11/14.
//  Copyright (c) 2014 Digi. All rights reserved.
//

//
//  ModelImageView.m
//  Muse
//
//  Created by Mike Tran on 24/11/14.
//  Copyright (c) 2014 Digi. All rights reserved.
//

#import "CheckboxView.h"

@implementation CheckboxView
@synthesize navController, checkboxImage01, checkboxImage02, bStatus;

#pragma mark - Object Lifecycle

- (instancetype) initWithFrame:(CGRect)frame
                currentProduct:(ShopProduct *)currentProduct
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _currentProduct = currentProduct;
        
        self.bStatus = FALSE;
        [self showComponents];
    }
    return self;
}

-  (void) showComponents
{
    int imgWidth = self.bounds.size.width;
    int imgHeight = self.bounds.size.height;
    
    //checkbox01 image
    checkboxImage01 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2, imgWidth/5*4, imgHeight -2)];
    checkboxImage01.image = [UIImage imageNamed:@"checkbox01.png"];
    [self addSubview:checkboxImage01];
    
    //brand Name
    checkboxImage02 = [[UIImageView alloc] initWithFrame:CGRectMake(2 , 0, imgWidth- 2, imgHeight)];
    checkboxImage02.image = [UIImage imageNamed:@"checkbox02.png"];
    [self addSubview:checkboxImage02];
    self.checkboxImage02.hidden = YES;
    
}

#pragma mark - Internal Methods
@end
