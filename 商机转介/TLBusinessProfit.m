//
//  TLBusinessProfit.m
//  商机转介
//
//  Created by mac on 14-9-5.
//  Copyright (c) 2014年 allinpay. All rights reserved.
//

#import "TLBusinessProfit.h"

@interface TLBusinessProfit ()

@end

@implementation TLBusinessProfit

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
    
    [self.navigationItem setTitle:@"应得存款明细"];
    
    //label控制
    [self.bnlabel setText:self.businessName];
    self.mw.text = self.six;
    self.mw.font = [UIFont systemFontOfSize:30.0];
    self.mwlabel.text = @"该商户贡献存款（近六月均值）";
    self.mwlabel.font = [UIFont systemFontOfSize:13.0];
    self.lmw.text = [NSString stringWithFormat:@"%@(元)",self.recent];
    self.lmw.font = [UIFont systemFontOfSize:40.0];
    self.lmwlabel.text = @"该商户贡献存款（月日均）";
    self.lmwlabel.font = [UIFont systemFontOfSize:13.0];
    [self.month setImage:[UIImage imageNamed:@"buttony.png"] forState:UIControlStateNormal];
    [self.week setImage:[UIImage imageNamed:@"buttonb.png"] forState:UIControlStateNormal];
    
    //趋势图控制
    [self loadchart];
}
-(void)loadchart{
    
    if(iPhone5){
        lineChartView = [[PCLineChartView alloc] initWithFrame:CGRectMake(10,290,[self.view bounds].size.width-20,200)];
        [lineChartView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    }
    else{
        lineChartView = [[PCLineChartView alloc] initWithFrame:CGRectMake(10,240,[self.view bounds].size.width-20,180)];
        [lineChartView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    }
    lineChartView.minValue = 0;
    lineChartView.maxValue = self.maxValue*1.2;
    if(self.num<5){
        lineChartView.interval = lineChartView.maxValue/5;
    }else{
        lineChartView.interval = lineChartView.maxValue/(self.num+1);
    }
    [self.view addSubview:lineChartView];
    
    
    NSMutableArray *components = [NSMutableArray array];
    //NSArray *points = [NSArray arrayWithObjects:@"12",@"15",@"37",@"35",@"48", nil];
    //NSMutableArray *X_labels= [NSMutableArray arrayWithObjects:@"1月",@"2月",@"3月",@"4月",@"5月",nil];
    
    PCLineChartViewComponent *component = [[PCLineChartViewComponent alloc] init];
    [component setTitle:self.businessName];
    [component setPoints:[NSArray arrayWithArray:self.points]];
    [component setShouldLabelValues:NO];
    
    NSInteger i=1;
    if (i==0)
    {
        [component setColour:PCColorYellow];
    }
    else if (i==1)
    {
        [component setColour:PCColorGreen];
    }
    else if (i==2)
    {
        [component setColour:PCColorOrange];
    }
    else if (i==3)
    {
        [component setColour:PCColorRed];
    }
    else if (i==4)
    {
        [component setColour:PCColorBlue];
    }
    
    [components addObject:component];
    [lineChartView setComponents:components];
    [lineChartView setXLabels:self.X_labels];
    
    // Do any additional setup after loading the view.
}
-(IBAction)monthclick:(id)sender{
    TLAppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    NSString *urlstr = [NSString stringWithFormat:@"%@/%@",myDelegate.URL,@"bsProfit"];
    NSURL *myurl = [NSURL URLWithString:urlstr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:myurl];
    
    [request setPostValue:@"IOS" forKey:@"phoneType"];
    [request setPostValue:myDelegate.loginName forKey:@"userLoginId"];
    [request setPostValue:self.businessInfoId forKey:@"businessInfoId"];
    [request setPostValue:@"month" forKey:@"profitType"];
    
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(GetResult2:)];
    [request setDidFailSelector:@selector(GetErr2:)];
    [request startAsynchronous];
    request = nil;

}
-(void)GetResult2:(ASIHTTPRequest *)request{
    //接受字符串集
    NSError *error;
    NSString *str = [request responseString];
    [str UTF8String];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *all= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    NSArray *androidAction = [all objectForKey:@"androidAction"];
    NSDictionary *androidMap = [androidAction objectAtIndex:0];
    NSMutableArray *profitList = [androidMap objectForKey:@"profitList"];
    NSString *maxValue = [androidMap objectForKey:@"maxMonthAvgProfit"];
    NSString *recent = [androidMap objectForKey:@"recentMonthAvgProfit"];
    NSString *six = [androidMap objectForKey:@"sixMonthAvgProfit"];
    NSString *businessName= [androidMap objectForKey:@"businessName"];
    
    NSMutableArray *points = [NSMutableArray array];
    NSMutableArray *X_labels = [NSMutableArray array];
    int i=0;
    
    for(NSDictionary *dic in profitList){
        i++;
        if(i==[profitList count])
        {
            [X_labels addObject:[NSString stringWithFormat:@"%@(月)",[dic objectForKey:@"index"]]];
        }
        else{
            [X_labels addObject:[dic objectForKey:@"index"]];
        }
        [points addObject:[dic objectForKey:@"profit"]];
        
    }
    self.maxValue = [maxValue floatValue];
    [self setPoints:points];
    [self setX_labels:X_labels];
    [self setNum:[profitList count]];
    [self setBusinessName:businessName];
    [self setRecent:recent];
    [self setSix:six];
    [lineChartView removeFromSuperview];
    
    //label控制
    self.mw.text = self.six;
    self.mw.font = [UIFont systemFontOfSize:30.0];
    self.mwlabel.text = @"该商户贡献存款（近六月均值）";
    self.mwlabel.font = [UIFont systemFontOfSize:13.0];
    self.lmw.text = [NSString stringWithFormat:@"%@(元)",self.recent];
    self.lmw.font = [UIFont systemFontOfSize:40.0];
    self.lmwlabel.text = @"该商户贡献存款（月日均）";
    self.lmwlabel.font = [UIFont systemFontOfSize:13.0];
    [self.month setImage:[UIImage imageNamed:@"buttony.png"] forState:UIControlStateNormal];
    [self.week setImage:[UIImage imageNamed:@"buttonb.png"] forState:UIControlStateNormal];

    //趋势图
    [self loadchart];
}

- (void) GetErr2:(ASIHTTPRequest *)request{
    [tooles MsgBox:@"网络错误,连接不到服务器"];
}

-(IBAction)weekclick:(id)sender{
    TLAppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    NSString *urlstr = [NSString stringWithFormat:@"%@/%@",myDelegate.URL,@"bsProfit"];
    NSURL *myurl = [NSURL URLWithString:urlstr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:myurl];
    
    [request setPostValue:@"IOS" forKey:@"phoneType"];
    [request setPostValue:myDelegate.loginName forKey:@"userLoginId"];
    [request setPostValue:self.businessInfoId forKey:@"businessInfoId"];
    [request setPostValue:@"week" forKey:@"profitType"];
    
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(GetResult3:)];
    [request setDidFailSelector:@selector(GetErr3:)];
    [request startAsynchronous];
    request = nil;

}
-(void)GetResult3:(ASIHTTPRequest *)request{
    //接受字符串集
    NSError *error;
    NSString *str = [request responseString];
    [str UTF8String];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *all= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    NSArray *androidAction = [all objectForKey:@"androidAction"];
    NSDictionary *androidMap = [androidAction objectAtIndex:0];
    NSMutableArray *profitList = [androidMap objectForKey:@"profitList"];
    NSString *maxValue = [androidMap objectForKey:@"maxWeekProfit"];
    NSString *recent = [androidMap objectForKey:@"recentWeekAvgProfit"];
    NSString *six = [androidMap objectForKey:@"sixWeekAvgProfit"];
    NSString *businessName= [androidMap objectForKey:@"businessName"];
    
    NSMutableArray *points = [NSMutableArray array];
    NSMutableArray *X_labels = [NSMutableArray array];
    int i=0;
    
    for(NSDictionary *dic in profitList){
        i++;
        if(i==[profitList count])
        {
            [X_labels addObject:[NSString stringWithFormat:@"%@(周)",[dic objectForKey:@"index"]]];
        }
        else{
            [X_labels addObject:[dic objectForKey:@"index"]];
        }
        [points addObject:[dic objectForKey:@"profit"]];
        
    }
    self.maxValue = [maxValue floatValue];
    [self setPoints:points];
    [self setX_labels:X_labels];
    [self setNum:[profitList count]];
    [self setBusinessName:businessName];
    [self setRecent:recent];
    [self setSix:six];
    [lineChartView removeFromSuperview];
    
    //label控制
    self.mw.text = self.six;
    self.mw.font = [UIFont systemFontOfSize:30.0];
    self.mwlabel.text = @"该商户贡献存款（近六周均值）";
    self.mwlabel.font = [UIFont systemFontOfSize:13.0];
    self.lmw.text = [NSString stringWithFormat:@"%@(元)",self.recent];
    self.lmw.font = [UIFont systemFontOfSize:40.0];
    self.lmwlabel.text = @"该商户贡献存款（周日均）";

    self.lmwlabel.font = [UIFont systemFontOfSize:13.0];
    [self.month setImage:[UIImage imageNamed:@"buttonb.png"] forState:UIControlStateNormal];
    [self.week setImage:[UIImage imageNamed:@"buttony.png"] forState:UIControlStateNormal];
    
    //趋势图
    [self loadchart];
}

- (void) GetErr3:(ASIHTTPRequest *)request{
    [tooles MsgBox:@"网络错误,连接不到服务器"];
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
