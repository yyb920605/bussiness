//
//  TLLoginViewController.h
//  TongLian
//
//  Created by mac on 13-9-10.
//  Copyright (c) 2013年 BoYunSen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tooles.h"
#import "ASIHttpHeaders.h"
#import "TLCompany.h"
#import "TLRegister.h"
#import "NIDropDown.h"
#import "TLFindPswViewController.h"

#define Screen_height   [[UIScreen mainScreen] bounds].size.height
#define Screen_width    [[UIScreen mainScreen] bounds].size.width
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO) 

@interface TLLoginViewController : UIViewController<NIDropDownDelegate>
{
    NIDropDown *dropDown;
}

@property (nonatomic,retain)IBOutlet UITextField *userName;
@property (nonatomic,retain)IBOutlet UITextField *password;
@property (nonatomic,retain)NSArray *ServernameList;
@property (nonatomic,retain)NSDictionary *ServerDic;
@property (nonatomic,retain)IBOutlet UIScrollView *myScrollerView;

-(IBAction)login:(id)sender;
-(IBAction)register_click:(id)sender;
-(IBAction)textFieldDone:(id)sender;
-(IBAction)findPsw:(id)sender;
-(void)GetResult:(ASIHTTPRequest *)request;
-(void)GetErr:(ASIHTTPRequest *)request;

@end
