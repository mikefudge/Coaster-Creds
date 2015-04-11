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
    self.nameLabel.text = self.coaster.name;
    self.typeLabel.text = [NSString stringWithFormat:@"%@, %@", self.coaster.type, self.coaster.design];
    if (self.coaster.ridden) {
        [self.rideButton setImage:[UIImage imageNamed:@"checkbutton_checked.png"] forState:UIControlStateNormal];
    } else {
        [self.rideButton setImage:[UIImage imageNamed:@"checkbutton_empty.png"] forState:UIControlStateNormal];
    }
}

@end
