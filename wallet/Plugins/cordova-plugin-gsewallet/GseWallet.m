/********* GseWallet.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import <CoreLocation/CoreLocation.h>
#import "GSEWallet-Swift.h"

@interface GseWallet : CDVPlugin {
  // Member variables go here.
}

// gse钱包支付功能
- (void)pay:(CDVInvokedUrlCommand*)command;
// 关闭访问本网页的浏览器
- (void)closeWebView:(CDVInvokedUrlCommand*)command;
// 定位服务用户是否授权
- (void)isLocationAuthorized:(CDVInvokedUrlCommand*)command;
// 保存ofo订单，如果订单已经存在，就更新订单 {status: 订单状态，0:骑行中，1:骑行结束未支付，2:已支付}
- (void)saveOfoOrder:(CDVInvokedUrlCommand*)command;
@end

@implementation GseWallet

#pragma mark gse钱包支付功能
- (void)pay:(CDVInvokedUrlCommand*)command
{
    [self getParamsFromCommand:command Success:^(NSDictionary *params) {
        [self handlePay:command Params:params];
    }];
}
- (void)handlePay: (CDVInvokedUrlCommand *)command Params:(NSDictionary *)params {
    NSNumber *amount = params[@"amount"];
    NSString *errorMessage = nil;
    if (amount == nil) {
        errorMessage = @"Field amount is missing";
    } else if (![amount isKindOfClass:[NSNumber class]]) {
        errorMessage = @"Field amount is a number";
    }
    if (errorMessage != nil) {
        [self.viewController.view makeToast: errorMessage];
        [self errorFeedback:command ErrorCode: amount == nil ? 1 : 2 ErrorMessage:errorMessage];
        return;
    }
    
    NSString *country = params[@"country"];
    NSString *currency = params[@"currency"];
    [[GSE_Pay shared] popupPayViewWithAmount:[amount doubleValue] country:country currency:currency attachView:self.viewController.view completion:^(GSE_PayStatus status, NSDictionary *paymentInfo) {
        NSString *message = nil;
        switch (status) {
            case GSE_PayStatusSuccess:
                message = @"Pay for success";
                break;
            case GSE_PayStatusCancel:
                message = @"Pay for cancel";
                break;
            case GSE_PayStatusError:
                message = @"Pay for error";
                break;
            default:
                message = @"";
                break;
        }
        [self successFeedback:command SuccessCode: status SuccessMessage:message SuccessData:paymentInfo];
    }];
}
#pragma mark 关闭访问本网页的浏览器
- (void)closeWebView:(CDVInvokedUrlCommand*)command {
    [self.viewController.navigationController popViewControllerAnimated:YES];
    [self successFeedback:command SuccessMessage:@"webView closed"];
}
#pragma mark 定位服务用户是否授权
- (void)isLocationAuthorized:(CDVInvokedUrlCommand*)command {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) { // 定位未授权
        [self errorFeedback:command ErrorMessage:@"location is unauthorized"];
    } else { // 定位授权
        [self successFeedback:command SuccessMessage:@"location is authorized"];
    }

}
#pragma mark 保存ofo订单
- (void)saveOfoOrder:(CDVInvokedUrlCommand *)command {
    [self getParamsFromCommand:command Success:^(NSDictionary *params) {
        [self handleSaveOfoOrder:command Params:params];
    }];
    
}
- (void)handleSaveOfoOrder:(CDVInvokedUrlCommand *)command Params:(NSDictionary *)order {
    NSArray *orders =[[NSUserDefaults standardUserDefaults] arrayForKey:@"ofo-orders"];
    NSMutableArray *newArr = [NSMutableArray arrayWithArray:orders == nil ? @[] : orders];
    // 检测订单是否已存在
    BOOL isOrderExist = NO;
    for (int i = 0; i < newArr.count; i++) {
        NSDictionary *item = newArr[i];
        if ([item[@"orderno"] isEqualToString: order[@"orderno"]]) {// 订单已存在，替换
            isOrderExist = YES;
            if ([order[@"status"] isEqual: @2]) { // 订单支付
                NSMutableDictionary *newItem = [[NSMutableDictionary alloc]initWithDictionary:item];
                [newItem setObject:order[@"status"] forKey:@"status"];
                [newArr replaceObjectAtIndex:i withObject: newItem];
            } else {
                [newArr replaceObjectAtIndex:i withObject: order];
            }
        }
    }
    if (!isOrderExist && [order[@"status"] isEqual: @0]) { // 骑行开始
        [newArr addObject:order];
    }
    [[NSUserDefaults standardUserDefaults] setObject:newArr forKey:@"ofo-orders"];
    [self successFeedback:command SuccessMessage:@"Save order successfully"];
}
#pragma mark - 辅助工具
#pragma mark 从CDVInvokedUrlCommand获取参数
- (void)getParamsFromCommand:(CDVInvokedUrlCommand *)command Success: (void(^)(NSDictionary* params)) successBlock{
    [self getParamsFromCommand:command Success:successBlock Error:nil];
}
- (void)getParamsFromCommand:(CDVInvokedUrlCommand *)command Success: (void(^)(NSDictionary* params)) successBlock Error: (void(^)(NSDictionary* error)) errorBlock {
    NSString* echo = [command.arguments objectAtIndex:0];
    if (echo != nil && [echo length] > 0) {
        NSDictionary *paramsDic = [JSON parseWithDictStr: echo];
        if (successBlock != nil) {
            successBlock(paramsDic);
        }
    } else {
        NSDictionary* errorDic = @{
                                @"code": @1,
                                @"message": @"You don't pass parameters"
                                };
        [self errorFeedback:command Data:errorDic];
        if (errorBlock != nil) {
            errorBlock(errorDic);
        }
    }
}
#pragma mark 操作成功的反馈
- (void) successFeedback:(CDVInvokedUrlCommand *)command Params:(NSDictionary *) params{
    CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:params];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}
- (void) successFeedback:(CDVInvokedUrlCommand *)command SuccessCode:(int) code SuccessMessage: (NSString *)message SuccessData:(NSDictionary *) dataDic{
    [self successFeedback:command Params:@{
                                           @"code": [NSNumber numberWithInt:code],
                                           @"message": message,
                                           @"data": dataDic == nil ? @{} : dataDic
                                           }];
}
- (void) successFeedback:(CDVInvokedUrlCommand *)command SuccessCode:(int) code SuccessMessage: (NSString *)message{
    [self successFeedback:command SuccessCode:code SuccessMessage:message SuccessData:nil];
}
- (void) successFeedback:(CDVInvokedUrlCommand *)command SuccessMessage: (NSString *)message{
    [self successFeedback:command SuccessCode:0 SuccessMessage:message];
}
#pragma mark 操作出错的反馈
- (void) errorFeedback:(CDVInvokedUrlCommand *)command Data:(NSDictionary *) errorDic{
    CDVPluginResult* error = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:errorDic];
    [self.commandDelegate sendPluginResult:error callbackId:command.callbackId];
}
- (void) errorFeedback:(CDVInvokedUrlCommand *)command ErrorCode:(int) code ErrorMessage: (NSString *)message{
    NSDictionary* errorDic = @{
                               @"code": [NSNumber numberWithInt:code],
                               @"message": message
                               };
    [self errorFeedback:command Data:errorDic];
}
- (void) errorFeedback:(CDVInvokedUrlCommand *)command ErrorMessage: (NSString *)message{
    [self errorFeedback:command ErrorCode:1 ErrorMessage:message];
}
@end
