//
//  InfoTableViewController.m
//  privateApiApps
//
//  Created by miaoxiaodong on 16/12/30.
//  Copyright © 2016年 miaoxiaodong. All rights reserved.
//

#import "InfoTableViewController.h"
#import <objc/runtime.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>


@interface InfoTableViewController ()
{
    NSArray *_deviceArray;
}
@end

@implementation InfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"device";
    
    NSBundle *fmcoreBundle = [NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/FMCore.framework"];
    
    Class systemInfoClass = [fmcoreBundle classNamed:@"FMSystemInfo"];
    id systemInfo = [systemInfoClass performSelector:@selector(sharedInstance)];
    
    NSString *deviceName = [systemInfo performSelector:@selector(deviceName)];
    NSString *productType = [systemInfo performSelector:@selector(productType)];
    NSString *productName = [systemInfo performSelector:@selector(productName)];
    NSString *osBuildVersion = [systemInfo performSelector:@selector(osBuildVersion)];
    NSString *osVersion = [systemInfo performSelector:@selector(osVersion)];
    
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [networkInfo subscriberCellularProvider];
    NSString *carrierName = carrier.carrierName;
    
    
    _deviceArray = @[[NSString stringWithFormat:@"名称: %@", deviceName], [NSString stringWithFormat:@"设备: %@", productType], [NSString stringWithFormat:@"系统: %@", productName], [NSString stringWithFormat:@"版本: %@(%@)", osVersion, osBuildVersion], [NSString stringWithFormat:@"运营商: %@", carrierName]];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _deviceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"CellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = _deviceArray[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
