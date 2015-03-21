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

#define BUTTON_WIDTH_HEIGHT 50

@interface CoasterTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *riddenLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastDateLabel;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *starRating;

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
    self.starRating.value = self.coaster.rating;
    [self updateLabels];
    [self configureButtons];
}

- (void)configureButtons {
    self.rideButton.frame = CGRectMake(0, 0, BUTTON_WIDTH_HEIGHT, BUTTON_WIDTH_HEIGHT);
    self.rideButton.clipsToBounds = YES;
    self.rideButton.layer.cornerRadius = BUTTON_WIDTH_HEIGHT/2.0f;
    [self.rideButton.superview addSubview:self.rideButton];
}

- (IBAction)rideButtonPressed:(id)sender {
    NSDate *date = [NSDate date];
    self.coaster.dateLastRidden = date;
    self.coaster.timesRidden++;
    [self updateLabels];
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    [coreDataStack saveContext];
}

- (void)updateLabels {
    NSString *rodeString = [[NSString alloc] init];
    if (self.coaster.timesRidden == 1) {
        rodeString = @"time";
    } else {
        rodeString = @"times";
    }
    if (self.coaster.timesRidden == 0) {
        self.riddenLabel.text = @"Not ridden yet";
        self.lastDateLabel.text = @"Last ridden: never";
    } else {self.riddenLabel.text = [NSString stringWithFormat:@"Rode %d %@", self.coaster.timesRidden, rodeString];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yy 'at' HH:mm"];
        self.lastDateLabel.text = [NSString stringWithFormat:@"Last ridden: %@", [dateFormatter stringFromDate:self.coaster.dateLastRidden]];
    }
}

- (IBAction)ratingWasChanged:(HCSStarRatingView *)sender {
    self.coaster.rating = sender.value;
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    [coreDataStack saveContext];
}



@end
