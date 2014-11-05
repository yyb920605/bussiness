//
//  TLShowImageViewController.h
//  商机转介
//
//  Created by mac on 14-4-13.
//  Copyright (c) 2014年 allinpay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLShowImageViewController : UIViewController
@property (nonatomic,retain)IBOutlet UIImageView *ImageView;
@property (nonatomic,retain)NSString *ImageName;

-(IBAction)click:(id)sender;
@end
