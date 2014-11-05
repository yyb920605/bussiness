//
//  TLChanceListController.m
//  商机转介
//
//  Created by mac on 14-4-22.
//  Copyright (c) 2014年 allinpay. All rights reserved.
//

#import "TLChanceListController.h"

@interface TLChanceListController ()

@end

@implementation TLChanceListController

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
    return [self.businessList count]+1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == [self.businessList count]){
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = @"查看更多";
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
        return cell;
    }else{
        TLChanceListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chanceList"];
        NSDictionary *dic = [self.businessList objectAtIndex:indexPath.row];
        cell.businessName.text = [dic objectForKey:@"businessName"];
        cell.status.text = [dic objectForKey:@"status"];
        if([[dic objectForKey:@"status"] isEqualToString:@"调度审核"]){
            [cell.myImage setImage:[UIImage imageNamed:@"正在签约.png"] forState:UIControlStateNormal];
        }
        if([[dic objectForKey:@"status"] isEqualToString:@"正在签约"]){
            [cell.myImage setImage:[UIImage imageNamed:@"正在签约.png"] forState:UIControlStateNormal];
        }
        if([[dic objectForKey:@"status"] isEqualToString:@"正常结束"]){
            [cell.myImage setImage:[UIImage imageNamed:@"已完成.png"] forState:UIControlStateNormal];
        }
    cell.address.text = [dic objectForKey:@"address"];
    cell.person.text = [NSString stringWithFormat:@"%@(%@)",[dic objectForKey:@"person"],[dic objectForKey:@"phone"]];
    return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == [self.businessList count]){
        if([self.businessList count]==self.totalRecords){
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
    
}
-(void)loadMore
{
    self.currentPage++;
    NSString *page = [NSString stringWithFormat:@"%d",self.currentPage];
    [tooles showHUD:@"稍等"];
    TLAppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    NSString *urlstr = [NSString stringWithFormat:@"%@/%@",myDelegate.URL,@"myProcessList"];
    NSURL *myurl = [NSURL URLWithString:urlstr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:myurl];
    
    [request setPostValue:@"IOS" forKey:@"phoneType"];
    [request setPostValue:myDelegate.loginName forKey:@"userLoginId"];
    [request setPostValue:page forKey:@"page"];
    [request setPostValue:self.orderStatus forKey:@"orderStatus"];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(GetResult:)];
    [request setDidFailSelector:@selector(GetErr:)];
    [request startAsynchronous];
    
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
    NSArray *array = [all objectForKey:@"loginJson"];
    NSDictionary *map = [array objectAtIndex:0];
    NSArray *loginJson = [map objectForKey:@"content"];
    NSMutableArray *more=[[NSMutableArray alloc] init];
    for(int i=0;i<[loginJson count];i++){
        [more addObject:[loginJson objectAtIndex:i]];
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
        [self.businessList addObject:[data objectAtIndex:i]];
    }
    NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:10];
    for (int ind = 0; ind < [data count]; ind++) {
        NSIndexPath    *newPath =  [NSIndexPath indexPathForRow:[self.businessList indexOfObject:[data objectAtIndex:ind]] inSection:0];
        [insertIndexPaths addObject:newPath];
    }
    [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView endUpdates];
    // [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
    
}

@end
