//
//  CoasterTableViewCell.h
//  Coaster Creds
//
//  Created by Mike Fudge on 21/03/2015.
//  Copyright (c) 2015 Mike Fudge. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Coaster;

@interface CoasterTableViewCell : UITableViewCell

- (void)configureCellForCoaster:(Coaster *)coaster;

@end
