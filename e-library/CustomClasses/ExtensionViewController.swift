//
//  ExtensionViewController.swift
//  Google Books
//
//  Created by Iskandar Fazliddinov on 17/01/23.
//

import Foundation
import UIKit

extension UIViewController {
    
    func getTopLevel(vc : UIViewController) -> UIViewController {
        var topController: UIViewController = vc
        
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }
        
        return topController
    }
    
    func showWaitWindow() {
        let wait = Helper.getWaitController()
        let top = getTopLevel(vc: self)
        wait.view.frame = top.view.bounds // view.frame
        top.addChild(wait)
        top.view.addSubview(wait.view)
        top.view.bringSubviewToFront(wait.view)
        wait.didMove(toParent: top)
    }
    
    func hideWaitWindow() {
        Helper.getWaitController().willMove(toParent: nil)
        Helper.getWaitController().view.removeFromSuperview()
        Helper.getWaitController().removeFromParent()
        Helper.waitController = nil
    }
    
}
