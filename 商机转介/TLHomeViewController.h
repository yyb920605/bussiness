//
//  TLHomeViewController.h
//  商机转介
//
//  Created by mac on 14-5-5.
//  Copyright (c) 2014年 allinpay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLAppDelegate.h"
#import "TLChanceListCell.h"
#import "ASIHttpHeaders.h"
#import "tooles.h"
#import "TLRecommanderViewController.h"
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"
#import "TLAdvertisementViewController.h"
#import "TLReaderViewController.h"
#import "TLChanceListViewController.h"
#import "TLBenefitTableViewController.h"
#import "TLBenifitViewController.h"
#import "TLNewRecommander.h"

@interface TLHomeViewController : UIViewController<SGFocusImageFrameDelegate>

@property (nonatomic,strong) NSArray *photoList;
@property IBOutlet UIButton *faqi;
@property IBOutlet UIButton *faqibj;
@property IBOutlet UIButton *tongji;
@property IBOutlet UIButton *tongjibj;
@property IBOutlet UIButton *fenxiang;
@property IBOutlet UIButton *fengxiangbj;
@property IBOutlet UIButton *tuijianren;
@property IBOutlet UIButton *tuijianrenbj;

-(IBAction)faqi:(id)sender;
-(IBAction)tongji:(id)sender;
-(IBAction)commender:(id)sender;
-(IBAction)myShare:(id)sender;
-(IBAction)benefit:(id)sender;
-(IBAction)iwant:(id)sender;


@end
