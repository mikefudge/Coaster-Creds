//
//  ParkListOptionsTableViewController.m
//  Coaster Creds
//
//  Created by Mike Fudge on 28/05/2015.
//  Copyright (c) 2015 Mike Fudge. All rights reserved.
//

#import "ParkListOptionsTableViewController.h"
#import "ParkContinentTableViewController.h"
#import "ParkListTableViewController.h"
#import "ParkContinentTableViewCell.h"

@interface ParkListOptionsTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *regionLabel;
@property (weak, nonatomic) IBOutlet UILabel *allLabel;

@end

@implementation ParkListOptionsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    _regionLabel.textColor = [UIColor blackColor];
    _allLabel.textColor = [UIColor blackColor];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        _regionLabel.textColor = [UIColor whiteColor];
    } else if (indexPath.row == 1) {
        _allLabel.textColor = [UIColor whiteColor];
    }
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        _regionLabel.textColor = [UIColor blackColor];
    } else if (indexPath.row == 1) {
        _allLabel.textColor = [UIColor blackColor];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        _regionLabel.textColor = [UIColor whiteColor];
        [self performSegueWithIdentifier:@"region" sender:self];
    } else if (indexPath.row == 1) {
        _allLabel.textColor = [UIColor whiteColor];
        [self performSegueWithIdentifier:@"allParks" sender:self];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"region"]) {
        // ParkContinentTableViewController *parkContinentTableViewController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:@"allParks"]) {
        ParkListTableViewController *parkListViewController = segue.destinationViewController;
        parkListViewController.isAllParks = YES;
    }
}

@end
