//
//  AppDelegate.swift
//  Inpurchase
//
//  Created by 郜宇 on 2017/5/25.
//  Copyright © 2017年 Loopeer. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
//        Inpurchase.default.unFinishedTransaction = {(receipt, transaction, queue) in
//            // 如果存在掉单情况就会走这里
//            let data = InpurchaseAPIData(accountID: transaction.payment.applicationUsername,
//                                         transactionID: transaction.transactionIdentifier,
//                                         receiptData: receipt)
//            LPNetworkManager.request(Router.verifyReceipt(data)).showToast().loading(in: self.view).success {[weak self] in
//                showToast("恢复购买成功")
//                // 记住一定要请求自己的服务器成功之后, 再移除此次交易
//                queue.finishTransaction(transaction)
//                
//                }.fail {
//                    print("向服务器发送凭证失败")
//            }
//        }
        
        return true
    }
}

