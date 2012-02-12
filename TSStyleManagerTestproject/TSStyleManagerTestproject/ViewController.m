//
//  ViewController.m
//  TSStyleManagerTestproject
//
//  Created by Daan van Hasselt on 09-02-12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "GeneratedExtensions.h"

@implementation ViewController

#pragma mark - View lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];
    
//    // Current    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
//    label.text = @"testText";
//    label.font = [UIFont fontWithName:@"MyriadPro-Regular" size:33];
//    label.textColor = [UIColor colorWithRed:0.1 green:0.8 blue:0.2 alpha:1.0];
//    label.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
//    label.shadowOffset = CGSizeMake(0,1);
//    [self.view addSubview:label];
//
//    
//    // Possibility 1
//    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 200, 100) 
//                                           andColor:[UIColor Greenish] 
//                                            andFont:[UIFont Myr33] 
//                                          andShadow:[TSShadow DarkShadow]];
//    label2.text = @"testText";
//    [self.view addSubview:label2];
    
    // Possibility 2
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 100) andStyle:[TSStyle style1]];
    label1.text = @"testText";
    [self.view addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 200, 100) andStyle:[TSStyle style2]];
    label2.text = @"testText";
    [self.view addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(400, 0, 200, 100) andStyle:[TSStyle style3]];
    label3.text = @"testText";
    [self.view addSubview:label3];
}


@end
