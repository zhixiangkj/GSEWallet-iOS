//
//  GSE_OrderList.swift
//  GSEWallet
//
//  Created by 付金亮 on 2019/1/2.
//  Copyright © 2019 VeslaChi. All rights reserved.
//

import UIKit
import Alamofire
@objc class GSE_OrderList: UIViewController {
    var arr = [[
        "avatarUrl": "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=2796238002,2709204796&fm=27&gp=0.jpg",
        "authorName": "fjl",
        "date":"2019-1-1",
        "title":"半行代码实现字典转模型",
        "previewText": "Swift 4最重大的一个变化就是增加了一个Codable协议，解决了在Swift中进行字典<->模型转换的问题。"
        ]]
    private let dataRequest = GSE_OrderListDataRequest()
    fileprivate var tableData = [OfoOrderModel](){
        didSet {
            myTableView?.reloadData()
        }
    }
    @IBOutlet weak var myTableView: UITableView?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // TODO: 开发调试使用，后续删除
        self.navigationController!.navigationBar.isHidden = false
        dataRequest.requestData()
    }
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        self.title = "Order"
        dataRequest.delegate = self
        if let tableView = myTableView  {
            tableView.tableFooterView = UIView.init()
            tableView.register(GSE_OrderListCell.nib, forCellReuseIdentifier: GSE_OrderListCell.indentifier)
            let rightBarItem = UIBarButtonItem.init(title: "Clear", style: .plain, target: self, action: #selector(handleClearButtonTapped))
            self.navigationItem.rightBarButtonItem = rightBarItem;
        }
    }
    // 点击"clear"按钮
    func handleClearButtonTapped() {
        UserDefaults.standard.set([], forKey: "ofo-orders")
        dataRequest.requestData()
        myTableView?.reloadData()
    }
}
// MARK: - UITableViewDelegate
extension GSE_OrderList: UITableViewDelegate {
    
}
// MARK: - UITableViewDataSource
extension GSE_OrderList: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: GSE_OrderListCell.indentifier) as? GSE_OrderListCell {
            cell.contentView.backgroundColor = UIColor.init(hex: 0xdddddd, a: 0.8)
            cell.model = tableData[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
}
// MARK: - GSE_OrderListDataRequestDelegate
extension GSE_OrderList: GSE_OrderListDataRequestDelegate {
    func didRecieveDataUpdate(data: [OfoOrderModel]) {
        tableData = data
    }
    
    func didFailDataUpdateWithError(error: Error) {
        print(error)
        self.view.makeToast("Service error");
    }
}
