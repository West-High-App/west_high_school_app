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
        if let controller = controller {
            return controller
        }

        if let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive }),
            let rootViewController = windowScene.windows.first?.rootViewController {
            return topViewController(controller: rootViewController)
        }

        return nil
    }


    
}
