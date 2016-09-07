#import "LeftMenuVC.h"
#import "MainVC.h"
#import "UIViewController+AMSlideMenu.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"

@interface LeftMenuVC()

@property (strong, nonatomic) UITableView *myTableView;

@end

@implementation LeftMenuVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 && ![UIApplication sharedApplication].isStatusBarHidden)
    {
        self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    }
    
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        [self setFixedStatusBar];
    }
}

- (void)setFixedStatusBar
{
    self.myTableView = self.tableView;
    
    
    self.view = [[UIView alloc] initWithFrame:self.view.bounds];
    self.view.backgroundColor = self.myTableView.backgroundColor;
    [self.view addSubview:self.myTableView];    
    
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAX(self.view.frame.size.width,self.view.frame.size.height), 20)];
    statusBarView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:statusBarView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return [tableData count];
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 78;
//}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{

//    return cell;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath");
    
    {
        //reset row one
        UITableViewCell *cellreset = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        UILabel *titleLabel = (UILabel *)[cellreset viewWithTag:11000];
        titleLabel.text = @"SHOP";
        UIImageView *iconImageView = (UIImageView *)[cellreset viewWithTag:12000];
        iconImageView.image = [UIImage imageNamed:@"shop_icon.png"];
    
        //reset row two
        cellreset = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        titleLabel = (UILabel *)[cellreset viewWithTag:21000];
        titleLabel.text = @"FAVORITES";
        iconImageView = (UIImageView *)[cellreset viewWithTag:22000];
        iconImageView.image = [UIImage imageNamed:@"fav_icon.png"];
    
    
    //reset row three
//    cellreset = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
//    titleLabel = (UILabel *)[cellreset viewWithTag:31000];
//    titleLabel.text = @"CATEGORIES";
//    iconImageView = (UIImageView *)[cellreset viewWithTag:32000];
//    iconImageView.image = [UIImage imageNamed:@"cat_icon.png"];
    
        //reset row four
        cellreset = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        titleLabel = (UILabel *)[cellreset viewWithTag:31000];
        titleLabel.text = @"SETTING";
        iconImageView = (UIImageView *)[cellreset viewWithTag:32000];
        iconImageView.image = [UIImage imageNamed:@"set_icon.png"];
    
        //reset row five
        cellreset = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        titleLabel = (UILabel *)[cellreset viewWithTag:41000];
        titleLabel.text = @"FEEDBACK";
        iconImageView = (UIImageView *)[cellreset viewWithTag:42000];
        iconImageView.image = [UIImage imageNamed:@"feed_icon.png"];
    
        //reset row two
        cellreset = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
        titleLabel = (UILabel *)[cellreset viewWithTag:51000];
        titleLabel.text = @"LOGOUT";
        iconImageView = (UIImageView *)[cellreset viewWithTag:52000];
        iconImageView.image = [UIImage imageNamed:@"logout_icon.png"];
    }
 
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:
        {
            
            UILabel *titleLabel = (UILabel *)[cell viewWithTag:11000];
            titleLabel.text = @"  SHOP";
    
            UIImageView *iconImageView = (UIImageView *)[cell viewWithTag:12000];
            iconImageView.image = [UIImage imageNamed:@"shop_icon_selected.png"];
            
           
        }
             break;
        case 1:
        {
            UILabel *titleLabel = (UILabel *)[cell viewWithTag:21000];
            titleLabel.text = @"  FAVORITES";
            
            UIImageView *iconImageView = (UIImageView *)[cell viewWithTag:22000];
            iconImageView.image = [UIImage imageNamed:@"fav_icon_selected.png"];
           
        }
             break;
        case 2:
        {
            UILabel *titleLabel = (UILabel *)[cell viewWithTag:31000];
            titleLabel.text = @"  SETTING";
            
            UIImageView *iconImageView = (UIImageView *)[cell viewWithTag:32000];
            iconImageView.image = [UIImage imageNamed:@"set_icon_selected.png"];

        }
             break;
        case 3:
        {
            UILabel *titleLabel = (UILabel *)[cell viewWithTag:41000];
            titleLabel.text = @"  FEEDBACK";
            
            UIImageView *iconImageView = (UIImageView *)[cell viewWithTag:42000];
            iconImageView.image = [UIImage imageNamed:@"feed_icon_selected.png"];
            
        }
             break;
        case 4:
        {
            UILabel *titleLabel = (UILabel *)[cell viewWithTag:51000];
            titleLabel.text = @"  LOGOUT";
            
            UIImageView *iconImageView = (UIImageView *)[cell viewWithTag:52000];
            iconImageView.image = [UIImage imageNamed:@"logout_icon_selected.png"];
            
        }
            break;
    }
    
    if (indexPath.row == 4)
    {
        AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        appDelegate.isLogedin = FALSE;
        
        [FBSession.activeSession closeAndClearTokenInformation];
        [FBSession.activeSession close];
        [FBSession setActiveSession:nil];
        
        NSHTTPCookieStorage *cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        NSArray *facebookCookies = [cookies cookiesForURL:[NSURL URLWithString:@"http://login.facebook.com"]];
        for (NSHTTPCookie *cookie in facebookCookies)
        {
            [cookies deleteCookie:cookie];
        }
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else
    {
        AMSlideMenuMainViewController *mainVC = [self mainSlideMenu];
        [mainVC openContentViewControllerForMenu:AMSlideMenuLeft atIndexPath:indexPath];
    }

}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   

    
    return indexPath;
}


@end
