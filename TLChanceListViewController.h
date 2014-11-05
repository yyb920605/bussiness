//
//  TLChanceListViewController.h
//  商机转介
//
//  Created by mac on 14-4-22.
//  Copyright (c) 2014年 allinpay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLAppDelegate.h"
#import "ASIHttpHeaders.h"
#import "tooles.h"
#import "TLChanceListController.h"
#import "TLAllBusinessTableViewController.h"
#import "TLBenefitTableViewController.h"

@interface TLChanceListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UITableView *mytableview;
}

@property (nonatomic,strong)NSString *orderStatus;
@property NSString *myURL;

@property (nonatomic,retain)NSMutableArray *businessList;
@property (nonatomic,retain)NSString *processID;
@property  NSInteger totalRecords;
@property NSInteger currentPage;
@property NSString *imageName;

@property IBOutlet UIButton *manage;
@property IBOutlet UIButton *shcedule;
@property IBOutlet UIButton *customer;
@property IBOutlet UIButton *sucess;
@property IBOutlet UIImageView *queue;

-(IBAction)shcedule:(id)sender;
-(IBAction)customer:(id)sender;
-(IBAction)cend:(id)sender;
-(IBAction)manage:(id)sender;
@end
