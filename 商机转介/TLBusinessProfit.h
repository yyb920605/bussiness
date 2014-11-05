//
//  TLBusinessProfit.h
//  商机转介
//
//  Created by mac on 14-9-5.
//  Copyright (c) 2014年 allinpay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCLineChartView.h"
#import "GenericViewController.h"
#import "TLAppDelegate.h"
#import "ASIHttpHeaders.h"
#import "tooles.h"

@interface TLBusinessProfit : GenericViewController {
	PCLineChartView *lineChartView;
}
@property (nonatomic,retain)NSMutableArray *points;
@property (nonatomic,retain)NSMutableArray *X_labels;

@property float maxValue;//月（周）日均存款最大值
@property (nonatomic,strong)NSString *recent;//近一月（周）日均存款
@property NSString *six;//近6月（周）日均存款

@property NSString *businessInfoId;
@property int num;
@property NSString *businessName;
@property IBOutlet UILabel *mw;
@property IBOutlet UILabel *lmwlabel;
@property IBOutlet UILabel *lmw;
@property IBOutlet UILabel *mwlabel;

@property IBOutlet UIButton *month;
@property IBOutlet UIButton *week;
@property IBOutlet UILabel *bnlabel;

-(IBAction)monthclick:(id)sender;
-(IBAction)weekclick:(id)sender;

@end
