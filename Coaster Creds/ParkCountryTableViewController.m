//
//  ParkCountryTableViewController.m
//  Coaster Creds
//
//  Created by Mike Fudge on 17/05/2015.
//  Copyright (c) 2015 Mike Fudge. All rights reserved.
//

#import "ParkCountryTableViewController.h"
#import "ParkContinentTableViewCell.h"
#import "ParkStateTableViewController.h"

@interface ParkCountryTableViewController ()

@property (strong, nonatomic) NSString *selectedCountry;

@end

@implementation ParkCountryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = _continent;

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
    return [_countries count];
}


- (ParkContinentTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ParkContinentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.continentLabel.text = [_countries objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedCountry = [_countries objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"statesInCountry" sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"statesInCountry"]) {
        ParkStateTableViewController *parkStateViewController = segue.destinationViewController;
        parkStateViewController.country = _selectedCountry;
    }
}


@end
