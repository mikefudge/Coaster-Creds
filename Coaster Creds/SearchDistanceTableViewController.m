//
//  SearchDistanceTableViewController.m
//  Coaster Creds
//
//  Created by Mike Fudge on 20/05/2015.
//  Copyright (c) 2015 Mike Fudge. All rights reserved.
//

#import "SearchDistanceTableViewController.h"

#define NUMBER_OF_OPTIONS 7

@interface SearchDistanceTableViewController ()

@property (strong, nonatomic) NSArray *distances;
@property int selectedRow;
@property (strong, nonatomic) NSString *grammar;

@end

@implementation SearchDistanceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _distances = @[@1, @5, @10, @25, @50, @100, @200];
    int indexValue = [_distances indexOfObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"searchDistance"]];
    _selectedRow = indexValue;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSUserDefaults standardUserDefaults] setObject:([_distances objectAtIndex:_selectedRow]) forKey:@"searchDistance"];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
    return NUMBER_OF_OPTIONS;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        _grammar = @"mile";
    } else {
        _grammar = @"miles";
    }
    cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@ %@", [_distances objectAtIndex:indexPath.row], _grammar];
    
    // Display checkmark next to selected cell
    if(indexPath.row == _selectedRow) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedRow = indexPath.row;
    [self.tableView reloadData];
}

@end
