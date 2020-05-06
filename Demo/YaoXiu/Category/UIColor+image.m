//
//  UIColor+image.m
//  YaoXiu
//
//  Created by MAC on 2020/4/17.
//  Copyright © 2020 Tencent. All rights reserved.
//

#import "UIColor+image.h"


@implementation UIColor (image)

+(UIImage *)imageWithColor:(UIColor *)color {

     CGRect rect=CGRectMake(0.0f, 0.0f, 50.0f, 50.0f);

    UIGraphicsBeginImageContext(rect.size);

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);

    CGContextFillRect(context, rect);

    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return theImage;

}

@end
