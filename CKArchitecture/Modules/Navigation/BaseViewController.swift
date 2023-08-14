//
//  BaseViewController.swift
//  CKArchitecture
//
//  Created by Krzysztof Banaczyk on 14/08/2023.
//

import UIKit

class BaseViewController: UIViewController {

    private var spinnerView: UIView!
    private var activityIndicator: UIActivityIndicatorView!
    
    func setup() {
        
        spinnerView = UIView(frame: view.bounds)
        spinnerView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        spinnerView.isHidden = true
        view.addSubview(spinnerView)
        
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = spinnerView.center
        activityIndicator.hidesWhenStopped = true
        spinnerView.addSubview(activityIndicator)
    }
    
    func showSpinner(_ isPresented: Bool) {
       
        spinnerView.isHidden = !isPresented
        if isPresented {
            activityIndicator.startAnimating()
        }
        else {
            activityIndicator.stopAnimating()
        }
    }
    
    func showAlert(error: ServiceError) {
        let alert = UIAlertController(title: "Error",
                                      message: error.message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
