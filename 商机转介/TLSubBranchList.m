//
//  TLSubBranchList.m
//  商机转介
//
//  Created by mac on 14-10-28.
//  Copyright (c) 2014年 allinpay. All rights reserved.
//

#import "TLSubBranchList.h"

@interface TLSubBranchList ()

@end

@implementation TLSubBranchList

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"选择支行"];
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
    return [self.subBranchList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *branch = [self.subBranchList objectAtIndex:indexPath.row];
    NSString *branchName = [branch objectForKey:@"name"];
    
    NSString *SimpleTableIdentifier = @"subBranchListtt";
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
    
    NSDictionary *bank = [self.subBranchList objectAtIndex:indexPath.row];
    NSString *name = [bank objectForKey:@"num"];
    
    self.subBranch = name;
    
    NSString *bankInfo = [NSString stringWithFormat:@"%@%@%@",self.bank,self.branch,self.subBranch];
    TLRegisterConfirmViewController *confirm = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-4];
    [confirm.bankchosed setText:bankInfo];
    [confirm setBankName:self.bank];
    [confirm setBranch:self.branch];
    [confirm setSubBranch:self.subBranch];
    
    [self.navigationController popToViewController:confirm animated:YES];
}

@end
