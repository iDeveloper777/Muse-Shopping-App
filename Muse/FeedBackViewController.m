//
//  FeedBackViewController.m
//  Muse
//
//  Created by Mike Tran on 27/11/14.
//  Copyright (c) 2014 Digi. All rights reserved.
//
#import "MainVC.h"
#import "FeedBackViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "apiconstants.h"
#import "MuseSingleton.h"
#import "LoginModel.h"

#import "ChoosePersonViewController.h"
#import "AMSlideMenuMainViewController.h"
#import "LeftMenuVC.h"

@interface FeedBackViewController ()

@property UIButton *sendButton;
@property UIButton *backToShopButton;
@property UITextField *feedbackField;

@end

@implementation FeedBackViewController
@synthesize feedbackTextView;

- (void)viewDidLoad {
    [super viewDidLoad];

    [self layoutComponents];
}

- (void) layoutComponents
{
    int winWidth = self.view.bounds.size.width;
    int winHeight = self.view.bounds.size.height;
    
    feedbackTextView = [[UITextView alloc] initWithFrame:CGRectMake(winWidth/12, winWidth/12, winWidth/12*10, winHeight/3 * 2)];
    feedbackTextView.backgroundColor = [UIColor whiteColor];
    feedbackTextView.textColor = [UIColor blackColor];
    feedbackTextView.font = [UIFont systemFontOfSize:14.0f];
    feedbackTextView.scrollEnabled = YES;
    feedbackTextView.editable = TRUE;
    feedbackTextView.selectedRange = NSMakeRange(0, 0);
    feedbackTextView.tintColor = [UIColor blackColor];
    feedbackTextView.layer.borderWidth = 1.0f;
    feedbackTextView.tag = 1;
    feedbackTextView.layer.borderColor = [[UIColor colorWithRed:110.f/255.f green:110.f/255.f blue:110.f/255.f alpha:0.8f] CGColor];
    
    [self.view addSubview:feedbackTextView];
    
    _sendButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-50, feedbackTextView.frame.origin.y + feedbackTextView.frame.size.height + 20, 100, 30)];
    [_sendButton setBackgroundImage:[UIImage imageNamed:@"sendButton.png" ] forState: UIControlStateNormal];
    [_sendButton addTarget:self action:@selector(pressSendButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sendButton];
    
    _backToShopButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-80, feedbackTextView.frame.origin.y + feedbackTextView.frame.size.height + 20, 160, 30)];
    [_backToShopButton setBackgroundImage:[UIImage imageNamed:@"backToShopButton.png" ] forState: UIControlStateNormal];
    [_backToShopButton addTarget:self action:@selector(pressBackToShopButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backToShopButton];
    _backToShopButton.hidden = YES;
    _backToShopButton.enabled = NO;
    
    
}

- (void) pressSendButton
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    MuseSingleton *singleton = [MuseSingleton getInstance];
    LoginModel *logindata = [singleton getLoginData];
    
    [manager setRequestSerializer:[[AFJSONRequestSerializer alloc] init]];
    [manager setResponseSerializer:[[AFJSONResponseSerializer alloc] init]];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@ %@",@"Bearer",logindata.token] forHTTPHeaderField:@"authorization"];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:logindata.id forKey:@"_user"];
    [parameters setValue:self.feedbackTextView.text forKey:@"message"];
    
    if ([self.feedbackTextView.text isEqualToString:@""])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Notification!" message:@"Please enter your feedback." delegate:nil cancelButtonTitle:@"O k" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    else
        _sendButton.enabled = FALSE;

    NSString *strURL = [NSString stringWithFormat:@"%@%@", iMuseBaseUrl, apiFeedBack];
//    NSLog(strURL);
    
    [manager POST:strURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"%@", responseObject);
         NSLog(@"Feedback Success!");
         
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Notification!" message:@"Thank you for your comment. Your feedback is important to us." delegate:nil cancelButtonTitle:@"O k" otherButtonTitles:nil, nil];
         [alertView show];
         
         _sendButton.hidden = YES;
         _sendButton.enabled = NO;
         
         _backToShopButton.hidden = NO;
         _backToShopButton.enabled = YES;
         _backToShopButton.center = CGPointMake(self.view.bounds.size.width/2, 50);
         
         feedbackTextView.editable = FALSE;
         feedbackTextView.hidden = YES;
         
     }failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Feedback Failure! %@", error.description);
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Notification!" message:@"Server Error!" delegate:nil cancelButtonTitle:@"O k" otherButtonTitles:nil, nil];
         [alertView show];
     }];
}

- (void) pressBackToShopButton
{
    MainVC *mainVC = (MainVC*) [self.navigationController parentViewController];
//    [mainVC openContentViewControllerForMenu:AMSlideMenuLeft atIndexPath:0];
    NSIndexPath *initialIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];

    UITableViewCell *cell = [mainVC.leftMenu tableView:mainVC.leftMenu.tableView cellForRowAtIndexPath:initialIndexPath];
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:11000];
    titleLabel.text = @"  SHOP";
    
    UIImageView *iconImageView = (UIImageView *)[cell viewWithTag:12000];
    iconImageView.image = [UIImage imageNamed:@"shop_icon_selected.png"];

    cell.selected = TRUE;
    
    
    /// current selected item clear
    NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    cell = [mainVC.leftMenu tableView:mainVC.leftMenu.tableView cellForRowAtIndexPath:currentIndexPath];
    
    titleLabel = (UILabel *)[cell viewWithTag:41000];
    titleLabel.text = @"  FEEDBACK";
    
    iconImageView = (UIImageView *)[cell viewWithTag:42000];
    iconImageView.image = [UIImage imageNamed:@"feed_icon.png"];
    
    cell.selected = FALSE;

    [self performSelector:@selector(gotoShopPage) withObject:self afterDelay:0.5];
    
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    [super touchesBegan:touches withEvent:event];
    
    if ([touch view] != [feedbackTextView viewWithTag:1])
    {
        [feedbackTextView resignFirstResponder];
    }
    
}

- (void) gotoShopPage
{
    MainVC *mainVC = (MainVC*) [self.navigationController parentViewController];

    NSIndexPath *initialIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [mainVC.leftMenu tableView:mainVC.leftMenu.tableView didSelectRowAtIndexPath:initialIndexPath];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
