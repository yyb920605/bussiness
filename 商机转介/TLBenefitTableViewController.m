//
//  TLBenefitTableViewController.m
//  商机转介
//
//  Created by mac on 14-9-3.
//  Copyright (c) 2014年 allinpay. All rights reserved.
//

#import "TLBenefitTableViewController.h"

@interface TLBenefitTableViewController ()

@end

@implementation TLBenefitTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.currentPage = 1;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.benefitList count]+1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == [self.benefitList count]){
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = @"查看更多";
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
        return cell;
    }else{
        TLBenefitCell *cell = [tableView dequeueReusableCellWithIdentifier:@"benefitCell"];
        NSDictionary *dic = [self.benefitList objectAtIndex:indexPath.row];
        cell.businessName.text = [dic objectForKey:@"businessName"];
        cell.benefit.text = [dic objectForKey:@"profit"];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == [self.benefitList count]){
        if([self.benefitList count]==self.totalRecords){
            UITableViewCell *loadMoreCell=[tableView cellForRowAtIndexPath:indexPath];
            loadMoreCell.textLabel.text=[NSString stringWithFormat:@"共%d条数据，已全部加载",self.totalRecords];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            return;
        }else{
            UITableViewCell *loadMoreCell=[tableView cellForRowAtIndexPath:indexPath];
            loadMoreCell.textLabel.text=@"加载中 …";
            [self loadMore];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            return;
        }
        
    }
    else{
        NSDictionary *dic = [self.benefitList objectAtIndex:indexPath.row];
        NSString *businessInfoId = [dic objectForKey:@"businessInfoId"];
        self.businessInfoId  = businessInfoId;
        
        TLAppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
        NSString *urlstr = [NSString stringWithFormat:@"%@/%@",myDelegate.URL,@"bsProfit"];
        NSURL *myurl = [NSURL URLWithString:urlstr];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:myurl];
        
        [request setPostValue:@"IOS" forKey:@"phoneType"];
        [request setPostValue:myDelegate.loginName forKey:@"userLoginId"];
        [request setPostValue:businessInfoId forKey:@"businessInfoId"];
        [request setPostValue:@"month" forKey:@"profitType"];
        
        [request setDelegate:self];
        [request setDidFinishSelector:@selector(GetResult2:)];
        [request setDidFailSelector:@selector(GetErr2:)];
        [request startAsynchronous];
        request = nil;
        
    }
    
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
    UIStoryboard *storyboard=nil;
    if(iPhone5){
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil ];
    }else{
     storyboard = [UIStoryboard storyboardWithName:@"IPhone4MainStoryboard" bundle:nil ];
    }
    TLBusinessProfit *viewcontroller =[storyboard instantiateViewControllerWithIdentifier:@"businessProfit"];
    [viewcontroller setMaxValue:[maxValue floatValue]];
    [viewcontroller setPoints:points];
    [viewcontroller setX_labels:X_labels];
    [viewcontroller setNum:[profitList count]];
    [viewcontroller setBusinessName:businessName];
    [viewcontroller setRecent:recent];
    [viewcontroller setSix:six];
    [viewcontroller setBusinessInfoId:self.businessInfoId];
    [self.navigationController pushViewController:viewcontroller animated:YES];}

- (void) GetErr2:(ASIHTTPRequest *)request{
    [tooles MsgBox:@"网络错误,连接不到服务器"];
}

-(void)loadMore
{
    self.currentPage++;
    NSString *page = [NSString stringWithFormat:@"%d",self.currentPage];
    [tooles showHUD:@"稍等"];
    TLAppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    NSString *urlstr = [NSString stringWithFormat:@"%@/%@",myDelegate.URL,@"bsProfitList"];
    NSURL *myurl = [NSURL URLWithString:urlstr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:myurl];
    
    [request setPostValue:@"IOS" forKey:@"phoneType"];
    [request setPostValue:myDelegate.loginName forKey:@"userLoginId"];
    [request setPostValue:page forKey:@"page"];

    [request setDelegate:self];
    [request setDidFinishSelector:@selector(GetResult:)];
    [request setDidFailSelector:@selector(GetErr:)];
    [request startAsynchronous];
    request = nil;
    //    NSMutableArray *more=[[NSMutableArray alloc] init];
    //    for (int i=0; i<10; i++) {
    //        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    //        [dic setObject:[NSString stringWithFormat:@"gkb+%d",i] forKey:@"name"];
    //        [dic setObject:[NSString stringWithFormat:@"123456+%d",i] forKey:@"phone"];
    //        [dic setObject:@"2014-6-11" forKey:@"date"];
    //        [more addObject:dic];
    //    }
    //    //加载你的数据
    //    [self appendTableWith:more];
}
-(void)GetResult:(ASIHTTPRequest *)request{
    //接受字符串集
    [tooles removeHUD];
    NSError *error;
    NSString *str = [request responseString];
    [str UTF8String];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *all= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    NSArray *androidAction = [all objectForKey:@"androidAction"];
    NSDictionary *androidMap = [androidAction objectAtIndex:0];
    NSMutableArray *benefitList = [androidMap objectForKey:@"businessInfo"];
    NSMutableArray *more=[[NSMutableArray alloc] init];
    for(int i=0;i<[benefitList count];i++){
        [more addObject:[benefitList objectAtIndex:i]];
    }
    [self appendTableWith:more];
}

- (void) GetErr:(ASIHTTPRequest *)request{
    
    [tooles removeHUD];
    
    [tooles MsgBox:@"网络错误,连接不到服务器"];
}

-(void) appendTableWith:(NSMutableArray *)data
{
    for (int i=0;i<[data count];i++) {
        [self.benefitList addObject:[data objectAtIndex:i]];
    }
    NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:10];
    for (int ind = 0; ind < [data count]; ind++) {
        NSIndexPath    *newPath =  [NSIndexPath indexPathForRow:[self.benefitList indexOfObject:[data objectAtIndex:ind]] inSection:0];
        [insertIndexPaths addObject:newPath];
    }
    [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView endUpdates];
    // [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
    
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
