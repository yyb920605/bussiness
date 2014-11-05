//
//  TLShowImageViewController.m
//  商机转介
//
//  Created by mac on 14-4-13.
//  Copyright (c) 2014年 allinpay. All rights reserved.
//

#import "TLShowImageViewController.h"

@interface TLShowImageViewController ()

@end

@implementation TLShowImageViewController

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
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *path = [NSString stringWithFormat:@"%@/%@/%@.png",documentDirectory,@"opportunity",self.ImageName];
    NSLog(@"path==%@",path);
    [self.ImageView setImage:[UIImage imageWithContentsOfFile:path]];
    // Do any additional setup after loading the view.
}
-(IBAction)click:(id)sender{
    //上传照片
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
