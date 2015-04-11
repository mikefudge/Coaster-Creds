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
#import "HomeViewController.h"

#import <CoreData/CoreData.h>


@interface CoasterTableViewController () <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) IBOutlet UILabel *parkNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkOpenedDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkNumCoastersLabel;
@property (weak, nonatomic) IBOutlet UIImageView *topCoasterImageView;
@property (strong, nonatomic) NSArray *coasterImagesArray;

@end

@implementation CoasterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self displayRandomCoasterImage];
    self.tableView.estimatedRowHeight = 68.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.parkNameLabel.text = self.park.name;
    self.parkNumCoastersLabel.text = [NSString stringWithFormat:@"%lu rollercoasters in park", (unsigned long)[self.park.coasters count]];
    [self.fetchedResultsController performFetch:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {

}


- (void)viewWillAppear:(BOOL)animated {

}

- (void)displayRandomCoasterImage {
    
    NSArray *coasterImageArray = [[NSArray alloc] initWithObjects: [UIImage imageNamed:@"coaster1-header.png"],  [UIImage imageNamed:@"coaster2-header.png"], [UIImage imageNamed:@"coaster3-header.png"], [UIImage imageNamed:@"coaster4-header.png"], nil];
    int rand = arc4random() % 4;
    self.topCoasterImageView.image = [coasterImageArray objectAtIndex:rand];
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
    [cell.coaster toggleRidden];
    if (cell.coaster.ridden) {
        [sender setImage:[UIImage imageNamed:@"checkbutton_checked.png"] forState:UIControlStateNormal];
    } else {
        [sender setImage:[UIImage imageNamed:@"checkbutton_empty.png"] forState:UIControlStateNormal];
    }
    
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    [coreDataStack saveContext];
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
    [self.navigationController popViewControllerAnimated:YES];
}

@end
