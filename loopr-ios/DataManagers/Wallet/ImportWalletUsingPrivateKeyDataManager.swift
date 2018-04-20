//
//  ImportWalletUsingPrivateKeyDataManager.swift
//  loopr-ios
//
//  Created by xiaoruby on 4/19/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import Foundation

class ImportWalletUsingPrivateKeyDataManager {
    
    static let shared = ImportWalletUsingPrivateKeyDataManager()
    
    private init() {
        
    }

    // TODO: Use error handling
    func unlockWallet(privateKey privateKeyString: String) {
        print("Start to unlock a new wallet using the private key")
        let privateKey = Data(hexString: privateKeyString)!
        let key = try! KeystoreKey(password: "password", key: privateKey)
        let newAppWallet = AppWallet(address: key.address.description, privateKey: privateKeyString, password: "123456", name: "Wallet private key", active: true)
        
        AppWalletDataManager.shared.updateAppWalletsInLocalStorage(newAppWallet: newAppWallet)
        
        CurrentAppWalletDataManager.shared.setCurrentAppWallet(newAppWallet)
        print("Finished unlocking a new wallet")
    }
}
