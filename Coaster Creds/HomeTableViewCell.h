//
//  HomeTableViewCell.h
//  Coaster Creds
//
//  Created by Mike Fudge on 04/05/2015.
//  Copyright (c) 2015 Mike Fudge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *parkNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numCoastersLabel;
@property (weak, nonatomic) IBOutlet UILabel *parkAreaLabel;

@end
