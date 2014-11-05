//
//  TLChanceListController.h
//  商机转介
//
//  Created by mac on 14-4-22.
//  Copyright (c) 2014年 allinpay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLAppDelegate.h"
#import "TLChanceListCell.h"
#import "ASIHttpHeaders.h"
#import "tooles.h"
#import "TLChanceDetailViewController.h"

@interface TLChanceListController : UITableViewController
@property (nonatomic,retain)NSMutableArray *businessList;
@property (nonatomic,retain)NSString *processID;
@property  NSInteger totalRecords;
@property NSInteger currentPage;
@property (nonatomic,retain)NSString *orderStatus;


@end
