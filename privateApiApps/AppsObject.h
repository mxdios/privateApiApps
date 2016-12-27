//
//  AppsObject.h
//  privateApiApps
//
//  Created by miaoxiaodong on 16/12/27.
//  Copyright © 2016年 miaoxiaodong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AppsObject : NSObject
@property (nonatomic, copy) NSString *appName;
@property (nonatomic, copy) NSString *version;
@property (nonatomic, copy) NSString *bundleId;
@property (nonatomic, strong) NSData *iconData;

+ (UIImage *)getAppIcon:(NSData *)iconData;
@end
