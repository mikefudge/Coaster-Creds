//
//  Color.m
//  Coaster Creds
//
//  Created by Mike Fudge on 23/03/2015.
//  Copyright (c) 2015 Mike Fudge. All rights reserved.
//

#import "Color.h"

@implementation Color : UIColor

+ (UIColor *)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue A:(CGFloat)alpha {
    return [UIColor colorWithRed:(red/255.0) green:(green/255.0) blue:(blue/255.0) alpha:alpha];
}

@end
