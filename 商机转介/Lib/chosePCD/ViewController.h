//
//  ViewController.h
//  picker
//
//  Created by Sylar on 12-9-14.
//  Copyright (c) 2012年 Sylar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLReaderViewController.h"

#define PROVINCE_COMPONENT  0
#define CITY_COMPONENT      1
#define DISTRICT_COMPONENT  2

@interface ViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>{
    UIPickerView *picker;
    UIButton *button;
    
    NSDictionary *areaDic;
    NSArray *province;
    NSArray *city;
    NSArray *district;
    
    NSString *selectedProvince;
}

- (void) buttobClicked: (id)sender;

@end
