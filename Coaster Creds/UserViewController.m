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

@interface UserViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UICountingLabel *countLabel;
@property (weak, nonatomic) IBOutlet UICountingLabel *countSteelLabel;
@property (weak, nonatomic) IBOutlet UICountingLabel *countWoodLabel;
@property (strong, nonatomic) NSArray *coasters;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *designLabel;

@property int countTotal;
@property int countSteel;
@property int countWood;

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Gradient background
    CAGradientLayer *backgroundLayer = [MFGradient blueGradientLayer];
    backgroundLayer.frame = self.view.frame;
    [self.view.layer insertSublayer:backgroundLayer atIndex:0];
    // Get ridden coasters
    _coasters = [self getRiddenCoasters];
    // Set count values
    [self getCoasterCounts:_coasters];
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    _countLabel.format = @"%d";
    _countSteelLabel.format = @"%d";
    _countWoodLabel.format = @"%d";
    [_countLabel countFrom:0 to:_countTotal withDuration:3.0f];
    [_countSteelLabel countFrom:0 to:_countSteel withDuration:2.0f];
    [_countWoodLabel countFrom:0 to:_countWood withDuration:2.0f];
}

- (void)viewDidDisappear:(BOOL)animated {
    _countLabel.text = @"0";
    _countSteelLabel.text = @"0";
    _countWoodLabel.text = @"0";
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
        } else if ([coaster.type isEqualToString:@"Wood"]) {
            _countWood++;
        }
    }
}

- (IBAction)sitdownWasPressed:(id)sender {
    _designLabel.text = @"Sit Down";
    POPSpringAnimation *sprintAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    sprintAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0.9, 0.9)];
    sprintAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(2, 2)];
    sprintAnimation.springBounciness = 20.f;
    [_designLabel pop_addAnimation:sprintAnimation forKey:@"springAnimation"];
}

- (IBAction)bobsledWasPressed:(id)sender {
    _designLabel.text = @"Bobsled";
}

- (IBAction)standupWasPressed:(id)sender {
    _designLabel.text = @"Stand Up";
}

- (IBAction)wingWasPressed:(id)sender {
    _designLabel.text = @"Wing";
}

- (IBAction)pipelineWasPressed:(id)sender {
    _designLabel.text = @"Pipeline";
}

- (IBAction)suspendedWasPressed:(id)sender {
    _designLabel.text = @"Suspended";
}

- (IBAction)invertedWasPressed:(id)sender {
    _designLabel.text = @"Inverted";
}

- (IBAction)flyingWasPressed:(id)sender {
    _designLabel.text = @"Flying";
}

@end
