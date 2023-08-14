//
//  Navigation.swift
//  CKArchitecture
//
//  Created by Krzysztof Banaczyk on 14/08/2023.
//

import UIKit

extension UIViewController {
    
    func push(_ module: Module) {
        guard let navigator = self.navigationController else {
            // handle navigation error
            return
        }
        
        navigator.pushViewController(module.view, animated: true)
    }
    
    func show(_ module: Module) {
        guard let navigator = self.navigationController else {
            // handle navigation error
            return
        }
        
        navigator.present(module.view, animated: true)
    }
    
    func pop() {
        guard let navigator = self.navigationController else {
            // handle navigation error
            return
        }
        
        navigator.pop()
    }
    
    func popToRoot() {
        guard let navigator = self.navigationController else {
            // handle navigation error
            return
        }
        
        navigator.popToRoot()
    }
    
    func popTo(_ module: Module) {
        guard let navigator = self.navigationController else {
            // handle navigation error
            return
        }
        
        navigator.popToViewController(module.view, animated: true)
    }
}
