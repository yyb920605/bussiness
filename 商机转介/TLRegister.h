//
//  TLRegister.h
//  TongLian
//
//  Created by mac on 13-11-11.
//  Copyright (c) 2013年 BoYunSen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tooles.h"
#import "ASIHttpHeaders.h"
#import "TLAppDelegate.h"
#import "TLLoginViewController.h"
#import "TLRegisterConfirmViewController.h"

@interface TLRegister : UIViewController
@property (strong,nonatomic)IBOutlet UITextField *name;
@property (strong,nonatomic)IBOutlet UITextField *checkNum;
@property (strong,nonatomic)IBOutlet UITextField *refree;
@property (strong,nonatomic)IBOutlet UIScrollView *scrollerView;
@property (strong,nonatomic)IBOutlet UIButton *checkNumButton;
@property int secondsCountDown;//60秒倒计时
@property NSTimer *countDownTimer;//计时器
-(IBAction)btn_click:(id)sender;
-(IBAction)verify:(id)sender;
-(IBAction)back_click:(id)sender;
-(IBAction)textFieldDone:(id)sender;
@end
