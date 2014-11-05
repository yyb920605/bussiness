//
//  TLReaderViewController.h
//  TongLian
//
//  Created by mac on 14-3-17.
//  Copyright (c) 2014年 BoYunSen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLAppDelegate.h"
#import "ASIHttpHeaders.h"
#import "tooles.h"
//#import "ZBarReaderController.h"
#import "ZBarReaderViewController.h"
#import "TLRecallTableViewController.h"
#import "TLImage.h"
#import "TLShowImageViewController.h"
#import "UICheckBoxButton.h"
#import "TLChanceListViewController.h"

@interface TLReaderViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, retain) IBOutlet UITextField *businessName;
@property (nonatomic, retain) IBOutlet UITextField *contactPerson;
@property (nonatomic, retain) IBOutlet UITextField *contactPhone;
@property (nonatomic, retain) IBOutlet UITextField *detailAdress;
@property (nonatomic, retain) IBOutlet UIButton *license;
@property (nonatomic, retain) IBOutlet UIButton *head;
@property (nonatomic, retain) IBOutlet UIButton *locale;
@property (nonatomic, retain)IBOutlet UIButton *province;
@property (nonatomic, retain)NSString *pro;
@property (nonatomic, retain)NSString *city;
@property (nonatomic, retain)NSString *district;

@property int tag1;
@property int tag2;
@property int tag3;
@property int tag;

@property (nonatomic,retain) NSMutableDictionary *allPhoto;

-(IBAction) button_click:(id)sender;
-(IBAction)save:(id)sender;
-(IBAction)license_click:(id)sender;
-(IBAction)head_click:(id)sender;
-(IBAction)locale_click:(id)sender;
-(IBAction)textFieldDone:(id)sender;
@end
