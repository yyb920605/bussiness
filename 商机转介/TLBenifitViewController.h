//
//  TLBenifitViewController.h
//  商机转介
//
//  Created by mac on 14-10-15.
//  Copyright (c) 2014年 allinpay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLBenefitCell.h"
#import "TLAppDelegate.h"
#import "tooles.h"
#import "ASIHttpHeaders.h"
#import "TLBusinessProfit.h"

@interface TLBenifitViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UITableView *mytable;
}

@property IBOutlet UILabel *benifit;
@property (nonatomic,retain)NSMutableArray *benefitList;
@property NSInteger totalRecords;
@property NSString *totalProfit;
@property NSInteger currentPage;
@property NSString *businessInfoId;
@property NSString *totalBenifit;

@end
