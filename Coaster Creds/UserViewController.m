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

@interface UserViewController ()

@property (weak, nonatomic) IBOutlet UICountingLabel *countLabel;

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    
    _countLabel.format = @"%d";
    [_countLabel countFrom:0 to:[self getCoasterCount] withDuration:2.0f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)getCoasterCount {
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Coaster" inManagedObjectContext:coreDataStack.managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ridden == YES"];
    [request setEntity:entity];
    [request setPredicate:predicate];
    NSArray *result = [coreDataStack.managedObjectContext executeFetchRequest:request error:nil];
    return result.count;
}

@end
