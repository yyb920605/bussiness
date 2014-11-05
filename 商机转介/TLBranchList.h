//
//  TLBranchList.h
//  商机转介
//
//  Created by mac on 14-10-28.
//  Copyright (c) 2014年 allinpay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLAppDelegate.h"
#import "ASIHttpHeaders.h"
#import "tooles.h"
#import "TLSubBranchList.h"

@interface TLBranchList : UITableViewController
@property NSString *bank;
@property NSString *branch;
@property NSArray *branchList;
@end
