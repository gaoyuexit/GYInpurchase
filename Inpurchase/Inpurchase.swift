//
//  Inpurchase.swift
//  Inpurchase
//
//  Created by 郜宇 on 2017/5/25.
//  Copyright © 2017年 Loopeer. All rights reserved.
//

import Foundation
import StoreKit

enum InpurchaseError: Error {
    /// 没有内购许可
    case noPermission
    /// 不存在该商品: 商品未在appstore中\商品已经下架
    case noExist
    /// 交易结果未成功
    case failTransactions
    /// 交易成功但未找到成功的凭证
    case noReceipt
}

typealias Order = (productIdentifiers: String, applicationUsername: String)

class Inpurchase: NSObject, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    
    static let `default` = Inpurchase()
    
    /// 掉单/未完成的订单回调 (凭证, 交易, 交易队列)
    var unFinishedTransaction: ((String, SKPaymentTransaction, SKPaymentQueue) -> ())?
    
    private var sandBoxURLString = "https://sandbox.itunes.apple.com/verifyReceipt"
    private var buyURLString = "https://buy.itunes.apple.com/verifyReceipt"
    
    /// 保证每次只能有一次交易
    private var isComplete: Bool = true
    private var products: [SKProduct] = []
    private var failBlock: ((InpurchaseError) -> ())?
    /// 交易完成的回调 (凭证, 交易, 交易队列)
    private var receiptBlock: ((String, SKPaymentTransaction, SKPaymentQueue) -> ())?
    private var successBlock: (() -> Order)?
    
    private override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    deinit {
        SKPaymentQueue.default().remove(self)
    }
    
    
    /// 开始向Apple Store请求产品列表数据，并购买指定的产品，得到Apple Store的Receipt，失败回调
    ///
    /// - Parameters:
    ///   - productIdentifiers: 请求指定产品
    ///   - successBlock: 请求产品成功回调，这个时候可以返回需要购买的产品ID和用户的唯一标识，默认为不购买
    ///   - receiptBlock: 得到Apple Store的Receipt和transactionIdentifier，这个时候可以将数据传回后台或者自己去post到Apple Store
    ///   - failBlock: 失败回调
    func start(productIdentifiers: Set<String>,
               successBlock: (() -> Order)? = nil,
               receiptBlock: ((String, SKPaymentTransaction, SKPaymentQueue) -> ())? = nil,
               failBlock: ((InpurchaseError) -> ())? = nil) {
        
        guard isComplete else { return }
        defer { isComplete = false }
        
        let request = SKProductsRequest(productIdentifiers: productIdentifiers)
        request.delegate = self
        request.start()
        
        self.successBlock = successBlock
        self.receiptBlock = receiptBlock
        self.failBlock = failBlock
    }
    
    //MARK: - SKProductsRequestDelegate
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        products = response.products
        guard let order = successBlock?() else { return }
        buy(order)
    }
    
    /// 购买给定的order的产品
    private func buy(_ order: Order) {
        
        let p = products.first { $0.productIdentifier == order.productIdentifiers }
        guard let product = p else { failBlock?(.noExist); return }
        guard SKPaymentQueue.canMakePayments() else { failBlock?(.noPermission); return }
        
        let payment = SKMutablePayment(product: product)
        /// 发起支付时候指定用户的username, 在掉单时候验证防止切换账号导致充值错误
        payment.applicationUsername = order.applicationUsername
        SKPaymentQueue.default().add(payment)
    }
    
    //MARK: - SKPaymentTransactionObserver
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
       
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                // appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
                guard let receiptUrl = Bundle.main.appStoreReceiptURL,
                      let receiptData = NSData(contentsOf: receiptUrl) else { failBlock?(.noReceipt);return }
                
                let receiptString = receiptData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))

                if let receiptBlock = receiptBlock {
                    receiptBlock(receiptString, transaction, queue)
                }else{ // app启动时恢复购买记录
                    unFinishedTransaction?(receiptString, transaction, queue)
                }
                isComplete = true
            case .failed:
                failBlock?(.failTransactions)
                queue.finishTransaction(transaction)
                isComplete = true
            case .restored: // 购买过 对于购买过的商品, 回复购买的逻辑
                queue.finishTransaction(transaction)
                isComplete = true
            default:
                break
            }
        }
    }
}
