//
//  HomeTableViewController.m
//  Coaster Creds
//
//  Created by Mike Fudge on 11/04/2015.
//  Copyright (c) 2015 Mike Fudge. All rights reserved.
//

#import "HomeTableViewController.h"
#import "CoasterTableViewController.h"
#import "Park.h"

@interface HomeTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nearestParkNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nearestParkDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *nearestParkCoastersLabel;

@property (weak, nonatomic) IBOutlet UILabel *nearbyPark1NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nearbyPark1DistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *nearbyPark1CoastersLabel;

@property (weak, nonatomic) IBOutlet UILabel *nearbyPark2NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nearbyPark2DistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *nearbyPark2CoastersLabel;

@property (strong, nonatomic) Park *selectedPark;


@end

@implementation HomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Park *park = [self.parksArray objectAtIndex:0];
    self.nearestParkNameLabel.text = park.name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadTableWithArray:(NSMutableArray *)array {
    self.parksArray = array;
    Park *park = [self.parksArray objectAtIndex:0];
    self.nearestParkNameLabel.text = park.name;
    self.nearestParkDistanceLabel.text = [NSString stringWithFormat:@"%.1f miles away", park.distance];
    self.nearestParkCoastersLabel.text = [self formatStringForNumber:[park.coasters count]];
    park = [self.parksArray objectAtIndex:1];
    self.nearbyPark1NameLabel.text = park.name;
    self.nearbyPark1DistanceLabel.text = [NSString stringWithFormat:@"%.1f miles away", park.distance];
    self.nearbyPark1CoastersLabel.text = [self formatStringForNumber:[park.coasters count]];
    park = [self.parksArray objectAtIndex:2];
    self.nearbyPark2NameLabel.text = park.name;
    self.nearbyPark2DistanceLabel.text = [NSString stringWithFormat:@"%.1f miles away", park.distance];
    self.nearbyPark2CoastersLabel.text = [self formatStringForNumber:[park.coasters count]];
    [self hideLabels:NO];
    [self.tableView reloadData];
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

- (void)hideLabels:(BOOL)value {
    self.nearestParkNameLabel.hidden =  value;
    self.nearestParkDistanceLabel.hidden = value;
    self.nearestParkCoastersLabel.hidden = value;
    self.nearbyPark1NameLabel.hidden = value;
    self.nearbyPark1DistanceLabel.hidden = value;
    self.nearbyPark1CoastersLabel.hidden = value;
    self.nearbyPark2NameLabel.hidden = value;
    self.nearbyPark2DistanceLabel.hidden = value;
    self.nearbyPark2CoastersLabel.hidden = value;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        self.selectedPark = [self.parksArray objectAtIndex:0];
    } else {
        if (indexPath.row == 0) {
            self.selectedPark = [self.parksArray objectAtIndex:1];
        } else {
            self.selectedPark = [self.parksArray objectAtIndex:2];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"coastersInPark" sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"coastersInPark"]) {
        CoasterTableViewController *coasterTableViewController = segue.destinationViewController;
        coasterTableViewController.park = self.selectedPark;
    }  
}


@end
