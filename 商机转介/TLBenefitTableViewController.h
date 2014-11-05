//
//  TLBenefitTableViewController.h
//  商机转介
//
//  Created by mac on 14-9-3.
//  Copyright (c) 2014年 allinpay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLBenefitCell.h"
#import "tooles.h"
#import "TLAppDelegate.h"
#import "ASIHttpHeaders.h"
#import "TLBusinessProfit.h"

@interface TLBenefitTableViewController : UITableViewController

@property (nonatomic,retain)NSMutableArray *benefitList;
@property NSInteger totalRecords;
@property NSString *totalProfit;
@property NSInteger currentPage;
@property NSString *businessInfoId;

@end
