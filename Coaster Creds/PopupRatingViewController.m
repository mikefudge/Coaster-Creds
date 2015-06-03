//
//  PopupRatingViewController.m
//  Coaster Creds
//
//  Created by Mike Fudge on 21/04/2015.
//  Copyright (c) 2015 Mike Fudge. All rights reserved.
//

#import "PopupRatingViewController.h"
#import "HCSStarRatingView.h"
#import "CoreDataStack.h"

@interface PopupRatingViewController ()

@property (weak, nonatomic) IBOutlet UIButton *dismissViewButton;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *ratingView;

@end

@implementation PopupRatingViewController

- (void)viewDidLoad {
    self.view.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.popupView.layer.cornerRadius = 5;
    self.popupView.layer.shadowOpacity = 0.8;
    self.popupView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    _ratingView.value = [_cell.coaster.rating floatValue];
    [_ratingView addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showAnimate {

    self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.view.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.view.alpha = 1;
        self.view.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)removeAnimate {
    [UIView animateWithDuration:0.25 animations:^{
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view removeFromSuperview];
        }
    }];
}

- (void)showInView:(UIView *)view animated:(BOOL)animated {
    [view addSubview:self.view];
    self.view.center = [view convertPoint:view.center
                            fromView:view.superview];
    if (animated) {
        [self showAnimate];
    }
}

- (IBAction)viewWasDismissed:(id)sender {
    [self removeAnimate];
}

- (IBAction)didChangeValue:(HCSStarRatingView *)sender {
    _cell.coaster.rating = [NSNumber numberWithFloat:sender.value];
    [_cell configureCell];
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    [coreDataStack saveContext];
}

@end
