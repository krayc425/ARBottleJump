//
//  UIViewControllerExtension.swift
//  ARBottleJump
//
//  Created by 宋 奎熹 on 2018/1/3.
//  Copyright © 2018年 宋 奎熹. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func alert(message: String) {
        let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
}
