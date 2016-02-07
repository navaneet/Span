//
//  CustomNavigationController.m
//  SpanTest
//
//  Created by Nav on 2/7/16.
//  Copyright © 2016 Navaneet Sarma. All rights reserved.
//

#import "CustomNavigationController.h"

@interface CustomNavigationController ()

@end

@implementation CustomNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)shouldAutorotate {
    
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
  
 return UIInterfaceOrientationMaskPortrait;

}

@end
