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
/** app名字 */
@property (nonatomic, copy) NSString *appName;
/** 版本号 */
@property (nonatomic, copy) NSString *version;
/** bundle id */
@property (nonatomic, copy) NSString *bundleId;
/** app图标 */
@property (nonatomic, strong) NSData *iconData;
/** app在AppStore的全名 */
@property (nonatomic, copy) NSString *appFullName;
/** app类型 */
@property (nonatomic, copy) NSString *appType;
/** app供应商 */
@property (nonatomic, copy) NSString *appVendorName;
/** app评级 */
@property (nonatomic, copy) NSString *appRating;

+ (UIImage *)getAppIcon:(NSData *)iconData;
@end
