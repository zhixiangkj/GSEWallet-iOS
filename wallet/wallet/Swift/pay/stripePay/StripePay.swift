//
//  StripePay.swift
//  ios+cordovaDemo
//
//  Created by 付金亮 on 2018/12/5.
//  Copyright © 2018 付金亮. All rights reserved.
//

private let publishableKey = "pk_test_O5N1418rxpxfcnHoklRxZvNJ"
private let baseURLString = STRIPE_SERVER_URL
private let appleMerchantIdentifier = "merchant.gse"
private let companyName = "Rocket Rides"

import Foundation
class StripePay: NSObject, STPPaymentContextDelegate {
    static let shared = StripePay()
    var charge: [AnyHashable: Any]?
    var paymentContext: STPPaymentContext
    weak var delegate: StripePayDelegate?
    // 初始化stripe支付
    override init () {
        // Stripe theme configuration
//        STPTheme.default().primaryBackgroundColor = UIColor.lightGray
//        STPTheme.default().primaryForegroundColor = UIColor.init(red: 0, green: 255, blue: 0, alpha: 0.3)
//        STPTheme.default().secondaryForegroundColor = UIColor.red
//        STPTheme.default().accentColor = UIColor.blue
//
        MainAPIClient.shared.baseURLString = baseURLString
        let customerContext = STPCustomerContext(keyProvider: MainAPIClient.shared)
        paymentContext = STPPaymentContext(customerContext: customerContext)
        super.init()
        paymentContext.delegate = self
        let payConfig: STPPaymentConfiguration =  STPPaymentConfiguration.shared()
        payConfig.companyName = companyName
        if (!publishableKey.isEmpty) {
            payConfig.publishableKey = publishableKey
        }
        if (!appleMerchantIdentifier.isEmpty) {
            payConfig.appleMerchantIdentifier = appleMerchantIdentifier
        }
        // Main API client configuration
    }
    // stripe支付
    public func pay (amount: Int, country: String?, currency: String?) {
        paymentContext.paymentAmount = amount
        if (country != nil) {
             paymentContext.paymentCountry = country!
        }
        if (currency != nil) {
            paymentContext.paymentCurrency = currency!
        }
        paymentContext.requestPayment()
    }
    // MARK: - STPPaymentContextDelegate
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        if let delegate = self.delegate {
            delegate.stripePayDidChange(paymentContext: paymentContext)
        }
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        if let delegate = self.delegate {
            delegate.stripePay(paymentContext, didFailToLoadWithError: error)
        }
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
        MainAPIClient.shared.createCharge(source: paymentResult.source.stripeID, amount: paymentContext.paymentAmount, currency: paymentContext.paymentCurrency) { (charge, error) in
            guard error == nil else {
                // Error while requesting ride
                completion(error)
                return
            }
            self.charge = charge
            completion(nil)
        }
}
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        if let delegate = self.delegate {
            delegate.stripePay(paymentContext, didFinishWith: status, error: error, charge: self.charge)
        }
    }
}

protocol StripePayDelegate: class {
    func stripePayDidChange(paymentContext: STPPaymentContext)
    func stripePay(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error)
    func stripePay(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?, charge: [AnyHashable: Any]?)
}
