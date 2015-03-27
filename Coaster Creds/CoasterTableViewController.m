//
//  CoasterTableViewController.m
//  Coaster Creds
//
//  Created by Mike Fudge on 20/03/2015.
//  Copyright (c) 2015 Mike Fudge. All rights reserved.
//

#import "CoasterTableViewController.h"
#import "Coaster.h"
#import "CoreDataStack.h"
#import "Park.h"
#import "CoasterTableViewCell.h"
#import "NearestParkViewController.h"

#import <CoreData/CoreData.h>


@interface CoasterTableViewController () <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;




@end

@implementation CoasterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.park.name;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.estimatedRowHeight = 68.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.fetchedResultsController performFetch:nil];
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
    if (self.fetchedResultsController.fetchedObjects.count > 0) {
        return self.fetchedResultsController.fetchedObjects.count;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.fetchedResultsController.fetchedObjects.count == 0) {
        CoasterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EmptyCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        CoasterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        Coaster *coaster = [self.fetchedResultsController objectAtIndexPath:indexPath];
        cell.coaster = coaster;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configureCell];
        return cell;
    }
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    }
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    NSFetchRequest *fetchRequest = [self coasterFetchRequest];
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:coreDataStack.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController.delegate = self;
    return _fetchedResultsController;
}

- (NSFetchRequest *)coasterFetchRequest {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Coaster"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"park.name like %@ && park.state like %@ && park.country like %@", self.park.name, self.park.state, self.park.country];
    fetchRequest.predicate = predicate;
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    return fetchRequest;
}

- (IBAction)rideButtonWasPressed:(id)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    CoasterTableViewCell *cell = (CoasterTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    NSDate *date = [NSDate date];
    cell.coaster.dateLastRidden = date;
    cell.coaster.timesRidden++;
    if (cell.coaster.timesRidden == 1) {
        [self updateRideCountLabel];
    }
    [self updateLabelsInCell:cell];
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    [coreDataStack saveContext];
}

- (void)updateRideCountLabel {
    int count = [self.rideCount.title intValue];
    count++;
    self.rideCount.title = [[NSString alloc] initWithFormat:@"%d", count];
}

- (void)updateLabelsInCell:(CoasterTableViewCell *)cell {
    NSString *rodeString;
    if (cell.coaster.timesRidden == 1) {
        rodeString = @"time";
    } else {
        rodeString = @"times";
    }
    cell.riddenLabel.text = [NSString stringWithFormat:@"Rode %d %@", cell.coaster.timesRidden, rodeString];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yy 'at' HH:mm"];
    cell.lastDateLabel.text = [NSString stringWithFormat:@"Last ridden: %@", [dateFormatter stringFromDate:cell.coaster.dateLastRidden]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backWasPressed:(id)sender {
    
    
    NearestParkViewController *parentView = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    parentView.rideCount.title = self.rideCount.title;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
