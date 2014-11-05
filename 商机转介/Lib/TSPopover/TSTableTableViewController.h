//
//  TSTableTableViewController.h
//  商机转介
//
//  Created by mac on 14-10-23.
//  Copyright (c) 2014年 allinpay. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NSPopDelegate
-(void)selectBankGKB:(NSString *)bank;
@end

@interface TSTableTableViewController : UITableViewController
@property (nonatomic,retain)id<NSPopDelegate>delegate;

@property (nonatomic,retain)NSArray *list;

@end
