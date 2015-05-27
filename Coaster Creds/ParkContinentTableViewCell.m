//
//  ParkContinentTableViewCell.m
//  Coaster Creds
//
//  Created by Mike Fudge on 17/05/2015.
//  Copyright (c) 2015 Mike Fudge. All rights reserved.
//

#import "ParkContinentTableViewCell.h"
#import "Chameleon.h"
#import "Color.h"

@interface ParkContinentTableViewCell ()

@property (strong, nonatomic) UIColor *defaultContinentLabelColor;
@property (strong, nonatomic) UIColor *defaultBgColor;

@end

@implementation ParkContinentTableViewCell

- (void)awakeFromNib {
    _defaultContinentLabelColor = _continentLabel.textColor;
    _defaultBgColor = self.backgroundColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (selected) {
        _continentLabel.textColor = [UIColor whiteColor];
        self.backgroundColor = [Color colorWithR:43 G:131 B:190 A:1];
    }
    else {
        _continentLabel.textColor = _defaultContinentLabelColor;
        self.backgroundColor = _defaultBgColor;
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    if (highlighted) {
        _continentLabel.textColor = [UIColor whiteColor];
        self.backgroundColor = [Color colorWithR:43 G:131 B:190 A:1];
    }
    else {
        _continentLabel.textColor = _defaultContinentLabelColor;
        self.backgroundColor = _defaultBgColor;
    }
}

@end
