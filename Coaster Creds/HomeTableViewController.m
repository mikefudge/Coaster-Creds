//
//  HomeTableViewController.m
//  Coaster Creds
//
//  Created by Mike Fudge on 11/04/2015.
//  Copyright (c) 2015 Mike Fudge. All rights reserved.
//

#import "HomeTableViewController.h"
#import "CoasterTableViewController.h"
#import "HomeTableViewCell.h"
#import "Park.h"
#import "Coaster.h"

#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>

@interface HomeTableViewController ()

@property (strong, nonatomic) Park *selectedPark;


@end

@implementation HomeTableViewController

- (void)viewDidLoad {
    self.tableView.estimatedRowHeight = 98.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadTableWithArray:(NSMutableArray *)array {
    _parksArray = array;
    [self.tableView reloadData];
}

- (NSString *)formatStringForNumber:(long)number {
    NSString *string = [[NSString alloc] init];
    if (number == 0) {
        string = @"No coasters";
    } else if (number == 1) {
        string = @"1 coaster";
    } else {
        string = [NSString stringWithFormat:@"%lu coasters", number];
    }
    return string;
}

- (void)hideLabel:(UILabel *)label isHidden:(BOOL)value {
    label.hidden = value;
}

- (NSString *)setNumCoastersLabelForPark:(Park *)park {
    int count = 0;
    for (Coaster *coaster in park.coasters) {
        if (coaster.ridden == YES) {
            count++;
        }
    }
    NSString *string = [[NSString alloc] initWithFormat:@"%d/%lu", count, (unsigned long)[park.coasters count]];
    return string;
}

#pragma mark Table View Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_parksArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    Park *park = [_parksArray objectAtIndex:indexPath.row];
    cell.parkNameLabel.text = park.name;
    cell.parkDistanceLabel.text = [[NSString alloc] initWithFormat:@"%.1f mi", park.distance];
    cell.numCoastersLabel.layer.cornerRadius = 17;
    cell.numCoastersLabel.clipsToBounds = YES;
    cell.numCoastersLabel.text = [self setNumCoastersLabelForPark:park];
    cell.parkAreaLabel.text = [[NSString alloc] initWithFormat:@"%@, %@", park.state, park.country];
    cell.numTotalCoastersLabel.text = [self formatStringForNumber:[park.coasters count]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedPark = [_parksArray objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"coastersInPark" sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"coastersInPark"]) {
        CoasterTableViewController *coasterTableViewController = segue.destinationViewController;
        coasterTableViewController.hidesBottomBarWhenPushed = YES;
        coasterTableViewController.park = self.selectedPark;
    }  
}


@end
