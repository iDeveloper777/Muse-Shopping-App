#import <UIKit/UIKit.h>
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>

@class Person;

@interface ChoosePersonView : MDCSwipeToChooseView

@property (nonatomic, strong) UINavigationController  *navController;
@property (nonatomic, strong, readonly) Person *person;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

- (instancetype)initWithFrame:(CGRect)frame
                       person:(Person *)person
                      options:(MDCSwipeToChooseViewOptions *)options
                     isReload:(int)isReload;

@end
