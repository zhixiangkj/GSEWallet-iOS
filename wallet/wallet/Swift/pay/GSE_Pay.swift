//
//  GSE_Pay.swift
//  ios+cordovaDemo
//
//  Created by 付金亮 on 2018/12/4.
//  Copyright © 2018 付金亮. All rights reserved.
//
import Foundation

func imageWithColor (color: UIColor) -> (UIImage) {
    let rect = CGRect.init(x: 0, y: 0, width: 1, height: 1)
    UIGraphicsBeginImageContext(rect.size)
    let context = UIGraphicsGetCurrentContext()
    context!.setFillColor(color.cgColor);
    context!.fill(rect)
    let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return image
}
@objc public enum GSE_PayType: Int { // gse钱包的支付类型
    case gseToken = 0 // gse代币支付
    case stripe = 1 // stripe（信用卡）支付
}
@objc public enum GSE_PayStatus: Int { // gse钱包的支付状态
    case success = 0 // 支付成功
    case cancel // 支付取消
    case error // 支付出错
}
class GSE_Pay: NSObject, StripePayDelegate, PopupDelegate {
    let stripePay = StripePay.shared
    var amount: Double = 0
    var country: String?
    var currency: String?
    var selectedPaymentMethod: STPPaymentMethod?
    var handlePayFinished: ((_ :GSE_PayStatus, _ :[AnyHashable: Any]?) -> Void)? = nil
    var loading: Bool = true
    var isloadStripeError: Bool = false
    var selectedPayMethod = GSE_PayType.stripe
    // 单例
    @IBOutlet weak var stripeButton: UIButton?
    @IBOutlet weak var stripeActivityIndicator: UIActivityIndicatorView?
    @IBOutlet weak var payButton: UIButton?
     @IBOutlet weak var retryButton: UIButton?
    @IBOutlet weak var gsePayCheck: UIView?
    @IBOutlet weak var stripeCheck: UIView?
    @objc static let shared = GSE_Pay()
    override init() {
        super.init()
        stripePay.delegate = self
        stripePay.paymentContext.hostViewController = UIApplication.shared.delegate?.window!!.rootViewController
    }
    // 支付(gse钱包的全部支付方案)
    @objc public func pay(amount: Double,country: String?, currency: String?, type: GSE_PayType) {
        switch type {
        case .stripe: // stripe（信用卡）支付
            stripePay.pay(amount: Int(100 * amount), country: country, currency: currency)
        case .gseToken: // gse代币支付
            print("之后增加gse代币支付:", amount)
        }
    }
    // 更新支付方式选择的check
    private func updatePaymentMethodCheck () {
//        gsePayCheck?.alpha = selectedPayMethod == .gseToken ? 1 : 0
//        stripeCheck?.alpha = selectedPayMethod == .stripe ? 1 : 0
    }
    // 更新stripe支付的视图
    private func updateStripeView () {
        retryButton?.alpha = isloadStripeError ? 1 : 0
        stripeButton?.isEnabled = !loading && !isloadStripeError
        stripeButton?.setTitleColor(isloadStripeError ? UIColor.red : UIColor.lightGray, for: .normal)
        payButton?.isEnabled = !loading && !isloadStripeError
        if loading {
            stripeActivityIndicator?.startAnimating()
            stripeActivityIndicator?.alpha = 1
            stripeButton?.setTitle("  loading...", for: .normal)
        } else {
            stripeActivityIndicator?.stopAnimating()
            stripeActivityIndicator?.alpha = 0
            let title: String = isloadStripeError ? "  Fail to load a card" : "  Click add a card"
            stripeButton?.setTitle(title, for: .normal)
        }
        guard let selectedPaymentMethod = selectedPaymentMethod else {
            return
        }
        stripeButton?.setImage(selectedPaymentMethod.image, for: .normal)
        stripeButton?.setTitle(" " + selectedPaymentMethod.label, for: .normal)
        stripeButton?.setTitleColor(UIColor.green, for: .normal)
    }
    // 弹出支付方式选择框
    @objc public func popupPayView(amount: Double, country: String?, currency: String?, attachView: UIView?, completion: @escaping (_ status: GSE_PayStatus, _ paymentInfo: [AnyHashable: Any]?) -> Void) {
        self.amount = amount
        self.country = country
        self.currency = currency
        self.handlePayFinished = completion
        let view: UIView = Bundle.main.loadNibNamed("PayView", owner: self, options: nil)?.first as! UIView;
        payButton?.setTitleColor(UIColor.white, for: .disabled)
        payButton?.setBackgroundImage(imageWithColor(color: UIColor.init(white: 0.8, alpha: 1)), for: .disabled)
        view.frame.size.width = SCREEN_WIDTH
        view.frame.size.height = view.subviews[0].bounds.size.height
        Popup.shared.show(deliverV: view, superView: attachView)
        Popup.shared.delegate = self
        // 更新stripe支付的视图
        updateStripeView()
        // 更新支付方式选择的check
        updatePaymentMethodCheck()
    }
    // 关闭支付视图
    @objc public func closePayView () {
        Popup.shared.hide()
    }
    // MARK: - PayView Buttons Tapped
    // "Stripe pay"按钮点击
    @IBAction func handleStripePayButtonTapped(_ sender: Any) {
        guard !loading else {
            return  
        }
        stripePay.paymentContext.presentPaymentMethodsViewController()
    }
    // "PAY"按钮点击
    @IBAction func handlePayButtonTapped(_ sender: Any) {
        KEY_VIEW?.makeMaskActivity()
        pay(amount: amount, country: country, currency: currency, type: .stripe)
    }
    @IBAction func handleRetryButtonTapped(_ sender: Any) {
        isloadStripeError = false
        loading = true
        // 更新stripe支付的视图
        updateStripeView()
        stripePay.paymentContext.retryLoading()
    }
    @IBAction func handleStripeViewTapped(_ sender: Any) {
        selectedPayMethod = .stripe
        updatePaymentMethodCheck()
    }
    @IBAction func handleGsePayViewTapped(_ sender: Any) {
        selectedPayMethod = .gseToken
        updatePaymentMethodCheck()
    }
    // MARK: - StripePayDelegate
    func stripePayDidChange(paymentContext: STPPaymentContext) {
        loading = paymentContext.loading
        self.selectedPaymentMethod = paymentContext.selectedPaymentMethod
        // 更新stripe支付的视图
        updateStripeView()
    }
    func stripePay(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        loading = paymentContext.loading
        isloadStripeError = true
        self.selectedPaymentMethod = paymentContext.selectedPaymentMethod
        // 更新stripe支付的视图
        updateStripeView()
    }
    func stripePay(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?, charge: [AnyHashable : Any]?) {
        KEY_VIEW?.hideMaskActivity()
        switch status {
        case .success:
            Popup.shared.hide()
            self.handlePayFinished?(.success, charge)
            KEY_VIEW?.makeToast("Pay for success")
            break
        case .error:
            self.handlePayFinished?(.error, nil)
            // Present error to user
            if let requestRideError = error as? MainAPIClient.StripeRequestError {
                switch requestRideError {
                case .missingBaseURL:
                    print("[ERROR]: Please assign a value to `MainAPIClient.shared.baseURLString` before continuing. See `StripePay.swift`.")
                case .invalidResponse:
                    // Missing response from backend
                    KEY_VIEW?.makeToast("Server response error")
                    print("[ERROR]: Missing or malformed response when attempting to `MainAPIClient.shared.requestRide`. Please check internet connection and backend response formatting.");
                case .missingCustomerId:
                    KEY_VIEW?.makeToast("Client error")
                    print("[ERROR]: customerId is not available locally. It is quite possible that the device local store has lost customerId.");
                }
            } else {
                // Use generic error message
                print("[ERROR]: Unrecognized error while finishing payment: \(String(describing: error))");
                KEY_VIEW?.makeToast("Payment failed")
            }
        case .userCancellation:
            self.handlePayFinished?(.cancel, nil)
            KEY_VIEW?.makeToast("Payment cancelled")
            break
        }
    }
    // MARK: - StripePayDelegate
    func popupMaskTapped() {
        self.handlePayFinished?(.cancel, nil)
    }
}
