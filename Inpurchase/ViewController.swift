//
//  ViewController.swift
//  Inpurchase
//
//  Created by 郜宇 on 2017/5/25.
//  Copyright © 2017年 Loopeer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // 点击购买
//        let productIdentifiers: Set<String> = ["a", "b", "c"]
//        
//        Inpurchase.default.start(productIdentifiers: productIdentifiers, successBlock: { () -> Order in
//            return (productIdentifiers: "a", applicationUsername: "该用户的id或改用户的唯一标识符")
//        }, receiptBlock: { (receipt, transaction, queue) in
//            //交易成功返回了凭证
//            let data = InpurchaseAPIData(accountID: transaction.payment.applicationUsername,
//                                         transactionID: transaction.transactionIdentifier,
//                                         receiptData: receipt)
//            LPNetworkManager.request(Router.verifyReceipt(data)).showToast().loading(in: self.view).success {[weak self] in
//                showToast("购买成功")
//                // 记住一定要请求自己的服务器成功之后, 再移除此次交易
//                queue.finishTransaction(transaction)
//        
//                }.fail {
//                    print("向服务器发送凭证失败")
//            }
//        }, failBlock: { (error) in
//            print(error)
//        })
    }
    
    
}

