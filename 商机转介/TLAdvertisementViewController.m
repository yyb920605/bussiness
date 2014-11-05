//
//  TLAdvertisementViewController.m
//  商机转介
//
//  Created by mac on 14-5-21.
//  Copyright (c) 2014年 allinpay. All rights reserved.
//

#import "TLAdvertisementViewController.h"

@interface TLAdvertisementViewController ()

@end

@implementation TLAdvertisementViewController

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
    //NSString *urlStr = [NSString stringWithFormat:@"http://61.163.100.203:5555/control/advertiseUI?advertiseId=%@&imageType=%@",self.advertiseID,@"WVGA"];
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.adUrl]];
    if (urlRequest != nil)
    {
        UIWebView *webViewTemp = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        [webViewTemp loadRequest:urlRequest];
        
        [self.view addSubview:webViewTemp];
    }

    // Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
