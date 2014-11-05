//
//  TLRecommanderViewController.h
//  商机转介
//
//  Created by mac on 14-4-14.
//  Copyright (c) 2014年 allinpay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLAppDelegate.h"
#import "TLRecommanderCell.h"
#import "ASIHttpHeaders.h"
#import "tooles.h"


@interface TLRecommanderViewController : UITableViewController
@property (nonatomic,retain)NSMutableArray *recommanderList;
@property NSInteger currentPage;
@property NSInteger totalRecords;

@end
