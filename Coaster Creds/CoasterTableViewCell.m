//
//  CoasterTableViewCell.m
//  Coaster Creds
//
//  Created by Mike Fudge on 21/03/2015.
//  Copyright (c) 2015 Mike Fudge. All rights reserved.
//

#import "CoasterTableViewCell.h"
#import "Coaster.h"

@interface CoasterTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@end

@implementation CoasterTableViewCell



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellForCoaster:(Coaster *)coaster {
    self.nameLabel.text = coaster.name;
    self.typeLabel.text = [NSString stringWithFormat:@"%@, %@", coaster.type, coaster.design];
}

@end
