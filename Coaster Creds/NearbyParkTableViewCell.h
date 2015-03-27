//
//  NearbyParkTableViewCell.h
//  Coaster Creds
//
//  Created by Mike Fudge on 27/03/2015.
//  Copyright (c) 2015 Mike Fudge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Park.h"

@interface NearbyParkTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *parkNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceAwayLabel;
@property (weak, nonatomic) IBOutlet UILabel *numCoastersLabel;
@property (strong, nonatomic) Park *park;

@end
