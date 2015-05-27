//
//  ParkPinAnnotationView.m
//  Coaster Creds
//
//  Created by Mike Fudge on 26/05/2015.
//  Copyright (c) 2015 Mike Fudge. All rights reserved.
//

#import "ParkPinAnnotationView.h"
#import "Coaster.h"

@interface ParkPinAnnotationView ()

@property int total;

@end

@implementation ParkPinAnnotationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithAnnotation:(id<MKAnnotation>)annotation park:(Park *)park {
    self = [super initWithAnnotation:annotation reuseIdentifier:nil];
    _park = park;
    self.canShowCallout = YES;
    self.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    label.text = [self getParkCoasterCount];
    if (_total >= 10) {
        label.font = [label.font fontWithSize:8];
    } else {
        label.font = [label.font fontWithSize:11];
    }
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    self.image = [self getAnnotationImage];
    self.centerOffset = CGPointMake(0, -self.frame.size.height / 2);
    [self addSubview:label];
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView != nil)
    {
        [self.superview bringSubviewToFront:self];
    }
    return hitView;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    CGRect rect = self.bounds;
    BOOL isInside = CGRectContainsPoint(rect, point);
    if(!isInside)
    {
        for (UIView *view in self.subviews)
        {
            isInside = CGRectContainsPoint(view.frame, point);
            if(isInside)
                break;
        }
    }
    return isInside;
}

- (NSString *)getParkCoasterCount {
    _total = 0;
    int count = 0;
    for (Coaster *coaster in _park.coasters) {
        if (coaster.status == 1) {
            _total++;
            if (coaster.ridden == YES) {
                count++;
            }
        }
    }
    return [NSString stringWithFormat:@"%d/%d", count, _total];
}

- (UIImage *)getAnnotationImage {
    int count = 0;
    float total = 0;
    for (Coaster *coaster in _park.coasters) {
        if (coaster.status == 1) {
            total++;
            if (coaster.ridden == YES) {
                count++;
            }
        }
    }
    float percentage = count / total;
    // Red - < 25% ridden
    if (percentage >= 0 && percentage < 0.25 && total != 0) {
        return [UIImage imageNamed:@"annotation_red"];
    }
    // Orange - < 50% ridden
    else if (percentage >= 0.25 && percentage < 0.5) {
        return [UIImage imageNamed:@"annotation_orange"];
    }
    // Yellow - < 75% ridden
    else if (percentage >= 0.5 && percentage < 0.75) {
        return [UIImage imageNamed:@"annotation_yellow"];
    }
    // Otherwise green
    else if (percentage >= 0.75 && percentage < 1) {
        return [UIImage imageNamed:@"annotation_blue"];
    } else {
        return [UIImage imageNamed:@"annotation_green"];
    }
}



@end
