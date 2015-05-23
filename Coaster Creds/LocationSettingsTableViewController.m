//
//  LocationSettingsTableViewController.m
//  Coaster Creds
//
//  Created by Mike Fudge on 20/05/2015.
//  Copyright (c) 2015 Mike Fudge. All rights reserved.
//

#import "LocationSettingsTableViewController.h"
#import "SearchDistanceTableViewController.h"
#import "HomeViewController.h"

@interface LocationSettingsTableViewController ()

@property (strong, nonatomic) NSNumber *searchDistance;
@property (weak, nonatomic) IBOutlet UITableViewCell *searchDistanceCell;

@end

@implementation LocationSettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    _searchDistance = [[NSUserDefaults standardUserDefaults] objectForKey:@"searchDistance"];
    if ([_searchDistance intValue] == 1) {
        _searchDistanceCell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%@ mile", _searchDistance];
    } else {
        _searchDistanceCell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%@ miles", _searchDistance];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    UIViewController *vc = self.navigationController.topViewController;
    if ([HomeViewController class] == [vc class])
    {
        [self performSegueWithIdentifier:@"home" sender:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self performSegueWithIdentifier:@"searchDistance" sender:self];
    }
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //SearchDistanceTableViewController *controller = segue.destinationViewController;
    
    
    
    
}


@end
