//
//  ViewController.m
//  privateApiApps
//
//  Created by miaoxiaodong on 16/12/27.
//  Copyright © 2016年 miaoxiaodong. All rights reserved.
//

#import "ViewController.h"
#import "AppsObject.h"
#import "AppInfoViewController.h"
#import <objc/runtime.h>

@interface ViewController ()
{
    NSMutableArray *_appsObjArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"apps";
    
    _appsObjArray = [NSMutableArray array];
    
    [self.view addSubview:self.tableView];
    
    Class LSApp_class = objc_getClass("LSApplicationWorkspace");
    NSObject *workspace = [LSApp_class performSelector:@selector(defaultWorkspace)];
    NSArray *appsArray = [workspace performSelector:@selector(allApplications)];
    
    [appsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        AppsObject *appsObj = [[AppsObject alloc] init];
        appsObj.obj = obj;
        appsObj.appName = [obj performSelector:@selector(localizedName)];
        appsObj.iconData = [obj performSelector:@selector(iconDataForVariant:) withObject:@(2)];
        
        [_appsObjArray addObject:appsObj];
    }];
    [self.tableView reloadData];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _appsObjArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"CellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    AppsObject *obj = _appsObjArray[indexPath.row];
    cell.textLabel.text = obj.appName;
    cell.imageView.image = [AppsObject getAppIcon:obj.iconData];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AppInfoViewController *appVc = [[AppInfoViewController alloc] init];
    appVc.appsObj = _appsObjArray[indexPath.row];
    [self.navigationController pushViewController:appVc animated:YES];
}

@end
