//
//  MFGradient.m
//  Coaster Creds
//
//  Created by Mike Fudge on 29/05/2015.
//  Copyright (c) 2015 Mike Fudge. All rights reserved.
//

#import "MFGradient.h"
#import "Color.h"

@implementation MFGradient

+ (MFGradient *)blueGradientLayer {
    UIColor *topColor = [Color colorWithR:52 G:152 B:219 A:1];
    UIColor *bottomColor = [Color colorWithR:32 G:103 B:149 A:1];
    
    NSArray *gradientColors = [NSArray arrayWithObjects:(id)topColor.CGColor, (id)bottomColor.CGColor, nil];
    NSArray *gradientLocations = [NSArray arrayWithObjects:[NSNumber numberWithInt:0.0],[NSNumber numberWithInt:1.0], nil];

    MFGradient *gradientLayer = [MFGradient layer];
    gradientLayer.colors = gradientColors;
    gradientLayer.locations = gradientLocations;
    return gradientLayer;
}

@end
