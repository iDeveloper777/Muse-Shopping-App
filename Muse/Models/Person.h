#import <Foundation/Foundation.h>
#import "ItemsModel.h"
#import "ProductsModel.h"
#import "ShopProduct.h"

@protocol Person

@end

@interface Person : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, assign) NSString *productid;
@property (nonatomic, assign) ShopProduct *products;
@property (nonatomic, assign) NSString *brandname;
@property (nonatomic, assign) NSString *price;
@property (nonatomic, assign) NSString *token;

- (instancetype)initWithName:(NSString *)name
                       image:(NSString *)image
                   productid:(NSString *)productid
                    products:(ShopProduct *) products
                   brandname:(NSString *)brandname
                       price:(NSString *)price
                       token:(NSString *)token;

@end
