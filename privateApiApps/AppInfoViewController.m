//
//  AppInfoViewController.m
//  privateApiApps
//
//  Created by miaoxiaodong on 16/12/27.
//  Copyright © 2016年 miaoxiaodong. All rights reserved.
//

#import "AppInfoViewController.h"
#import <StoreKit/StoreKit.h>
#import <objc/runtime.h>

@interface AppInfoViewController ()<UITableViewDelegate, UITableViewDataSource, SKStoreProductViewControllerDelegate>
{
    NSMutableArray *_tableDataArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIImageView *appIcon;

@end

@implementation AppInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableDataArray = [NSMutableArray array];
    self.title = self.appsObj.appName;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.appIcon.image = [AppsObject getAppIcon:self.appsObj.iconData];
    NSString *name = self.appsObj.appName;
    NSString *version = [self.appsObj.obj performSelector:@selector(shortVersionString)];
    NSString *bundleid = [self.appsObj.obj performSelector:@selector(applicationIdentifier)];
    NSString *fullName = [self.appsObj.obj performSelector:@selector(itemName)];
    NSString *type = [self.appsObj.obj performSelector:@selector(applicationType)];
    NSString *vendor = [self.appsObj.obj performSelector:@selector(vendorName)];
    NSString *rating = [self.appsObj.obj performSelector:@selector(ratingLabel)];
    NSNumber *appid = [self.appsObj.obj performSelector:@selector(itemID)];
    
    
    if (name) [_tableDataArray addObject:[NSString stringWithFormat:@"名称: %@",name]];
    if (version) [_tableDataArray addObject:[NSString stringWithFormat:@"版本号: %@",version]];
    if (bundleid) [_tableDataArray addObject:[NSString stringWithFormat:@"BundleId: %@", bundleid]];
    self.appsObj.bundleId = bundleid;
    if (fullName) [_tableDataArray addObject:[NSString stringWithFormat:@"app全名: %@", fullName]];
    if (type) [_tableDataArray addObject:[NSString stringWithFormat:@"类型: %@", [type isEqualToString:@"System"] ? @"系统应用" : @"普通应用"]];
    if (vendor) [_tableDataArray addObject:[NSString stringWithFormat:@"供应商: %@", vendor]];
    if (rating) [_tableDataArray addObject:[NSString stringWithFormat:@"评级: %@", rating]];
    if (appid.integerValue) {
        [_tableDataArray addObject:[NSString stringWithFormat:@"App ID: %@", appid]];
        self.appsObj.appid = appid;
        [_tableDataArray addObject:@"在AppStore中显示"];
    }
    
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([[self tableView:tableView cellForRowAtIndexPath:indexPath].textLabel.text isEqualToString:@"在AppStore中显示"]) {
        SKStoreProductViewController *store = [[SKStoreProductViewController alloc] init];
        store.delegate = self;
        [store loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:self.appsObj.appid} completionBlock:^(BOOL result, NSError * _Nullable error) {
            if (error) {
                NSLog(@"error = %@",[error localizedDescription]);
            } else {
                [self presentViewController:store animated:YES completion:^{

                }];
            }
        }];
    }
}
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
@end
