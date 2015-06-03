//
//  HomeTableViewCell.m
//  Coaster Creds
//
//  Created by Mike Fudge on 04/05/2015.
//  Copyright (c) 2015 Mike Fudge. All rights reserved.
//

#import "HomeTableViewCell.h"
#import "Chameleon.h"
#import "Color.h"

@interface HomeTableViewCell ()

@property (strong, nonatomic) UIColor *defaultParkNameLabelColor;
@property (strong, nonatomic) UIColor *defaultParkAreaLabelColor;
@property (strong, nonatomic) UIColor *defaultParkDistanceLabelColor;
@property (strong, nonatomic) UIColor *defaultBgColor;

@end

@implementation HomeTableViewCell

- (void)awakeFromNib {
    _defaultParkNameLabelColor = _parkNameLabel.textColor;
    _defaultParkAreaLabelColor = _parkAreaLabel.textColor;
    _defaultParkDistanceLabelColor = _parkDistanceLabel.textColor;
    _defaultBgColor = self.contentView.backgroundColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //[super setSelected:selected animated:animated];
    if (selected) {
        _parkNameLabel.textColor = [UIColor whiteColor];
        _parkAreaLabel.textColor = [UIColor whiteColor];
        _parkDistanceLabel.textColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [Color colorWithR:43 G:131 B:190 A:1];
    }
     else {
         _parkNameLabel.textColor = _defaultParkNameLabelColor;
         _parkAreaLabel.textColor = _defaultParkAreaLabelColor;
         _parkDistanceLabel.textColor = _defaultParkDistanceLabelColor;
        self.contentView.backgroundColor = _defaultBgColor;
    }
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    if (highlighted) {
        _parkNameLabel.textColor = [UIColor whiteColor];
        _parkAreaLabel.textColor = [UIColor whiteColor];
        _parkDistanceLabel.textColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [Color colorWithR:43 G:131 B:190 A:1];
    }
    else {
        _parkNameLabel.textColor = _defaultParkNameLabelColor;
        _parkAreaLabel.textColor = _defaultParkAreaLabelColor;
        _parkDistanceLabel.textColor = _defaultParkDistanceLabelColor;
        self.contentView.backgroundColor = _defaultBgColor;
    }
}

@end
