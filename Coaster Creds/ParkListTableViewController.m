//
//  ParkListTableViewController.m
//  Coaster Creds
//
//  Created by Mike Fudge on 11/04/2015.
//  Copyright (c) 2015 Mike Fudge. All rights reserved.
//

#import "ParkListTableViewController.h"
#import "CoasterTableViewController.h"
#import "ParkListTableViewCell.h"
#import "CoreDataStack.h"
#import "Park.h"

#import <CoreData/CoreData.h>

@interface ParkListTableViewController () <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) Park *selectedPark;

@end

@implementation ParkListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = _state;
    [self.fetchedResultsController performFetch:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.fetchedResultsController.fetchedObjects.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ParkListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    Park *park = [self.fetchedResultsController objectAtIndexPath:indexPath];
    // Setup labels
    cell.park = park;
    cell.parkNameLabel.text = park.name;
    cell.numCoastersLabel.text = [self formatStringForNumber:[park.coasters count]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedPark = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"coastersInPark" sender:self];
    });
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

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    }
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    NSFetchRequest *fetchRequest = [self parkFetchRequest];
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:coreDataStack.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController.delegate = self;
    return _fetchedResultsController;
}

- (NSFetchRequest *)parkFetchRequest {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Park"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"state LIKE %@ && country LIKE %@", _state, _country];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    [request setPredicate:predicate];
    return request;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"coastersInPark"]) {
        CoasterTableViewController *coasterTableViewController = segue.destinationViewController;
        coasterTableViewController.hidesBottomBarWhenPushed = YES;
        coasterTableViewController.park = _selectedPark;
    }
}


@end
