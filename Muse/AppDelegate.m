//
//  AppDelegate.m
//  Muse
//
//  Created by Pasca Maulana on 29/9/14.
//  Copyright (c) 2014 Digi. All rights reserved.
//

#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "FavoriteViewController.h"
#import "MainVC.h"

@interface AppDelegate () <UIAlertViewDelegate>

@end

@implementation AppDelegate
@synthesize shopModelList;
@synthesize shopModelListItems;
@synthesize shopCategoryList;
@synthesize shopModelListImages;
@synthesize isSetCategory;
@synthesize isReload;


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    } else {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    
    [self registerToken:application];
    
    shopModelList = [[NSMutableArray alloc] init];
    shopCategoryList = [[NSMutableArray alloc] init];
    shopModelListImages = [[NSMutableArray alloc] init];
    isSetCategory = 0;
    isReload = 0;
    
    NSUserDefaults *userDefaults  = [NSUserDefaults standardUserDefaults];
    NSArray *tempArray = [userDefaults arrayForKey:@"shopModelListItems"];
    if ([tempArray isKindOfClass:[NSArray class]] && tempArray.count != 0)
    {
        shopModelListItems = tempArray;
//        NSLog(@"%@", [tempArray objectAtIndex:0]);
    }else
    {
        [userDefaults setObject:[[NSArray alloc] init] forKey:@"shopModelListItems"];
        [userDefaults synchronize];
    }
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void) registerToken:(UIApplication *)application
{
    //For Push Notification
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeAlert|UIUserNotificationTypeSound categories:nil];
        
        [application registerUserNotificationSettings:settings];
    }
    else
    {
        UIRemoteNotificationType myType = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myType];
    }
}

//Device Token
- (void) application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

- (void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *devicePushToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    devicePushToken = [devicePushToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    self.token = devicePushToken;
//    NSLog(@"Token = %@", devicePushToken);
    
    NSUserDefaults *userDefaults  = [NSUserDefaults standardUserDefaults];
    NSString *saveToken = [userDefaults stringArrayForKey:@"deviceToken"];
    
    if ([saveToken isKindOfClass:[NSString class]] && ![saveToken isEqualToString:@""] && ![saveToken isEqualToString:@"null"])
    {
        [userDefaults setObject:self.token forKey:@"deviceToken"];
        [userDefaults synchronize];
    }
    else
    {
        [userDefaults setObject:@"" forKey:@"deviceToken"];
        [userDefaults synchronize];
    }
        
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notification" message:devicePushToken delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alert show];
}

- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSDictionary *dict = [userInfo objectForKey:@"aps"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notification" message:[dict objectForKey:@"alert"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        FavoriteViewController *favoriteViewController = [storyboard instantiateViewControllerWithIdentifier:@"favoriteView"];
//        
//        [self.navController pushViewController:favoriteViewController animated:TRUE];
        
        
        NSIndexPath *initialIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        [self.mainVC.leftMenu tableView:self.mainVC.leftMenu.tableView didSelectRowAtIndexPath:initialIndexPath];
    }
}

- (void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Failed RemoteNotification");
}
@end
