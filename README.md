# [GYInpurchase](https://github.com/gaoyuexit/GYInpurchase)

## Overview

**[GYInpurchase](https://github.com/gaoyuexit/GYInpurchase)**  is a simple example to show how to use in-app purchase. (这个是一个简单的实例demo来展示如何使用内购)

## How to use

```objective-c
//购买
let productIdentifiers: Set<String> = ["a", "b", "c"]

Inpurchase.default.start(productIdentifiers: productIdentifiers, successBlock: { () -> Order in
    return (productIdentifiers: "a", applicationUsername: "该用户的id或用户的唯一标识符")
}, receiptBlock: { (receipt, transaction, queue) in
    //交易成功返回了凭证
    let data = InpurchaseAPIData(accountID: transaction.payment.applicationUsername,
                                 transactionID: transaction.transactionIdentifier,
                                 receiptData: receipt)
    LPNetworkManager.request(Router.verifyReceipt(data)).showToast().loading(in: self.view).success {[weak self] in
        showToast("购买成功")
        // 记住一定要请求自己的服务器成功之后, 再移除此次交易
        queue.finishTransaction(transaction)

        }.fail {
            print("向服务器发送凭证失败")
    }
}, failBlock: { (error) in
    print(error)
})

//应用启动后
Inpurchase.default.unFinishedTransaction = {(receipt, transaction, queue) in
    // 如果存在掉单情况就会走这里
    let data = InpurchaseAPIData(accountID: transaction.payment.applicationUsername,
                                 transactionID: transaction.transactionIdentifier,
                                 receiptData: receipt)
    LPNetworkManager.request(Router.verifyReceipt(data)).showToast().loading(in: self.view).success {[weak self] in
        showToast("恢复购买成功")
        // 记住一定要请求自己的服务器成功之后, 再移除此次交易
        queue.finishTransaction(transaction)

        }.fail {
            print("向服务器发送凭证失败")
    }
}
```

## Author

gaoyu, gaoyuexit@gmail.com

## License

[GYInpurchase](https://github.com/gaoyuexit/GYInpurchase) is available under the MIT license. See the LICENSE file for more info.

