//
//  UnlockWalletSwipeViewController.swift
//  loopr-ios
//
//  Created by xiaoruby on 2/17/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

class UnlockWalletSwipeViewController: SwipeViewController, QRCodeScanProtocol {

    private var types: [UnlockWalletType] = [.mnemonic, .keystore, .privateKey]
    private var viewControllers: [UIViewController] = [MnemonicViewController(), UnlockKeystoreViewController(), PrivateKeyViewController()]
    var options = SwipeViewOptions()
    
    var valueFromQRCodeScanning: String?
    var typeFromQRCodeScanning: QRCodeType?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = NSLocalizedString("Unlock Wallet", comment: "")
        setBackButton()
        
        self.navigationController?.isNavigationBarHidden = false
        
        options.swipeTabView.height = 44
        options.swipeTabView.underlineView.height = 1
        options.swipeTabView.underlineView.margin = 30

        options.swipeTabView.style = .segmented

        options.swipeTabView.itemView.font = UIFont.init(name: FontConfigManager.shared.getRegular(), size: 17) ?? UIFont.systemFont(ofSize: 17)

        swipeView.reloadData(options: options)
        
        let button = UIBarButtonItem(image: UIImage.init(named: "Scan"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.pressScanButton(_:)))
        self.navigationItem.rightBarButtonItem = button
    }
    
    func setResultOfScanningQRCode(valueSent: String, type: QRCodeType) {
//        print("value from QR Controller: \(valueSent)")
//        let controller = self.viewControllers[2] as! PrivateKeyViewController
//        controller.privateKeyTextView.text = valueSent
        print("value from scanning: \(valueSent)")
        self.valueFromQRCodeScanning = valueSent
        self.typeFromQRCodeScanning = type
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let valueToDisplay = valueFromQRCodeScanning {

            if typeFromQRCodeScanning == QRCodeType.privateKey {
                let controller = self.viewControllers[2] as! PrivateKeyViewController
                controller.privateKeyTextView.text = valueToDisplay
                self.swipeView.jump(to: 2, animated: true)
            }
            else if typeFromQRCodeScanning == QRCodeType.keystore {
                let controller = self.viewControllers[1] as! UnlockKeystoreViewController
                controller.keystoreContentTextView.text = valueToDisplay
                self.swipeView.jump(to: 1, animated: true)
            }
            else if typeFromQRCodeScanning == QRCodeType.mnemonic {
                let controller = self.viewControllers[0] as! MnemonicViewController
                controller.mnemonicWordTextView.text = valueToDisplay
                self.swipeView.jump(to: 0, animated: true)
            }
            else {
                showAlert(decodedURL: valueToDisplay)
                
            }
            
            self.view.setNeedsDisplay()
        }
    }
    
    @objc func pressScanButton(_ button: UIBarButtonItem) {
        print("pressScanButton")
        let viewController = ScanQRCodeViewController()
        viewController.delegate = self
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    // MARK: - Delegate
    override func swipeView(_ swipeView: SwipeView, viewWillSetupAt currentIndex: Int) {
        // print("will setup SwipeView")
    }
    
    override func swipeView(_ swipeView: SwipeView, viewDidSetupAt currentIndex: Int) {
    }
    
    override func swipeView(_ swipeView: SwipeView, willChangeIndexFrom fromIndex: Int, to toIndex: Int) {
        // print("will change from item \(fromIndex) to item \(toIndex)")
    }
    
    override func swipeView(_ swipeView: SwipeView, didChangeIndexFrom fromIndex: Int, to toIndex: Int) {
        // print("did change from item \(fromIndex) to section \(toIndex)")
    }
    
    // MARK: DataSource
    override func numberOfPages(in swipeView: SwipeView) -> Int {
        return types.count
    }
    
    override func swipeView(_ swipeView: SwipeView, titleForPageAt index: Int) -> String {
        return types[index].description
    }
    
    override func swipeView(_ swipeView: SwipeView, viewControllerForPageAt index: Int) -> UIViewController {
        var viewController: UIViewController
        let type = types[index]

        switch type {
        case .mnemonic:
            viewController = viewControllers[0]
        case .keystore:
            viewController = viewControllers[1]
        case .privateKey:
            viewController = viewControllers[2]
        }

        self.addChildViewController(viewController)
        return viewController
    }
    
    func showAlert(decodedURL: String) {
        let alertPrompt = UIAlertController(title: "QR Code type doesn't fit here", message: "\(decodedURL)", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)

        alertPrompt.addAction(cancelAction)
        
        present(alertPrompt, animated: true, completion: nil)
    }

}
