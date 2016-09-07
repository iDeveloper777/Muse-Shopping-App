//
//  Utils.m
//  Muse
//
//  Created by Pasca Maulana on 3/10/14.
//  Copyright (c) 2014 Digi. All rights reserved.
//

#import "Utils.h"
#import <Foundation/Foundation.h>

@interface Utils ()

@end

@implementation Utils

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@end