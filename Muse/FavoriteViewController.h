#import <UIKit/UIKit.h>

#import "AFHTTPRequestOperationManager.h"
#import "apiconstants.h"
#import "Utils.h"

#import "AFHTTPRequestOperation.h"
#import "MuseSingleton.h"
#import "LoginModel.h"
#import "ProductsModel.h"
#import "RecordsModel.h"
#import "BrandModel.h"
#import "ItemsModel.h"

#import "ModelImageView.h"
#import "CheckboxView.h"

@interface FavoriteViewController : UIViewController
@property (nonatomic, strong) ProductsModel *currentProducts;

@property (nonatomic, strong) UIButton *recycleBtn;
@property (nonatomic, strong) UIButton *filterBtn;
@end
