//
//  CoasterTableViewCell.h
//  Coaster Creds
//
//  Created by Mike Fudge on 21/03/2015.
//  Copyright (c) 2015 Mike Fudge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"
#import "BFPaperCheckbox.h"

@class Coaster;

@interface CoasterTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet BFPaperCheckbox *rideButton;
@property (strong, nonatomic) Coaster *coaster;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *ratingView;

- (void)configureCell;

@end
