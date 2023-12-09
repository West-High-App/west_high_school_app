//
//  Utilities.swift
//  Login auth app
//
//  Created by August Andersen on 7/14/23.
//

import Foundation
import UIKit

final class Utilities {
    
    static let shared = Utilities()
    private init() {}
    
    @MainActor
    func topViewController(controller: UIViewController? = nil) -> UIViewController? {
        
        let controller = controller ?? UIApplication.shared.keyWindow?.rootViewController
        
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)

        }
        return controller
    }
}
