//
//  ParkListTableViewController.m
//  Coaster Creds
//
//  Created by Mike Fudge on 11/04/2015.
//  Copyright (c) 2015 Mike Fudge. All rights reserved.
//

#import "ParkListTableViewController.h"
#import "CoasterViewController.h"
#import "ParkListTableViewCell.h"
#import "CoreDataStack.h"
#import "Park.h"

#import <CoreData/CoreData.h>

@interface ParkListTableViewController () <NSFetchedResultsControllerDelegate, UISearchBarDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) Park *selectedPark;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray *resultsArray;

@end

@implementation ParkListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_isAllParks) {
        self.navigationItem.title = @"All Parks";
    } else {
        self.navigationItem.title = _state;
    }
    
    // Perform initial fetch with no search
    [self filter:@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (NSString *)formatStringForNumber:(long)number {
    NSString *string = [[NSString alloc] init];
    if (number == 0) {
        string = @"No coasters in park";
    } else if (number == 1) {
        string = @"1 coaster in park";
    } else {
        string = [NSString stringWithFormat:@"%lu coasters in park", number];
    }
    return string;
}

#pragma mark - Table View Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _resultsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ParkListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    Park *park = [_resultsArray objectAtIndex:indexPath.row];
    // Setup labels
    cell.park = park;
    cell.parkNameLabel.text = park.name;
    cell.numCoastersLabel.text = [self formatStringForNumber:[park.coasters count]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedPark = [_resultsArray objectAtIndex:indexPath.row];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"coastersInPark" sender:self];
    });
}

#pragma mark - Core Data

- (void)filter:(NSString *)text {
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Park" inManagedObjectContext:coreDataStack.managedObjectContext];
    fetchRequest.entity = entity;
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    // If coming from "browse all parks"..
    if (_isAllParks) {
        // If using search..
        if (text.length > 0) {
            // Filter all parks based on search, [c] = case insensitive
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[c] %@", text];
            fetchRequest.predicate = predicate;
        }
    }
    // If coming from "all parks in region"..
    else {
        // If using search..
        if (text.length > 0) {
            // Filter parks in region based on search
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(name CONTAINS[c] %@) AND (state LIKE %@ && country LIKE %@)", text, _state, _country];
            fetchRequest.predicate = predicate;
        } else {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(state LIKE %@ && country LIKE %@)", _state, _country];
            fetchRequest.predicate = predicate;
        }
    }
    NSError *error;
    NSArray *results = [coreDataStack.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    _resultsArray = [[NSMutableArray alloc] initWithArray:results];
    [self.tableView reloadData];
}

#pragma mark - Search Bar Delegate Methods

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)text {
    [self filter:text];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [self filter:searchBar.text];
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"coastersInPark"]) {
        CoasterViewController *coasterTableViewController = segue.destinationViewController;
        coasterTableViewController.hidesBottomBarWhenPushed = YES;
        coasterTableViewController.park = _selectedPark;
    }
}

@end
