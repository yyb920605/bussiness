//
//  TLChanceListViewController.m
//  商机转介
//
//  Created by mac on 14-4-22.
//  Copyright (c) 2014年 allinpay. All rights reserved.
//

#import "TLChanceListViewController.h"

@interface TLChanceListViewController ()

@end

@implementation TLChanceListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void) viewWillAppear{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    mytableview.dataSource = self;
    mytableview.delegate = self;
    [self.queue setImage:[UIImage imageNamed:self.imageName]];
    // Do any additional setup after loading the view.
}
-(IBAction)shcedule:(id)sender{
    self.orderStatus = @"SCHEDULE";
    self.myURL = @"myProcessList";
    [self.queue setImage:[UIImage imageNamed:@"成排2.png"]];
    [self list:@"SCHEDULE"];
}
-(IBAction)customer:(id)sender{
    self.orderStatus = @"CUSTOMER";
    self.myURL = @"myProcessList";
    [self.queue setImage:[UIImage imageNamed:@"成排3.png"]];
    [self list:@"CUSTOMER"];

}
-(IBAction)cend:(id)sender{
    self.orderStatus = @"BRFINISHED";
    self.myURL = @"myProcessList";
    [self.queue setImage:[UIImage imageNamed:@"成排4.png"]];
    [self list:@"BRFINISHED"];
}
-(IBAction)manage:(id)sender{
    self.orderStatus = @"CHANCEINPUT";
    self.myURL = @"myProcessList";
    [self.queue setImage:[UIImage imageNamed:@"成排1.png"]];
    [self list:@"CHANCEINPUT"];
}
-(void)list:(NSString *)status{
    [tooles showHUD:@"稍等"];
    self.currentPage = 1;
    TLAppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    NSString *urlstr = [NSString stringWithFormat:@"%@/%@",myDelegate.URL,self.myURL];
    NSURL *myurl = [NSURL URLWithString:urlstr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:myurl];
    
    [request setPostValue:@"IOS" forKey:@"phoneType"];
    [request setPostValue:myDelegate.loginName forKey:@"userLoginId"];
    [request setPostValue:status forKey:@"orderStatus"];
    [request setPostValue:@"1" forKey:@"page"];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(GetResult:)];
    [request setDidFailSelector:@selector(GetErr:)];
    [request startAsynchronous];
    request = nil;
}
-(void)GetResult:(ASIHTTPRequest *)request{
    //接受字符串集
    [tooles removeHUD];
    NSError *error;
    NSString *str = [request responseString];
    [str UTF8String];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *all= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    NSDictionary *map = [[all objectForKey:@"loginJson"] objectAtIndex:0];
    NSString *total = [map objectForKey:@"totalrecords"];
    
    NSMutableArray *bl = [NSMutableArray arrayWithArray:[map objectForKey:@"content"]];
    self.businessList = bl;
    self.totalRecords = [total integerValue];
    [mytableview reloadData];
}

- (void) GetErr:(ASIHTTPRequest *)request{
    
    [tooles removeHUD];
    
    [tooles MsgBox:@"网络错误,连接不到服务器"];
}


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
        if([self.businessList count]==0){
            cell.textLabel.text = @"暂时没有数据";
        }
        else if([self.businessList count]>10){
            cell.textLabel.text = @"查看更多";
        }

        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
        return cell;
    }else{
        TLChanceListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chanceList"];
        NSDictionary *dic = [self.businessList objectAtIndex:indexPath.row];
        cell.businessName.text = [dic objectForKey:@"businessName"];
        cell.status.text = [dic objectForKey:@"status"];
        cell.person.text = [dic objectForKey:@"person"];
        cell.phone.text = [dic objectForKey:@"phone"];
        if ([[dic objectForKey:@"status"] isEqualToString:@"商机录入"]){
            [cell.myImage setImage:[UIImage imageNamed:@"待审核.png"] forState:UIControlStateNormal];
            [cell.mytextLabel setText:@"待上传"];
        }
        if([[dic objectForKey:@"status"] isEqualToString:@"调度审核"]){
            [cell.myImage setImage:[UIImage imageNamed:@"审核.png"] forState:UIControlStateNormal];
            [cell.mytextLabel setText:@"调度审核"];
        }
        if([[dic objectForKey:@"status"] isEqualToString:@"正在签约"]){
            [cell.myImage setImage:[UIImage imageNamed:@"进行.png"] forState:UIControlStateNormal];
            [cell.mytextLabel setText:@"正在签约"];
        }
        if([[dic objectForKey:@"status"] isEqualToString:@"正常结束"]){
            [cell.myImage setImage:[UIImage imageNamed:@"完成.png"] forState:UIControlStateNormal];
            [cell.mytextLabel setText:@"正常结束"];
        }
        cell.address.text = [dic objectForKey:@"address"];
        //cell.person.text = [NSString stringWithFormat:@"%@(%@)",[dic objectForKey:@"person"],[dic objectForKey:@"phone"]];
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
    else{
        if([self.orderStatus isEqualToString:@"CHANCEINPUT"]||self.orderStatus==nil){
            UIStoryboard *storyboard=nil;
            if (iPhone5) {
                storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil ];
            }
            else{
                storyboard = [UIStoryboard storyboardWithName:@"IPhone4MainStoryboard" bundle:nil ];
            }
            TLChanceDetailViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"chanceDetail" ];
            [viewController setChance:[self.businessList objectAtIndex:indexPath.row]];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        else{
            UIAlertView *alerty = [[UIAlertView alloc]initWithTitle:@"正在处理当中" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alerty show];
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
    [request setDidFinishSelector:@selector(GetResult3:)];
    [request setDidFailSelector:@selector(GetErr3:)];
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
-(void)GetResult3:(ASIHTTPRequest *)request{
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

- (void) GetErr3:(ASIHTTPRequest *)request{
    
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
    [mytableview insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationBottom];
    [mytableview endUpdates];
    // [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
