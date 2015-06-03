//
//  ParkStateTableViewController.m
//  Coaster Creds
//
//  Created by Mike Fudge on 19/05/2015.
//  Copyright (c) 2015 Mike Fudge. All rights reserved.
//

#import "ParkStateTableViewController.h"
#import "CoreDataStack.h"
#import "ParkContinentTableViewCell.h"
#import "ParkListTableViewController.h"

@interface ParkStateTableViewController ()

@property (strong, nonatomic) NSArray *states;
@property (strong, nonatomic) NSString *selectedState;

@end

@implementation ParkStateTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = _country;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self getStates];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_states count];
}

- (ParkContinentTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ParkContinentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.continentLabel.text = [_states objectAtIndex:indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedState = [_states objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"parksInState" sender:self];
}

#pragma mark - Core Data

- (void)getStates {
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Park" inManagedObjectContext:coreDataStack.managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"country LIKE %@", _country];
    [request setEntity:entity];
    [request setPredicate:predicate];
    NSArray *result = [coreDataStack.managedObjectContext executeFetchRequest:request error:nil];
    // Get unique states
    NSArray *distinctStates = [result valueForKeyPath:@"@distinctUnionOfObjects.state"];
    // Order states alphabetically
    _states = [distinctStates sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"parksInState"]) {
        ParkListTableViewController *parkListViewController = segue.destinationViewController;
        parkListViewController.country = _country;
        parkListViewController.state = _selectedState;
        parkListViewController.isAllParks = NO;
    }
}


@end
