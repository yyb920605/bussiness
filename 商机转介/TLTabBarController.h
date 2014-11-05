//
//  TLTabBarController.h
//  商机转介
//
//  Created by yyb on 14-11-3.
//  Copyright (c) 2014年 allinpay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLMyMapViewController.h"
#import "TLAppDelegate.h"
@interface TLTabBarController : UITabBarController
@property (strong, nonatomic) IBOutlet UIBarButtonItem *faxianButton;
@property (strong,nonatomic) TLMyMapViewController *myMapViewController;
-(IBAction)faxian:(id)sender;
@end
