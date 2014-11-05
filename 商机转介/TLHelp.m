//
//  TLHelp.m
//  TongLian
//
//  Created by mac on 13-11-7.
//  Copyright (c) 2013年 BoYunSen. All rights reserved.
//

#import "TLHelp.h"

@interface TLHelp_ ()

@end

@implementation TLHelp_

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"此功能尚未开通" message:nil delegate:self
                                         cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
    [alert show];
//    NSString *urlstr = [NSString stringWithFormat:@"http://10.88.1.55:8080/Api/BusinessOpportunity/queryAccount.do"];
//    NSURL *url = [NSURL URLWithString:urlstr];
//    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
//    TLAppDelegate *mydelegate = (TLAppDelegate *)[[UIApplication sharedApplication]delegate];
//    NSLog(@"accounntId=%@",mydelegate.accountId);
//    
//    [request setPostValue:mydelegate.accountId forKey:@"accountId"];
//    
//    [request setDelegate:self];
//    [request setDidFinishSelector:@selector(GetResult:)];
//    [request setDidFailSelector:@selector(GetErr:)];
//    [request startAsynchronous];

	// Do any additional setup after loading the view.
}
-(void)GetResult:(ASIHTTPRequest *)request{
    //接受字符串集
    [tooles removeHUD];
    NSError *error;
    NSString *str = [request responseString];
    [str UTF8String];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *all= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    NSString *responseCode = [all objectForKey:@"responseCode"];
    if([responseCode isEqualToString:@"00"]){
        NSString *virAccBalance= [all objectForKey:@"virAccBalance"];
        NSString *remainder = [NSString stringWithFormat:@"¥%@",virAccBalance];
        self.remainder.text = remainder;
    }else{
        [tooles MsgBox:@"查询帐户余额失败"];
    }   
}

- (void) GetErr:(ASIHTTPRequest *)request{
    [tooles removeHUD];
    [tooles MsgBox:@"网络错误,连接不到服务器"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
