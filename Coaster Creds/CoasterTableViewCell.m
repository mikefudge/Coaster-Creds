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
    
    if (_coaster.ridden) {
        [self.rideButton checkAnimated:NO];
    } else {
        [self.rideButton uncheckAnimated:NO];
    }
    _ratingView.value = [_coaster.rating floatValue];
    _typeLabel.text = [NSString stringWithFormat:@"%@", _coaster.type];
    _designLabel.text = [NSString stringWithFormat:@"%@", _coaster.design];
    _typeImage.image = [self getTypeIconImage];
    _designImage.image = [self getDesignIconImage];
}

- (UIImage *)getTypeIconImage {
    NSString *type = [_coaster.type lowercaseString];
    NSString *imagePath = [[NSString alloc] initWithFormat:@"icon_type_%@", type];
    return [UIImage imageNamed:imagePath];
}

- (UIImage *)getDesignIconImage {
    NSString *design = [[_coaster.design lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *imagePath = [[NSString alloc] initWithFormat:@"icon_design_%@", design];
    return [UIImage imageNamed:imagePath];
}

@end
