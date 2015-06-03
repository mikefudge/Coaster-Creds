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
#import "Chameleon.h"

@interface CoasterTableViewCell ()

@end

@implementation CoasterTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configureCell {
    _nameLabel.text = self.coaster.name;
    // Set checked button
    if (_coaster.ridden) {
        [self.rideButton checkAnimated:NO];
    } else {
        [self.rideButton uncheckAnimated:NO];
    }
    // Set opening year label
    if (_coaster.year != 0  && _coaster.status == 1) {
        _dateLabel.text = [NSString stringWithFormat:@"Opened in %hd", _coaster.year];
    } else if (_coaster.year != 0 && _coaster.status == 2) {
        _dateLabel.text = [NSString stringWithFormat:@"Opening in %hd", _coaster.year];
    } else {
        _dateLabel.text = @"";
    }
    // Set status label
    if (_coaster.status == 1) {
        _statusLabel.text = @"Operating";
        _statusLabel.textColor = [UIColor flatGreenColorDark];
    } else if (_coaster.status == 2) {
        _statusLabel.text = @"Under Construction";
        _statusLabel.textColor = [UIColor flatYellowColorDark];
    } else {
        _statusLabel.text = @"Closed";
        _statusLabel.textColor = [UIColor flatRedColorDark];
    }
    _ratingView.value = [_coaster.rating floatValue];
    _typeLabel.text = [NSString stringWithFormat:@"%@", _coaster.type];
    _designLabel.text = [NSString stringWithFormat:@"%@", _coaster.design];
    _typeImage.image = [self getTypeIconImage];
    _designImage.image = [self getDesignIconImage];
}

- (UIImage *)getTypeIconImage {
    NSString *type = [[_coaster.type lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *imagePath = [[NSString alloc] initWithFormat:@"icon_type_%@", type];
    return [UIImage imageNamed:imagePath];
}

- (UIImage *)getDesignIconImage {
    NSString *design = [[_coaster.design lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *imagePath = [[NSString alloc] initWithFormat:@"icon_design_%@", design];
    return [UIImage imageNamed:imagePath];
}

@end
