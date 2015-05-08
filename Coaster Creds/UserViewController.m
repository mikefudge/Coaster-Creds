//
//  UserViewController.m
//  Coaster Creds
//
//  Created by Mike Fudge on 08/05/2015.
//  Copyright (c) 2015 Mike Fudge. All rights reserved.
//

#import "UserViewController.h"
#import "UICountingLabel.h"

@interface UserViewController ()

@property (weak, nonatomic) IBOutlet UICountingLabel *countLabel;

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    
    _countLabel.format = @"%d";
    [_countLabel countFrom:0 to:64 withDuration:3.0f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}









@end
