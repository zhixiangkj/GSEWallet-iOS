//
//  GSE_OrderListCellModel.swift
//  GSEWallet
//
//  Created by 付金亮 on 2019/1/3.
//  Copyright © 2019 VeslaChi. All rights reserved.
//

import Foundation
import Alamofire
struct OfoOrderModel: Codable {
    // common
//    var lock: [AnyHashable: Any]
    var status: Int
    var code: Int
    var message: String
    var orderno: String
    var currency: String
    var carno: String
    var price: Float
    var penaltyPrice: String
    var t: Int64 // 骑行时间，单位秒
    
    // riding
    //    var payment: [AnyHashable: Any]
    var isSupportAutoPay: Int?
    var couponid: String?
    var total: Float?
    var coupon: String?
    var passTip: String?
    var rideTimePrice: String?
    var pass: String?
    var passDiscount: Int?
    var unlockPrice: String?
    
    // rided
    var isShowGse: Int?
    var gseBannerContent: String?
    var type: Int?
    var freeRideTime: String?
    var pwd: String?
    var isShowHelp: Int?
    var isHideRepair: Int?
    var orderTimeLen: Double?
    var refreshTime: Float?
    var notice: String?
    var noticeMessage: String?
    init(_ dic: [AnyHashable: Any]) {
        let data = try! JSONSerialization.data(withJSONObject: dic, options: [])
        self = try! JSONDecoder().decode(OfoOrderModel.self, from: data)
    }
}
class GSE_OrderListDataRequest {
    weak var delegate: GSE_OrderListDataRequestDelegate?
    let mookBaseURL = URL(string: "https://www.easy-mock.com/mock/5c2ddd08c8123b4eccf80345/gse-wallet")
    func requestData() {
//        let endpoint = "ofo-order"
//        guard
//            let url = URL(string: endpoint, relativeTo: mookBaseURL) else {
//                return
//        }
//        Alamofire.request(url, method:.get).responseJSON { (response) in
//            guard let value = response.result.value as? [AnyHashable: Any],
//            let data = value["data"] as? [AnyHashable: Any],
//            let orders = data["orders"] as? [AnyObject]
//            else{
//                if let error = response.result.error {
//                    self.delegate?.didFailDataUpdateWithError(error: error)
//                }
//                return
//            }
//            self.setDataWithResponse(response: orders)
//        }
//        UserDefaults.standard.set([], forKey: "ofo-orders");
        if let orders = UserDefaults.standard.array(forKey: "ofo-orders") {
            print(JSON.stringify(orders))
            self.setDataWithResponse(response: orders as [AnyObject])
        }
        
    }
    private func setDataWithResponse(response: [AnyObject]) {
        var data = [OfoOrderModel]()
        for item in response {
            if let newItem = item as? [AnyHashable : Any] {
                data.append(OfoOrderModel.init(newItem))
            }
        }
        delegate?.didRecieveDataUpdate(data: data)
    }
}
protocol GSE_OrderListDataRequestDelegate: class {
    func didRecieveDataUpdate(data: [OfoOrderModel])
    func didFailDataUpdateWithError(error: Error)
}
