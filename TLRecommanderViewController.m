//
//  TLRecommanderViewController.m
//  商机转介
//
//  Created by mac on 14-4-14.
//  Copyright (c) 2014年 allinpay. All rights reserved.
//

#import "TLRecommanderViewController.h"

@interface TLRecommanderViewController ()

@end

@implementation TLRecommanderViewController

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
    [self.navigationItem setTitle:@"我的朋友"];
    UIBarButtonItem *btn = [[UIBarButtonItem alloc]initWithTitle:@"统计" style:UIBarButtonItemStylePlain target:self action:@selector(count)];
    [self.navigationItem setRightBarButtonItem:btn];
}
-(void)count{
    NSString *s = [NSString stringWithFormat:@"您共有%d个推荐好友",self.totalRecords];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"统计" message:s delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
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
    return [self.recommanderList count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == [self.recommanderList count]){
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        if([self.recommanderList count]==0){
            cell.textLabel.text = @"暂时没有数据";
        }
        else if([self.recommanderList count]>19){
            cell.textLabel.text = @"查看更多";
        }

        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
        return cell;
    }else{
        TLRecommanderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TLRecommanderCell"];
        NSDictionary *dic = [self.recommanderList objectAtIndex:indexPath.row];
        if(![[dic objectForKey:@"name"] isKindOfClass:[NSNumber class]]){
            cell.name.text = [dic objectForKey:@"name"];
        }else{
            cell.name.text = @"未填写";
        }
        if(![[dic objectForKey:@"phone"] isKindOfClass:[NSNull class]]){
            NSString *s = [dic objectForKey:@"phone"];
            //s = [NSString stringWithFormat:@"%@%@",[s substringToIndex:7],@"****"];
            cell.phone.text =s;
        }else{
            cell.phone.text = @"未填写";
        }
        if(![[dic objectForKey:@"date"] isKindOfClass:[NSNull class]]){
        
            cell.date.text = [dic objectForKey:@"date"];
        
        }else{
            cell.date.text =@"未填写";
        }
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == [self.recommanderList count]){
        if([self.recommanderList count]==self.totalRecords){
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
    NSString *urlstr = [NSString stringWithFormat:@"%@/%@",myDelegate.URL,@"refereeList"];
    NSURL *myurl = [NSURL URLWithString:urlstr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:myurl];
    
    [request setPostValue:@"IOS" forKey:@"phoneType"];
    [request setPostValue:myDelegate.loginName forKey:@"userLoginId"];
    [request setPostValue:page forKey:@"page"];
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
    NSArray *array = [all objectForKey:@"androidAction"];
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
        [self.recommanderList addObject:[data objectAtIndex:i]];
    }
    NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:10];
    for (int ind = 0; ind < [data count]; ind++) {
        NSIndexPath    *newPath =  [NSIndexPath indexPathForRow:[self.recommanderList indexOfObject:[data objectAtIndex:ind]] inSection:0];
            [insertIndexPaths addObject:newPath];
    }
    [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView endUpdates];
   // [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
    
}
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
