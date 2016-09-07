//
//  LoginController.m
//  Muse
//
//  Created by Pasca Maulana on 29/9/14.
//  Copyright (c) 2014 Digi. All rights reserved.
//

#import "LoginController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "apiconstants.h"
#import "MainVC.h"
#import "LoginModel.h"
#import "MuseSingleton.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "AFHTTPRequestOperationManager.h"
#import "AppDelegate.h"

#import "UserData.h"
#import "ProgressHUD.h"

@interface LoginController ()

@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
       
    [self.navigationController setNavigationBarHidden:YES animated:YES];
/*
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    backgroundImageView.image = [UIImage imageNamed:@"log_in_img.png"];
    [self.view addSubview:backgroundImageView];
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width / 2 -120, self.view.bounds.size.height/2 -50, 240, 60)];
    logoImageView.image = [UIImage imageNamed:@"log_in_logo.png"];
    [self.view addSubview:logoImageView];
  */  
    FBLoginView *loginView =  [[FBLoginView alloc] initWithReadPermissions:@[@"public_profile", @"email", @"user_friends"]];
    loginView.delegate = self;
    loginView.center = self.view.center;
    CGRect loginframe = [loginView frame];
    loginframe.origin.y = loginView.frame.origin.y + self.view.bounds.size.height/3 - 20;
    loginView.frame = loginframe;
    [self.view addSubview:loginView];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {

    if (user.name) {
        
        AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        
        
        
        if(appDelegate.isLogedin)
            return;
        
        appDelegate.isLogedin = TRUE;
        
        NSString *fbAccessToken = [[[FBSession activeSession] accessTokenData] accessToken];
        
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [ProgressHUD show:@"Loading..."];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
           
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
            [parameters setValue:fbAccessToken forKey:@"access_token"];
            
//            NSLog(@"accessToken = %@", fbAccessToken);
            
            if (appDelegate.token != nil)
            {
                [parameters setValue:appDelegate.token forKey:@"deviceId"];
                NSLog(@"Token = %@", appDelegate.token);

            }else
            {
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSString *saveToken = [userDefaults stringForKey:@"deviceToken"];
                
                if ([saveToken isKindOfClass:[NSString class]])
                {
                    [parameters setValue:saveToken forKey:@"deviceId"];
                    NSLog(@"Token = %@", saveToken);
                }
                else
                {
                    [parameters setValue:@"" forKey:@"deviceId"];
                    NSLog(@"Token = null");
                }
            }
            
            [parameters setValue:@"ios" forKey:@"os"];
            
            [manager setResponseSerializer:[[AFJSONResponseSerializer alloc] init]];
            [manager.requestSerializer setValue:@"Bearer" forHTTPHeaderField:@"authorization"];
//            NSLog([NSString stringWithFormat:@"%@%@", iMuseBaseUrl, apiPostSignInFacebook]);
            [manager POST:[NSString stringWithFormat:@"%@%@", iMuseBaseUrl, apiPostSignInFacebook] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                NSLog(@"JSON: %@", responseObject);
                
          
//                NSString* json = (NSString*)responseObject;
//                NSError* err = nil;
                LoginModel* logindata = [[LoginModel alloc]initWithDictionary:responseObject error:nil];
                
                MuseSingleton* singleton = [MuseSingleton getInstance];
                [singleton setLoginData:logindata];
                
                //Get UserData
                [self setUserData];
                
                [self performSegueWithIdentifier:@"booya" sender:self];
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Notification!" message:@"Server Error!" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
                [alertView show];
                NSLog(@"Error: %@", error);
                
                [ProgressHUD dismiss];
//                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];
            
            dispatch_async(dispatch_get_main_queue(), ^{
//                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        });
    }

}

- (void)setUserData
{
    MuseSingleton* singleton = [MuseSingleton getInstance];
    LoginModel* logindata = [singleton getLoginData];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager setResponseSerializer:[[AFJSONResponseSerializer alloc] init]];
    [manager setRequestSerializer:[[AFJSONRequestSerializer alloc] init]];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@ %@",@"Bearer",logindata.token] forHTTPHeaderField:@"authorization"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
//    NSString * strApiURL = [NSString stringWithFormat:@"%@%@", iMuseBaseUrl, [NSString stringWithFormat:apiGetUsers,logindata.id]];
    NSString * strApiURL = [NSString stringWithFormat:@"%@%@", iMuseBaseUrl, apiGetUsers];
//    NSLog(strApiURL);
    
    [manager GET:strApiURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
//         NSLog(@"GetUserData Success!");
         UserData *uData = [[UserData alloc] init];
         
         uData.userid = [responseObject objectForKey:@"id"];
         uData.username = [responseObject objectForKey:@"name"];
         uData.email = [responseObject objectForKey:@"email"];
         uData.gcmRegisterationId = [responseObject objectForKey:@"gcmRegisterationId"];
         uData.phone = [responseObject objectForKey:@"phone"];
         uData.mobile = [responseObject objectForKey:@"mobile"];
         uData.address = [responseObject objectForKey:@"address"];
         uData.adm1 = [responseObject objectForKey:@"adm1"];
         uData.adm2 = [responseObject objectForKey:@"adm2"];
         uData.postalCode = [responseObject objectForKey:@"postalCode"];
         
         [singleton setUserData:uData];
         
         
     }failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Notification!" message:@"Server Error!" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
         [alertView show];
     }];
}

- (void) getUserData
{
    
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {

}


- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
}


- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
   
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
       
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
       
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
//        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}


@end
