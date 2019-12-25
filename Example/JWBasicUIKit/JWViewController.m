//
//  JWViewController.m
//  JWBasicUIKit
//
//  Created by liujunwei2018 on 12/18/2019.
//  Copyright (c) 2019 liujunwei2018. All rights reserved.
//

#import "JWViewController.h"
#import <JWBasicUIKit.h>

@interface JWViewController ()

@end

@implementation JWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)actionSheetClick:(id)sender {
    JWActionSheet *sheet = [[JWActionSheet alloc] initCancelActionWithTitle:@"取消123" handler:^{
        NSLog(@"点击");
    }];
    [sheet addActionWithTitleArr:@[@"1", @"2", @"3"] handler:^(int index) {
        NSLog(@"click %d",index);
    }];
}

- (IBAction)alertActionClick:(id)sender {
    JWAlertAction *action = [[JWAlertAction alloc] init];
//    [action alertActionStyle:JWAlertActionStyleDefult message:@"123456" btnTitleArr:@[ @"确定"] btnTextColor:[UIColor blueColor] handler:^(int index) {
//
//    }];
    
//    [action alertActionStyle:JWAlertActionStyleDefult title:@"123" message:@"123456" btnTitleArr:@[@"确定"] btnTextColor:[UIColor blueColor] handler:^(int index) {
//
//    }];
//
//    [action alertActionStyle:JWAlertActionStyleCancel message:@"123" defultTitle:@"确定" defultHandler:^{
//
//    } cancelTitle:@"取消" cancelHandler:^{
//
//    }];
    
    [action alertActionStyle:JWAlertActionStyleCancel title:@"123" message:@"123456" defultTitle:@"确定" defultHandler:^{
        
    } cancelTitle:@"取消" cancelHandler:^{
        
    }];
}

- (IBAction)alertViewClick:(id)sender {
//    [JWAlertView jw_showWithTitle:@"哈哈哈" message:@"收到货范德萨发电话的撒很反感哈吉斯都放假哈是否" onDismiss:^{
//
//    }];
    
    [JWAlertView jw_showWithTitle:@"哈哈哈" message:@"2s后自动消失" delay:2.0 onDismiss:^{

    }];
    
    
//    [JWAlertView jw_showWithTitle:@"哈哈哈" message:@"按实际客户达" buttonsAndOnDismiss:@"确定", @"删除"];
}

@end
