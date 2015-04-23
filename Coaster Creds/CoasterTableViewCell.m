//
//  CoasterTableViewCell.m
//  Coaster Creds
//
//  Created by Mike Fudge on 21/03/2015.
//  Copyright (c) 2015 Mike Fudge. All rights reserved.
//

#import "CoasterTableViewCell.h"
#import "Coaster.h"
#import <QuartzCore/QuartzCore.h>
#import "CoreDataStack.h"
#import "HCSStarRatingView.h"

#define BUTTON_WIDTH_HEIGHT 60

@interface CoasterTableViewCell ()

@end

@implementation CoasterTableViewCell



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCell {
    // Change name, type and ride count, then configure buttons
    _nameLabel.text = self.coaster.name;
    _typeLabel.text = [NSString stringWithFormat:@"%@, %@", _coaster.type, _coaster.design];
    if (_coaster.ridden) {
        [_rideButton setImage:[UIImage imageNamed:@"checkbutton_checked.png"] forState:UIControlStateNormal];
    } else {
        [_rideButton setImage:[UIImage imageNamed:@"checkbutton_empty.png"] forState:UIControlStateNormal];
    }
    _ratingView.value = [_coaster.rating floatValue];
}

@end
