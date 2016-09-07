#import "Person.h"

@implementation Person

#pragma mark - Object Lifecycle

- (instancetype)initWithName:(NSString *)name
                       image:(NSString *)image
                   productid:(NSString *)productid
                    products:(ShopProduct *)products
                   brandname:(NSString *)brandname
                       price:(NSString *)price
                       token:(NSString *)token
{
    self = [super init];
    if (self)
    {
        _name = name;
        _image = image;
        _productid = productid;
        _products = products;
        _brandname = brandname;
        _price = price;
        _token = token;
    }
    return self;
}

@end
