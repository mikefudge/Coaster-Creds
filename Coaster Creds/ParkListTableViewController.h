//
//  ParkListTableViewController.h
//  Coaster Creds
//
//  Created by Mike Fudge on 11/04/2015.
//  Copyright (c) 2015 Mike Fudge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParkListTableViewController : UITableViewController

@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *country;
@property BOOL isAllParks;

@end
