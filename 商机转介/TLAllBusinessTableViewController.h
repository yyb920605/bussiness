//
//  TLAllBusinessTableViewController.h
//  商机转介
//
//  Created by mac on 14-4-14.
//  Copyright (c) 2014年 allinpay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLAppDelegate.h"
#import "TLAllBusinessCell.h"
#import "ASIHttpHeaders.h"
#import "tooles.h"
#import "TLChanceDetailViewController.h"

@interface TLAllBusinessTableViewController : UITableViewController
@property (nonatomic,retain)NSArray *businessList;
@property (nonatomic,retain)NSString *processID;
@end
