//
//  TLChanceListCell.h
//  商机转介
//
//  Created by mac on 14-4-22.
//  Copyright (c) 2014年 allinpay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLChanceListCell : UITableViewCell
@property (nonatomic,retain)IBOutlet UILabel *businessName;
@property (nonatomic,retain)IBOutlet UILabel *person;
@property (nonatomic,retain)IBOutlet UILabel *phone;
@property (nonatomic,retain)IBOutlet UILabel *address;
@property (nonatomic,retain)IBOutlet UILabel *status;
@property (nonatomic,retain)IBOutlet UILabel *date;
@property (nonatomic,retain)IBOutlet UILabel *mytextLabel;

@property (nonatomic,retain)IBOutlet UIButton *myImage;

@end
