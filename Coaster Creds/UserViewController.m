//
//  UserViewController.m
//  Coaster Creds
//
//  Created by Mike Fudge on 08/05/2015.
//  Copyright (c) 2015 Mike Fudge. All rights reserved.
//

#import "UserViewController.h"
#import "UICountingLabel.h"
#import "CoreDataStack.h"
#import "MFGradient.h"
#import "Coaster.h"
#import "pop/POP.h"
#import "Park.h"

@interface UserViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UICountingLabel *countLabel;
@property (weak, nonatomic) IBOutlet UICountingLabel *countSteelLabel;
@property (weak, nonatomic) IBOutlet UICountingLabel *countWoodLabel;
@property (weak, nonatomic) IBOutlet UICountingLabel *countSitDownLabel;
@property (weak, nonatomic) IBOutlet UICountingLabel *countInvertedLabel;
@property (weak, nonatomic) IBOutlet UICountingLabel *countFlyingLabel;
@property (weak, nonatomic) IBOutlet UICountingLabel *countBobsledLabel;
@property (weak, nonatomic) IBOutlet UICountingLabel *countStandUpLabel;
@property (weak, nonatomic) IBOutlet UICountingLabel *countSuspendedLabel;
@property (weak, nonatomic) IBOutlet UICountingLabel *countWingLabel;
@property (weak, nonatomic) IBOutlet UICountingLabel *countPipelineLabel;
@property (strong, nonatomic) NSArray *coasters;
@property (strong, nonatomic) NSMutableArray *topRatedCoasters;
@property int countTotal;
@property int countSteel;
@property int countWood;
@property int countSitDown;
@property int countInverted;
@property int countFlying;
@property int countBobsled;
@property int countStandUp;
@property int countSuspended;
@property int countWing;
@property int countPipeline;
@property (strong, nonatomic) NSArray *countLabels;
@property (strong, nonatomic) NSArray *counts;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _countLabels = @[_countLabel, _countSteelLabel, _countWoodLabel, _countSitDownLabel, _countInvertedLabel, _countFlyingLabel, _countBobsledLabel , _countStandUpLabel, _countSuspendedLabel, _countWingLabel, _countPipelineLabel];
    _topRatedCoasters = [[NSMutableArray alloc] init];
}

- (void)viewDidAppear:(BOOL)animated {
    // Set label formats
    for (UICountingLabel *label in _countLabels) {
        label.format = @"%d";
    }
    // Count up from 0 on all labels
    [_countLabel countFrom:0 to:_countTotal withDuration:3.0f];
    [_countSteelLabel countFrom:0 to:_countSteel withDuration:3.0f];
    [_countWoodLabel countFrom:0 to:_countWood withDuration:3.0f];
    [_countSitDownLabel countFrom:0 to:_countSitDown withDuration:3.0f];
    [_countInvertedLabel countFrom:0 to:_countInverted withDuration:3.0f];
    [_countFlyingLabel countFrom:0 to:_countFlying withDuration:3.0f];
    [_countBobsledLabel countFrom:0 to:_countBobsled withDuration:3.0f];
    [_countStandUpLabel countFrom:0 to:_countStandUp withDuration:3.0f];
    [_countSuspendedLabel countFrom:0 to:_countSuspended withDuration:3.0f];
    [_countWingLabel countFrom:0 to:_countWing withDuration:3.0f];
    [_countPipelineLabel countFrom:0 to:_countPipeline withDuration:3.0f];
}

- (void)viewWillAppear:(BOOL)animated {
    _countTotal = 0;
    _countSteel = 0;
    _countWood = 0;
    _countSitDown = 0;
    _countInverted = 0;
    _countFlying = 0;
    _countBobsled = 0;
    _countStandUp = 0;
    _countSuspended = 0;
    _countWing = 0;
    _countPipeline = 0;
    // Get ridden coasters
    _coasters = [self getRiddenCoasters];
    // Set count values
    [self getCoasterCounts:_coasters];
    
    [_topRatedCoasters removeAllObjects];
    for (Coaster *coaster in _coasters) {
        if ([coaster.rating isEqualToNumber:[NSNumber numberWithInt:5]]) {
            [_topRatedCoasters addObject:coaster];
        }
    }
    [_tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)getRiddenCoasters {
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Coaster" inManagedObjectContext:coreDataStack.managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ridden == YES"];
    [request setEntity:entity];
    [request setPredicate:predicate];
    NSArray *result = [coreDataStack.managedObjectContext executeFetchRequest:request error:nil];
    return result;
}

- (void)getCoasterCounts:(NSArray *)coasters {
    for (Coaster *coaster in _coasters) {
        _countTotal++;
        if ([coaster.type isEqualToString:@"Steel"]) {
            _countSteel++;
        } else {
            _countWood++;
        }
        if ([coaster.design isEqualToString:@"Sit Down"]) {
            _countSitDown++;
        } else if ([coaster.design isEqualToString:@"Inverted"]) {
            _countInverted++;
        } else if ([coaster.design isEqualToString:@"Flying"]) {
            _countFlying++;
        } else if ([coaster.design isEqualToString:@"Bobsled"]) {
            _countBobsled++;
        } else if ([coaster.design isEqualToString:@"Stand Up"]) {
            _countStandUp++;
        } else if ([coaster.design isEqualToString:@"Suspended"]) {
            _countSuspended++;
        } else if ([coaster.design isEqualToString:@"Wing Coaster"]) {
            _countWing++;
        } else if ([coaster.design isEqualToString:@"Pipeline"]) {
            _countPipeline++;
        }
    }
}

#pragma mark Table View Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_topRatedCoasters count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    Coaster *coaster = [_topRatedCoasters objectAtIndex:indexPath.row];
    cell.textLabel.text = coaster.name;
    cell.detailTextLabel.text = coaster.park.name;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (IBAction)designButtonWasPressed:(id)sender {
    [self popElement:sender];
}

- (void)popElement:(id)element {
    POPSpringAnimation *sprintAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    sprintAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
    sprintAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(10, 10)];
    sprintAnimation.springBounciness = 20.f;
    [element pop_addAnimation:sprintAnimation forKey:@"springAnimation"];
}

@end
