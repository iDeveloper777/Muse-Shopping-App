#import "PushedVC.h"
#import "AMSlideMenuMainViewController.h"
#import "UIViewController+AMSlideMenu.h"

@interface PushedVC ()

@end

@implementation PushedVC

/*----------------------------------------------------*/
#pragma mark - Lifecycle -
/*----------------------------------------------------*/

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.navigationController.viewControllers.count > 1)
    {
        [self disableSlidePanGestureForLeftMenu];
    }
    
    AMSlideMenuMainViewController *mainVC = [AMSlideMenuMainViewController getInstanceForVC:self];
    if (mainVC.rightMenu)
    {
        [self addRightMenuButton];
    }
}

/*----------------------------------------------------*/
#pragma mark - IBActions -
/*----------------------------------------------------*/

- (IBAction)exitToRoot:(id)sender
{
    AMSlideMenuMainViewController *mainVC = [AMSlideMenuMainViewController getInstanceForVC:self];
    
    [mainVC.navigationController popToRootViewControllerAnimated:YES];
}

@end
