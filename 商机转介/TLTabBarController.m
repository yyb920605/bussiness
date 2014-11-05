//
//  TLTabBarController.m
//  商机转介
//
//  Created by yyb on 14-11-3.
//  Copyright (c) 2014年 allinpay. All rights reserved.
//

#import "TLTabBarController.h"

@interface TLTabBarController ()

@end

@implementation TLTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImage *img=[UIImage imageNamed:@"location1.png"];
    CGSize size=CGSizeMake(13, 20);
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage * scaledImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.faxianButton.image=scaledImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)faxian:(id)sender{
    UIStoryboard *storyboard=nil;
    if (iPhone5) {
        storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil ];
    }
    else{
        storyboard = [UIStoryboard storyboardWithName:@"IPhone4MainStoryboard" bundle:nil ];
    }
    if(!_myMapViewController){
        _myMapViewController = [storyboard instantiateViewControllerWithIdentifier:@"faxian" ];
        
    }
    [self.navigationController pushViewController:_myMapViewController animated:YES];

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
