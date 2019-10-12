//
//  MainAPIClient.swift
//  RocketRides
//
//  Created by Romain Huet on 5/26/16.
//  Copyright © 2016 Romain Huet. All rights reserved.
//

import Alamofire

 class MainAPIClient: NSObject, STPEphemeralKeyProvider {
    enum StripeRequestError: Error {
        case missingBaseURL
        case missingCustomerId
        case invalidResponse
    }
    static let shared = MainAPIClient()
    var baseURLString = ""
    
    func createCharge(source: String, amount: Int, currency: String, completion: @escaping STPJSONResponseCompletionBlock) {
        let endpoint = "charge"
        guard
            !baseURLString.isEmpty,
            let baseURL = URL(string: baseURLString),
            let url = URL(string: endpoint, relativeTo: baseURL) else {
                completion(nil, StripeRequestError.missingBaseURL)
                return
        }
        guard let customerId = UserDefaults.standard.string(forKey: "stripe-customerId") as String? else {
            completion(nil, StripeRequestError.missingCustomerId)
            return
        }
        
        let parameters: [String: Any] = [
            "source": source,
            "amount": amount,
            "currency": currency,
            "customerId": customerId
        ]
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { (response) in
            guard let data = response.result.value as? [AnyHashable: Any],
            var charge = data["charge"] as? [AnyHashable: Any]
            else {
                completion(nil, StripeRequestError.invalidResponse)
                return
            }
            charge["source"] = nil
            charge["customer"] = nil
            completion(charge, nil)
        }
    }
    // MARK: - STPEphemeralKeyProvider
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        let endpoint = "ephemeral_keys"
        guard
            !baseURLString.isEmpty,
            let baseURL = URL(string: baseURLString),
            let url = URL(string: endpoint, relativeTo: baseURL) else {
                completion(nil, StripeRequestError.missingBaseURL)
                return
        }
       
        var parameters: [String: Any] = ["apiVersion": apiVersion]
         // 从本地存储中获取stripe客户id
        let customerId = UserDefaults.standard.string(forKey: "stripe-customerId")
        if customerId != nil {
            parameters["customerId"] = customerId!
        }
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { (response) in
            guard let data = response.result.value as? [AnyHashable: Any],
            let key = data["key"] as? [AnyHashable: Any]
            else {
                completion(nil, StripeRequestError.invalidResponse)
                return
            }
            completion(key, nil)
            guard let newCustomerId = data["customerId"] as? String else {return}
            // 如果接口返回的customerId和本地缓存过的不一致，保存新的customerId到本地
            if (customerId != newCustomerId) {
                UserDefaults.standard.set(newCustomerId, forKey: "stripe-customerId")
                UserDefaults.standard.synchronize()
            }
        }
    }

}
