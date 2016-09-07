//
//  LoginController.h
//  Muse
//
//  Created by Pasca Maulana on 29/9/14.
//  Copyright (c) 2014 Digi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface LoginController : UIViewController <FBLoginViewDelegate>
{
}
-(void)getUserData;

@end

