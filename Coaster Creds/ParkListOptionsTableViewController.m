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

@interface ParkListOptionsTableViewController ()

@end

@implementation ParkListOptionsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
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
        [self performSegueWithIdentifier:@"region" sender:self];
    } else if (indexPath.row == 1) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
