//
//  SettingsViewController.m
//  Muse
//
//  Created by Mike Tran on 27/11/14.
//  Copyright (c) 2014 Digi. All rights reserved.
//

#import "SettingsViewController.h"
#import "MuseSingleton.h"
#import "LoginModel.h"

@interface SettingsViewController ()

@property UIView *backUIView;
@property UIImageView *barImageView;
@property UIImageView *profileImageView;
@property UIButton *editButton;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutComponents];
    
}

- (void) layoutComponents
{
    int winWidth = self.view.bounds.size.width;
    //int winHeight = self.view.bounds.size.height;
    int topPadding = 15;
    int barPadding = 5;
    int leftPadding = 15;
    
    _profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(winWidth/2-25, 30, 50, 50)];
    _profileImageView.image = [UIImage imageNamed:@"profile01.png"];
    [self.view addSubview:_profileImageView];
    
    _backUIView = [[UIView alloc] initWithFrame:CGRectMake(winWidth/12, 100, winWidth/12*10, topPadding+barPadding+40)];
    _backUIView.backgroundColor = [UIColor whiteColor];
    _backUIView.layer.borderColor = [UIColor colorWithRed:110.f/255.f green:110.f/255.f blue:110.f/255.f alpha:0.5f].CGColor;
    _backUIView.layer.borderWidth = 1.0f;
    [self.view addSubview:_backUIView];
    
    int cellHeight = 30;
    UILabel *tempLabel;
    
    //name label
    tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftPadding, topPadding, _backUIView.bounds.size.width/2 - leftPadding, cellHeight)];
    tempLabel.text = [NSString stringWithFormat:@"Name"];
    tempLabel.font = [UIFont fontWithName:@"Avenir-Light" size:18.0];
    tempLabel.textColor = [UIColor colorWithRed:110.f/255.f green:110.f/255.f blue:110.f/255.f alpha:1.f];
    [_backUIView addSubview:tempLabel];
    
    //login name
    MuseSingleton* singleton = [MuseSingleton getInstance];
    LoginModel* logindata = [singleton getLoginData];
    
    tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(_backUIView.bounds.size.width/2, topPadding, _backUIView.bounds.size.width/2 - leftPadding, cellHeight)];
    tempLabel.textAlignment = UITextAlignmentRight;
    tempLabel.text = logindata.name;
    tempLabel.font = [UIFont fontWithName:@"Avenir-Light" size:18.0];
    tempLabel.textColor = [UIColor colorWithRed:110.f/255.f green:110.f/255.f blue:110.f/255.f alpha:1.f];
    [_backUIView addSubview:tempLabel];
    
    //first bar
    _barImageView = [[UIImageView alloc] initWithFrame:CGRectMake(leftPadding, topPadding + barPadding+cellHeight, _backUIView.bounds.size.width-leftPadding*2,1)];
    [_barImageView setBackgroundColor: [UIColor colorWithRed:239.f/255.f green:239.f/255.f blue:239.f/255.f alpha:1.f]];
    [_backUIView addSubview:_barImageView];

/*
    //address label
    tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftPadding, topPadding*2+cellHeight+barPadding, _backUIView.bounds.size.width/3*2 - leftPadding, cellHeight)];
    tempLabel.text = [NSString stringWithFormat:@"Shipping Address"];
    tempLabel.font = [UIFont fontWithName:@"Avenir-Light" size:18.0];
    tempLabel.textColor = [UIColor colorWithRed:110.f/255.f green:110.f/255.f blue:110.f/255.f alpha:1.f];
    [_backUIView addSubview:tempLabel];
    
    //PIK
    tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(_backUIView.bounds.size.width/2, topPadding*2+cellHeight+barPadding, _backUIView.bounds.size.width/2 - leftPadding, cellHeight)];
    tempLabel.textAlignment = UITextAlignmentRight;
    tempLabel.text = [NSString stringWithFormat:@"PIK"];
    tempLabel.font = [UIFont fontWithName:@"Avenir-Light" size:18.0];
    tempLabel.textColor = [UIColor colorWithRed:110.f/255.f green:110.f/255.f blue:110.f/255.f alpha:1.f];
    [_backUIView addSubview:tempLabel];
    
    //second bar
    _barImageView = [[UIImageView alloc] initWithFrame:CGRectMake(leftPadding, topPadding*2+cellHeight*2+barPadding*2, _backUIView.bounds.size.width-leftPadding*2,1)];
    [_barImageView setBackgroundColor: [UIColor colorWithRed:239.f/255.f green:239.f/255.f blue:239.f/255.f alpha:1.f]];
    [_backUIView addSubview:_barImageView];
    
    //CC Info label
    tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftPadding, topPadding*3+cellHeight*2+barPadding*2, _backUIView.bounds.size.width/2 - leftPadding, cellHeight)];
    tempLabel.text = [NSString stringWithFormat:@"CC Info"];
    tempLabel.font = [UIFont fontWithName:@"Avenir-Light" size:18.0];
    tempLabel.textColor = [UIColor colorWithRed:110.f/255.f green:110.f/255.f blue:110.f/255.f alpha:1.f];
    [_backUIView addSubview:tempLabel];
    
    //
    tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(_backUIView.bounds.size.width/2, topPadding*3+cellHeight*2+barPadding*2, _backUIView.bounds.size.width/2 - leftPadding, cellHeight)];
    tempLabel.textAlignment = UITextAlignmentRight;
    tempLabel.text = [NSString stringWithFormat:@"****5566"];
    tempLabel.font = [UIFont fontWithName:@"Avenir-Light" size:18.0];
    tempLabel.textColor = [UIColor colorWithRed:110.f/255.f green:110.f/255.f blue:110.f/255.f alpha:1.f];
    [_backUIView addSubview:tempLabel];
    
    //third bar
    _barImageView = [[UIImageView alloc] initWithFrame:CGRectMake(leftPadding, topPadding*3+cellHeight*3+barPadding*3, _backUIView.bounds.size.width-leftPadding*2,1)];
    [_barImageView setBackgroundColor: [UIColor colorWithRed:239.f/255.f green:239.f/255.f blue:239.f/255.f alpha:1.f]];
    [_backUIView addSubview:_barImageView];
    
    //Billing Address label
    tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftPadding, topPadding*4+cellHeight*3+barPadding*3, _backUIView.bounds.size.width/2 - leftPadding, cellHeight)];
    tempLabel.text = [NSString stringWithFormat:@"Billing Address"];
    tempLabel.font = [UIFont fontWithName:@"Avenir-Light" size:18.0];
    tempLabel.textColor = [UIColor colorWithRed:110.f/255.f green:110.f/255.f blue:110.f/255.f alpha:1.f];
    [_backUIView addSubview:tempLabel];
    
    //PIK
    tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(_backUIView.bounds.size.width/2, topPadding*4+cellHeight*3+barPadding*3, _backUIView.bounds.size.width/2 - leftPadding, cellHeight)];
    tempLabel.textAlignment = UITextAlignmentRight;
    tempLabel.text = [NSString stringWithFormat:@"PIK"];
    tempLabel.font = [UIFont fontWithName:@"Avenir-Light" size:18.0];
    tempLabel.textColor = [UIColor colorWithRed:110.f/255.f green:110.f/255.f blue:110.f/255.f alpha:1.f];
    [_backUIView addSubview:tempLabel];
    
    //third bar
    _barImageView = [[UIImageView alloc] initWithFrame:CGRectMake(leftPadding, topPadding*4+cellHeight*4+barPadding*4, _backUIView.bounds.size.width-leftPadding*2,1)];
    [_barImageView setBackgroundColor: [UIColor colorWithRed:239.f/255.f green:239.f/255.f blue:239.f/255.f alpha:1.f]];
    [_backUIView addSubview:_barImageView];

    _editButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-50, self.view.bounds.size.height/5*2 + 20, 100, 30)];
    [_editButton setBackgroundImage:[UIImage imageNamed:@"editButton.png" ] forState: UIControlStateNormal];
    [_editButton addTarget:self action:@selector(pressEditButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_editButton];
 */
    
}

- (void) pressEditButton
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
