//
//  TLShareByMessageViewController.h
//  商机转介
//
//  Created by mac on 14-5-7.
//  Copyright (c) 2014年 allinpay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "tooles.h"
#import "TLAppDelegate.h"

@interface TLShareByMessageViewController : UIViewController<MFMailComposeViewControllerDelegate,
MFMessageComposeViewControllerDelegate, UINavigationControllerDelegate>
@property (retain,nonatomic)IBOutlet UITextField *name;
@property (retain,nonatomic)IBOutlet UITextField *phone;

-(IBAction)sendmsg:(id)sender;

@end
