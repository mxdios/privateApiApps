//
//  AppsObject.m
//  privateApiApps
//
//  Created by miaoxiaodong on 16/12/27.
//  Copyright © 2016年 miaoxiaodong. All rights reserved.
//

#import "AppsObject.h"

@implementation AppsObject

+ (UIImage *)getAppIcon:(NSData *)iconData {
    NSInteger lenth = iconData.length;
    NSInteger width = 87;
    NSInteger height = 87;
    uint32_t *pixels = (uint32_t *)malloc(width * height * sizeof(uint32_t));
    [iconData getBytes:pixels range:NSMakeRange(32, lenth - 32)];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef ctx = CGBitmapContextCreate(pixels, width, height, 8, (width + 1) * sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    
    CGImageRef cgImage = CGBitmapContextCreateImage(ctx);
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    UIImage *icon = [UIImage imageWithCGImage: cgImage];
    CGImageRelease(cgImage);
    
    return icon;
}
@end
