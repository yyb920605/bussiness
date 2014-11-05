//
//  TLBranchList.m
//  商机转介
//
//  Created by mac on 14-10-28.
//  Copyright (c) 2014年 allinpay. All rights reserved.
//

#import "TLBranchList.h"

@interface TLBranchList ()

@end

@implementation TLBranchList

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"选择分行"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.branchList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *branch = [self.branchList objectAtIndex:indexPath.row];
    NSString *branchName = [branch objectForKey:@"name"];
    
    NSString *SimpleTableIdentifier = @"branchListtt";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             
                             SimpleTableIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                
                                      reuseIdentifier: SimpleTableIdentifier];
        
    }
    
    [cell.textLabel setText:branchName];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *bank = [self.branchList objectAtIndex:indexPath.row];
    NSString *num = [bank objectForKey:@"num"];
    
    self.branch = [bank objectForKey:@"num"];
    [tooles showHUD:@"正在加载支行行列表。。。"];
    TLAppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    NSString *urlstr = [NSString stringWithFormat:@"%@/%@",myDelegate.URL,@"subBranchList"];
    NSURL *myurl = [NSURL URLWithString:urlstr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:myurl];
    
    [request setPostValue:num forKey:@"branchNum"];
    
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(GetResult:)];
    [request setDidFailSelector:@selector(GetErr:)];
    [request startAsynchronous];
}

-(void)GetResult:(ASIHTTPRequest *)request{
    //接受字符串集
    [tooles removeHUD];
    NSError *error;
    NSString *str = [request responseString];
    [str UTF8String];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *all= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    NSArray *loginJson = [all objectForKey:@"androidAction"];
    NSDictionary *branch= [loginJson objectAtIndex:0];
    
    NSArray *subBranchList = [branch objectForKey:@"branchList"];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"IPhone4MainStoryboard" bundle:nil ];
    TLSubBranchList *mybranch = [storyboard instantiateViewControllerWithIdentifier:@"subBranchList"];
    
    [mybranch setSubBranchList:subBranchList];
    [mybranch setBank:self.bank];
    [mybranch setBranch:self.branch];
    
    [self.navigationController pushViewController:mybranch animated:YES];
    
}
- (void) GetErr:(ASIHTTPRequest *)request{
    
    [tooles removeHUD];
    
    [tooles MsgBox:@"网络错误,连接不到服务器"];
}

@end
