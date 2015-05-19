//
//  ParkListTableViewCell.h
//  Coaster Creds
//
//  Created by Mike Fudge on 11/04/2015.
//  Copyright (c) 2015 Mike Fudge. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Park;

@interface ParkListTableViewCell : UITableViewCell

@property (strong, nonatomic) Park *park;
@property (weak, nonatomic) IBOutlet UILabel *parkNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numCoastersLabel;

@end
