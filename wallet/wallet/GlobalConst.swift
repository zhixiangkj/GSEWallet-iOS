//
//  GlobalConst.swift
//  ios+cordovaDemo
//
//  Created by 付金亮 on 2018/12/17.
//  Copyright © 2018 付金亮. All rights reserved.
//

import Foundation
//状态栏高度
let STATUS_BAR_HEIGHT = Float(UIApplication.shared.statusBarFrame.size.height)
//NavBar高度
let NAVIGATION_BAR_HEIGHT = Float(44)
//状态栏 ＋ 导航栏 高度
let STATUS_AND_NAVIGATION_HEIGHT = STATUS_BAR_HEIGHT + NAVIGATION_BAR_HEIGHT

//屏幕 rect
let SCREEN_RECT = UIScreen.main.bounds

let SCREEN_WIDTH = SCREEN_RECT.size.width

let SCREEN_HEIGHT = SCREEN_RECT.size.height

let CONTENT_HEIGHT = (SCREEN_HEIGHT - CGFloat(NAVIGATION_BAR_HEIGHT) - CGFloat(STATUS_BAR_HEIGHT))
#if DEBUG // 开发调试环境
let LOCAL_BASE_URL = "http://192.168.43.231" // 本地服务的内网地址
let STRIPE_SERVER_URL = LOCAL_BASE_URL + ":3000" // debug下的stripe支付的后台服务(本地服务)
let OFO_H5_URL = LOCAL_BASE_URL + ":8088" // debug下的ofo访问网站(本地服务)
#else // 生产环境
let STRIPE_SERVER_URL = "http://140.143.31.52:3000" // 非debug下的stripe支付的后台服务(远程服务)
let OFO_H5_URL = "https://dapp.gsenetwork.co" // 非debug下的ofo访问网站(远程服务)
#endif
// keyWindow
let KEY_WINDOW = UIApplication.shared.keyWindow
// keyWindow to UIView
let KEY_VIEW = KEY_WINDOW as UIView?
//UIColorFromRGB(rgbHex) [UIColor colorWithRed:((float)((rgbHex & 0xFF0000) >> 16))/255.0 green:((float)((rgbHex & 0xFF00) >> 8))/255.0 blue:((float)(rgbHex & 0xFF))/255.0 alpha:1.0]
func UIColorFromRGB(rgbHex: Int) -> (UIColor) {
    let red = (rgbHex & 0xFF0000) >> 16
    let green = (rgbHex & 0xFF00) >> 8
    let blue = rgbHex & 0xFF
    return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1.0)
}
class JSON: NSObject {
    // json字符串转字典
    static func parse (dictStr: String) -> [AnyHashable: Any] {
        guard let dict = JSON.parse(dictStr) as? [AnyHashable : Any] else {
            return [:]
        }
        return dict
    }
    // json字符串转数组
    static func parse (arrayStr: String) -> Array<Any> {
        guard let array = JSON.parse(arrayStr) as? Array<Any> else {
            return []
        }
        return array
    }
    // json字符串转任意类型
    static private func parse (_ anyString: String) -> Any {
        let jsonData:Data = anyString.data(using: .utf8)!
        let json = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        return json as Any
    }
    // 字典转json字符串
    static func stringify (dict: [AnyHashable: Any]) -> String {
        return JSON.stringify(dict as Any)
    }
    // 数组转json字符串
    static func stringify (array: Array<Any>) -> String {
        return JSON.stringify(array as Any)
    }
    // 任意类型转json字符串
    static func stringify (_ object: Any) -> String {
        let data = try? JSONSerialization.data(withJSONObject: object, options: []) as NSData
        let JSONString = NSString(data:data! as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
    }
}
