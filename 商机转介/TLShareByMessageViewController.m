//
//  TLShareByMessageViewController.m
//  商机转介
//
//  Created by mac on 14-5-7.
//  Copyright (c) 2014年 allinpay. All rights reserved.
//

#import "TLShareByMessageViewController.h"

@interface TLShareByMessageViewController ()

@end

@implementation TLShareByMessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(IBAction)sendmsg:(id)sender{
    TLAppDelegate *myDelegate = [[UIApplication sharedApplication]delegate];
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    NSString *bbody = [NSString stringWithFormat:@"%@,您好！通联商机转介系统注册地址为：http://61.163.100.203:5555/control/registerUI?parentId=%@，欢迎您的加入！",self.name.text,myDelegate.loginName];
    picker.body = bbody;
    //    picker.recipients = [NSArray arrayWithObject:@"15801345017"];
    picker.recipients = [NSArray arrayWithObjects:self.phone.text,nil];
    [self presentViewController:picker animated:YES completion:nil];
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MessageComposeResultCancelled:
            [tooles MsgBox:@"取消发送短信！"];
            break;
        case MessageComposeResultSent:
           [tooles MsgBox:@"短信发送成功！"];
            break;
        case MessageComposeResultFailed:
            [tooles MsgBox:@"短信发送失败！"];
            break;
        default:
            [tooles MsgBox:@"短信尚未发送！"];
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)textFieldDone:(id)sender{
    [sender resignFirstResponder];
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
