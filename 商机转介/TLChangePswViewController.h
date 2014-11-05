//
//  TLChangePswViewController.h
//  商机转介
//
//  Created by mac on 14-5-7.
//  Copyright (c) 2014年 allinpay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tooles.h"
#import "ASIHttpHeaders.h"
#import "TLAppDelegate.h"


@interface TLChangePswViewController : UIViewController
@property (nonatomic,retain)IBOutlet UITextField *oPsw;
@property (nonatomic,retain)IBOutlet UITextField *nPsw;
@property (nonatomic,retain)IBOutlet UITextField *nPsw1;

-(IBAction)subbmit:(id)sender;
-(IBAction)textFieldDone:(id)sender;


@end
