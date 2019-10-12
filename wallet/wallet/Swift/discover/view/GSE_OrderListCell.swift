//
//  GSE_OrderListCell.swift
//  GSEWallet
//
//  Created by 付金亮 on 2019/1/3.
//  Copyright © 2019 VeslaChi. All rights reserved.
//

import UIKit

class GSE_OrderListCell: UITableViewCell {
    @IBOutlet weak var ordernoLabel: UILabel!
    @IBOutlet weak var carnoLabel: UILabel!
    @IBOutlet weak var costsLabel: UILabel!
    @IBOutlet weak var rideTimeLabel: UILabel!
    @IBOutlet weak var orderStatusLabel: UILabel!
    
    var model: OfoOrderModel? {
        didSet{
            configureWithModel(model)
        }
    }
    class var indentifier: String {
        return String(describing: self)
    }
    class var nib: UINib {
        print(indentifier)
        return UINib(nibName: indentifier, bundle: nil)
    }
    func configureWithModel(_ model: OfoOrderModel?) {
        guard let m = model else {return}
        ordernoLabel.text = m.orderno
        carnoLabel.text = m.carno
        // TODO: 订单状态有待完善，需要后端配合
        switch m.status {
        case 0: // 骑行中
            orderStatusLabel.text = "ridding"
            break
        case 1: // 未支付
            orderStatusLabel.text = "no pay"
            break
        case 2: // 已完成
            orderStatusLabel.text = "finished"
            break
        default:
            orderStatusLabel.text = "finished"
        }
        costsLabel.text = {
            var currency = m.currency
            let index = String.Index.init(encodedOffset: 1)
            currency = String(currency.suffix(from: index))
            return currency + "\(m.price)"
        }()
        rideTimeLabel.text = {
            let time = m.t
            let ss = time
            let s = ss % 60
            let mm = ss / 60
            let m = mm % 60
            let hh = mm / 60
            let hourStr = String(format: "%02d", hh)
            let minuteStr = String(format: "%02d", m)
            let secondStr = String(format: "%02d", s)
            return "\(hourStr):\(minuteStr):\(secondStr)"
        }()
    }
}
