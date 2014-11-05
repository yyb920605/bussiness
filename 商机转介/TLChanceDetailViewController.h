//
//  TLChanceDetailViewController.h
//  商机转介
//
//  Created by mac on 14-4-22.
//  Copyright (c) 2014年 allinpay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLAppDelegate.h"
#import "ASIHttpHeaders.h"
#import "tooles.h"

@interface TLChanceDetailViewController : UIViewController
@property (nonatomic,retain) IBOutlet UITextField *businessName;
@property (nonatomic,retain) IBOutlet UITextField *person;
@property (nonatomic,retain) IBOutlet UITextField *phone;
@property (nonatomic,retain) IBOutlet UITextField *address;
@property NSDictionary *chance;
-(IBAction)subbmit:(id)sender;
@end
