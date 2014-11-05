//
//  TLFindPswViewController.h
//  商机转介
//
//  Created by mac on 14-5-4.
//  Copyright (c) 2014年 allinpay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tooles.h"
#import "ASIHttpHeaders.h"
#import "TLAppDelegate.h"
#import "TLLoginViewController.h"
#import "TLRegisterConfirmViewController.h"

@interface TLFindPswViewController : UIViewController

@property (strong,nonatomic)NSString *phone;
@property (retain,nonatomic)IBOutlet UITextField *psw;
@property (retain,nonatomic)IBOutlet UITextField *psw1;
@property (strong,nonatomic)IBOutlet UITextField *checkNum;
@property (strong,nonatomic)IBOutlet UIScrollView *scrollerView;
@property (strong,nonatomic)IBOutlet UIButton *checkNumButton;
@property int secondsCountDown;//60秒倒计时
@property NSTimer *countDownTimer;//计时器
-(IBAction)btn_click:(id)sender;
-(IBAction)verify:(id)sender;
-(IBAction)back_click:(id)sender;
-(IBAction)textFieldDone:(id)sender;

@end
