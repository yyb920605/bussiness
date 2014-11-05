//
//  TLMySubmitTaskController.h
//  TongLian
//
//  Created by mac on 13-10-30.
//  Copyright (c) 2013年 BoYunSen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tooles.h"
#import "ASIHttpHeaders.h"
#import "TLAppDelegate.h"
#import "TLMySendTaskList.h"
#import "TLLoginViewController.h"
#import "TLChangePswViewController.h"

@interface TLMySubmitTaskController : UIViewController
@property (nonatomic,strong)IBOutlet UILabel *balance;
@property (nonatomic,strong)IBOutlet UILabel *name;
@property IBOutlet UILabel *phone;


-(IBAction)search:(id)sender;
-(IBAction)changep:(id)sender;
-(IBAction)logout:(id)sender;
@end
