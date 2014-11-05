//
//  TLBusinessController.h
//  TongLian
//
//  Created by mac on 13-9-11.
//  Copyright (c) 2013年 BoYunSen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHttpHeaders.h"
#import "TLAppDelegate.h"
#import "tooles.h"
#import "TLCompany.h"
#import "TLAllBusinessTableViewController.h"

@interface TLBusinessController : UIViewController

-(IBAction)button_click:(id)sender;

-(void)GetResult:(ASIHTTPRequest *)request;
-(void)GetErr:(ASIHTTPRequest *)request;
@end
