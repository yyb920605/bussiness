//
//  TLBankcardViewController.h
//  商机转介
//
//  Created by mac on 14-4-14.
//  Copyright (c) 2014年 allinpay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLAppDelegate.h"
#import "ASIHttpHeaders.h"
#import "tooles.h"
#import "NIDropDown.h"

@interface TLBankcardViewController : UIViewController<NIDropDownDelegate>
{
    IBOutlet UIButton *btnSelect;
    NIDropDown *dropDown;
}

@property (nonatomic,retain)IBOutlet UITextField *name;
@property (nonatomic,retain)IBOutlet UITextField *phone;
@property (nonatomic,retain)IBOutlet UITextField *bank;
@property (nonatomic,retain)IBOutlet UITextField *account;
@property (nonatomic,retain)NSDictionary *bankcard;
@property (nonatomic,retain)NSString *bankcardid;

@property (nonatomic,retain)NSArray *bankList;
@property (retain, nonatomic) IBOutlet UIButton *btnSelect;

-(IBAction)submmit:(id)sender;
@end
