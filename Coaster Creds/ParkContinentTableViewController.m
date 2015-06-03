//
//  ParkCountryTableViewController.m
//  Coaster Creds
//
//  Created by Mike Fudge on 17/05/2015.
//  Copyright (c) 2015 Mike Fudge. All rights reserved.
//

#import "ParkContinentTableViewController.h"
#import "ParkContinentTableViewCell.h"
#import "ParkCountryTableViewController.h"

@interface ParkContinentTableViewController ()

@property (strong, nonatomic) NSDictionary *countries;
@property (strong, nonatomic) NSArray *continents;
@property (strong, nonatomic) NSArray *countriesInContinent;
@property (strong, nonatomic) NSString *selectedContinent;

@end

@implementation ParkContinentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _countries = @{@"Africa" : @[@"Algeria", @"Angola", @"Botswana", @"Egypt", @"Libya", @"Morocco", @"Nigeria", @"Senegal", @"South Africa", @"Sudan", @"Tanzania", @"Tunisia", @"Uganda"],
                   @"Asia" : @[@"Afghanistan", @"Armenia", @"Azerbaijan", @"Bahrain", @"Bangladesh", @"Brunei", @"Cambodia", @"China", @"Georgia", @"Guam", @"India", @"Indonesia", @"Iran", @"Iraq", @"Israel", @"Japan", @"Jordan", @"Kazakhstan", @"Kuwait", @"Kyrgyzstan", @"Lebanon", @"Malaysia", @"Mongolia", @"Myanmar", @"Nepal", @"North Korea", @"Oman", @"Pakistan", @"Palestine", @"Philippines", @"Qatar", @"Russia", @"Saudi Arabia", @"Singapore", @"South Korea", @"Sri Lanka", @"Syria", @"Taiwan", @"Tajikistan", @"Thailand", @"Turkmenistan", @"United Arab Emirates", @"Uzbekistan", @"Vietnam", @"Yemen"],
                   @"Australia" : @[@"Australia", @"New Zealand"],
                   @"Europe" : @[@"Albania", @"Austria", @"Belarus", @"Belgium", @"Bulgaria", @"Croatia", @"Cyprus", @"Czech Republic", @"Denmark", @"Finland", @"France", @"Germany", @"Greece", @"Hungary", @"Ireland", @"Italy", @"Kosovo", @"Lithuania", @"Malta", @"Netherlands", @"Norway", @"Poland", @"Portugal", @"Romania", @"Serbia", @"Spain", @"Sweden", @"Switzerland", @"Turkey", @"UK", @"Ukraine"],
                   @"North America" : @[@"Canada", @"Costa Rica", @"Cuba", @"Guatemala", @"Honduras", @"Mexico", @"Panama", @"USA"],
                   @"South America" : @[@"Argentina", @"Brazil", @"Chile", @"Colombia", @"Ecuador", @"Peru", @"Uruguay", @"Venezuela"]};
    _continents = [[_countries allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

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
    return [_continents count];
}


- (ParkContinentTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ParkContinentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSString *continent = [_continents objectAtIndex:indexPath.row];
    cell.continentLabel.text = continent;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedContinent = [_continents objectAtIndex:indexPath.row];
    _countriesInContinent = [_countries objectForKey:_selectedContinent];
    [self performSegueWithIdentifier:@"countriesInContinent" sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"countriesInContinent"]) {
        ParkCountryTableViewController *parkCountryTableViewController = segue.destinationViewController;
        parkCountryTableViewController.countries = _countriesInContinent;
        parkCountryTableViewController.continent = _selectedContinent;
    }
}

@end

