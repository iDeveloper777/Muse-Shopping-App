#import <UIKit/UIKit.h>
#import "ChoosePersonView.h"
#import "ProductsModel.h"

@interface ChoosePersonViewController : UIViewController <MDCSwipeToChooseDelegate>

@property (nonatomic, strong) Person *currentPerson;
@property (nonatomic, strong) ChoosePersonView *frontCardView;
@property (nonatomic, strong) ChoosePersonView *backCardView;
@property (nonatomic, assign) CGRect screenSize;

@property (nonatomic, strong) NSMutableArray *people;
@property (nonatomic, strong) NSMutableArray *arrayPeoples;
@property (nonatomic, strong) NSMutableArray *arrayImages;
@property (nonatomic, strong) NSMutableArray *images;

- (void) loadPeoples;
- (void) reloadPeoples;
- (void) nopeFrontCardView;
- (void) likeFrontCardView;

@end
