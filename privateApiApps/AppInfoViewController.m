//
//  AppInfoViewController.m
//  privateApiApps
//
//  Created by miaoxiaodong on 16/12/27.
//  Copyright © 2016年 miaoxiaodong. All rights reserved.
//

#import "AppInfoViewController.h"

@interface AppInfoViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *_tableDataArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIImageView *appIcon;

@end

@implementation AppInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.appsObj.appName;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    NSString *name = [NSString stringWithFormat:@"名称: %@",self.appsObj.appName];
    NSString *version = [NSString stringWithFormat:@"版本号: %@",self.appsObj.version];
    NSString *bundleid = [NSString stringWithFormat:@"BundleId: %@", self.appsObj.bundleId];
    NSString *fullName = [NSString stringWithFormat:@"app全名: %@", self.appsObj.appFullName];
    NSString *type = [NSString stringWithFormat:@"类型: %@", [self.appsObj.appType isEqualToString:@"System"] ? @"系统应用" : @"普通应用"];
    NSString *vendor = [NSString stringWithFormat:@"供应商: %@", self.appsObj.appVendorName];
    NSString *rating = [NSString stringWithFormat:@"评级: %@", self.appsObj.appRating];
    _tableDataArray = @[name, version, bundleid, fullName, type, vendor, rating];
    
    self.appIcon.image = [AppsObject getAppIcon:self.appsObj.iconData];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"打开app" style:UIBarButtonItemStyleDone target:self action:@selector(openApp)];
    
}

- (void)openApp {
    
    Class LSAppClass = NSClassFromString(@"LSApplicationWorkspace");
    id workSpace = [(id)LSAppClass performSelector:@selector(defaultWorkspace)];
    [workSpace performSelector:@selector(openApplicationWithBundleID:) withObject:self.appsObj.bundleId];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableDataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"CellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = _tableDataArray[indexPath.row];
    cell.textLabel.numberOfLines = 0;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了 = %ld", indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
