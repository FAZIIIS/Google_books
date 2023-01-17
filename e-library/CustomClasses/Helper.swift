//
//  Helper.swift
//  Google Books
//
//  Created by Iskandar Fazliddinov on 17/01/23.
//

import Foundation

class Helper {
    
    public static var waitController : WaitWindowDialogController?
    
    public static func getWaitController() -> WaitWindowDialogController {
        if waitController == nil {
            waitController = WaitWindowDialogController()
        }
        return waitController!
    }
    
}
