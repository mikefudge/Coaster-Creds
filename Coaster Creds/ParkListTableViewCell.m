//
//  ParkListTableViewCell.m
//  Coaster Creds
//
//  Created by Mike Fudge on 11/04/2015.
//  Copyright (c) 2015 Mike Fudge. All rights reserved.
//

#import "ParkListTableViewCell.h"
#import "Chameleon.h"
#import "Color.h"

@interface ParkListTableViewCell ()

@property (strong, nonatomic) UIColor *defaultParkNameLabelColor;
@property (strong, nonatomic) UIColor *defaultParkNumCoastersLabelColor;
@property (strong, nonatomic) UIColor *defaultBgColor;

@end

@implementation ParkListTableViewCell

- (void)awakeFromNib {
    _defaultParkNameLabelColor = _parkNameLabel.textColor;
    _defaultParkNumCoastersLabelColor = _numCoastersLabel.textColor;
    _defaultBgColor = self.backgroundColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (selected) {
        _parkNameLabel.textColor = [UIColor whiteColor];
        _numCoastersLabel.textColor = [UIColor whiteColor];
        self.backgroundColor = [Color colorWithR:43 G:131 B:190 A:1];
    }
    else {
        _parkNameLabel.textColor = _defaultParkNameLabelColor;
        _numCoastersLabel.textColor = _defaultParkNumCoastersLabelColor;
        self.backgroundColor = _defaultBgColor;
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    if (highlighted) {
        _parkNameLabel.textColor = [UIColor whiteColor];
        _numCoastersLabel.textColor = [UIColor whiteColor];
        self.backgroundColor = [Color colorWithR:43 G:131 B:190 A:1];
    }
    else {
        _parkNameLabel.textColor = _defaultParkNameLabelColor;
        _numCoastersLabel.textColor = _defaultParkNumCoastersLabelColor;
        self.backgroundColor = _defaultBgColor;
    }
}

@end
