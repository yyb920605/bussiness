//
//  TLRegisterConfirmViewController.h
//  商机转介
//
//  Created by mac on 14-4-12.
//  Copyright (c) 2014年 allinpay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLAppDelegate.h"
#import "tooles.h"
#import "ASIHttpHeaders.h"
#import "TLLoginViewController.h"
#import "UICheckBoxButton.h"
#import "TLBankList.h"

@interface TLRegisterConfirmViewController : UIViewController

@property (nonatomic,retain)IBOutlet UITextField *uname;
@property (nonatomic,retain)IBOutlet UITextField *psw;
@property (nonatomic,retain)IBOutlet UITextField *psw1;

@property (nonatomic,retain)NSString *registerPhone;
@property (nonatomic,retain)NSString *refree;
@property (nonatomic,retain)UICheckBoxButton *checkButton;
@property (nonatomic,retain)IBOutlet UIScrollView *myScrollerView;
@property IBOutlet UILabel *bankchosed;
@property (nonatomic,retain)IBOutlet UIButton *bank;
@property (nonatomic,retain)IBOutlet UIButton *person;
@property (nonatomic,retain)IBOutlet UIButton *registerr;

@property NSString *userType;

@property NSString *bankName;
@property NSString *branch;
@property NSString *subBranch;

-(IBAction)bank_click:(id)sender;
-(IBAction)person_click:(id)sender;
-(IBAction)registerr_click:(id)sender;

-(IBAction)confirm:(id)sender;
-(IBAction)textFieldDone:(id)sender;
@end
