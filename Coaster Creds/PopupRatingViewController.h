//
//  PopupRatingViewController.h
//  Coaster Creds
//
//  Created by Mike Fudge on 21/04/2015.
//  Copyright (c) 2015 Mike Fudge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Coaster.h"
#import "CoasterTableViewCell.h"

@interface PopupRatingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *popupView;
@property (strong, nonatomic) Coaster *coaster;
@property (strong, nonatomic) CoasterTableViewCell *cell;

- (void)showInView:(UIView *)view animated:(BOOL)animated;

@end
