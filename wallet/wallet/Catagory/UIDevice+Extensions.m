//
//  UIDevice+Extensions.m
//  wallet
//
//  Created by user on 26/09/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "UIDevice+Extensions.h"
#import <sys/utsname.h>

#define k_device_clientid   @"clientid"
#define k_device_name       @"device_name"
#define k_device_model      @"device_model"
#define k_device_model_name @"device_model_name"
#define k_system_version    @"system_version"
#define k_system_name       @"system_name"

#define k_app_bundleid     @"CFBundleIdentifier"
#define k_app_version      @"CFBundleVersion"
#define k_app_shortversion @"CFBundleShortVersionString"
#define k_app_channel      @"channel"

@implementation UIDevice (Extensions)

- (NSString*)deviceModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

+ (NSDictionary *)deviceInfo{
    NSString *bundleid = [[[NSBundle mainBundle] infoDictionary] objectForKey:k_app_bundleid];
    NSString *shortVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:k_app_shortversion];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:k_app_version];
    
    NSString *device_name = [[UIDevice currentDevice] name];
    NSString *device_model = [[UIDevice currentDevice] model];
    NSString *system_version = [[UIDevice currentDevice] systemVersion];
    NSString *system_name = [[UIDevice currentDevice] systemName];
    NSString *device_model_name = [[UIDevice currentDevice] deviceModel];
    
    return @{
             k_app_bundleid : bundleid?:@"",
             k_app_shortversion : shortVersion?:@"",
             k_app_version:version?:@"",
             k_device_name  : device_name?:@"",
             k_device_model : device_model?:@"",
             k_device_model_name : device_model_name?:@"",
             k_system_version: system_version?:@"",
             k_system_name: system_name?:@"",
             k_app_channel : @"testflight"
             };
}
@end
