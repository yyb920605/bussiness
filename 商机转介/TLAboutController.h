//
//  TLAboutController.h
//  TongLian
//
//  Created by mac on 13-11-7.
//  Copyright (c) 2013年 BoYunSen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLAdvertisementViewController.h"
#import "TLAppDelegate.h"

@interface TLAboutController : UIViewController
@property (nonatomic,strong)IBOutlet UILabel *version;
-(IBAction)discribe:(id)sender;
-(IBAction)about:(id)sender;
@end
