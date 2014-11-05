//
//  TLCell.h
//  TongLian
//
//  Created by mac on 13-9-16.
//  Copyright (c) 2013年 BoYunSen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *submit;
@property (strong, nonatomic) IBOutlet UIButton *branch;
@property (strong, nonatomic) IBOutlet UIButton *task;
@property (strong, nonatomic) IBOutlet UIButton *detail;

@property (strong, nonatomic) IBOutlet UILabel *businessID;
@property (strong, nonatomic) IBOutlet UILabel *companyName;
@property (strong, nonatomic) IBOutlet UILabel *companyStatus;
@property (strong, nonatomic) IBOutlet UILabel *createTime;


@end
