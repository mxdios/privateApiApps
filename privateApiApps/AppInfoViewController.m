//
//  AppInfoViewController.m
//  privateApiApps
//
//  Created by miaoxiaodong on 16/12/27.
//  Copyright © 2016年 miaoxiaodong. All rights reserved.
//

#import "AppInfoViewController.h"

@interface AppInfoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *appIcon;
@property (weak, nonatomic) IBOutlet UILabel *appName;

@property (weak, nonatomic) IBOutlet UILabel *appVersion;
@property (weak, nonatomic) IBOutlet UILabel *appBundleid;
@end

@implementation AppInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.appsObj.appName;
    self.appIcon.image = [AppsObject getAppIcon:self.appsObj.iconData];
    self.appName.text = self.appsObj.appName;
    self.appVersion.text = self.appsObj.version;
    self.appBundleid.text = self.appsObj.bundleId;
}

- (IBAction)openApp:(UIButton *)sender {
    
    Class cls = NSClassFromString(@"LSApplicationWorkspace");
    id s = [(id)cls performSelector:@selector(defaultWorkspace)];
    [s performSelector:@selector(openApplicationWithBundleID:) withObject:self.appsObj.bundleId];
}

@end
