//
//  LoadingIndicator.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/22/19.
//  Copyright © 2019 clueapps. All rights reserved.
//
import UIKit

class LoadingIndicator {
    static let shared = LoadingIndicator()
    private var loadingCount = 0 // Number of loading indicators shown, hides loading indicator when reaches 0
    private let window = UIApplication.shared.keyWindow
    private var loadingView: LoadingIndicatorView!
    
    private init() {}
    
    func showLoadingIndicator() {
        DispatchQueue.main.async {
            self.loadingCount += 1
            if self.loadingCount == 1 {
                self.loadingView = LoadingIndicatorView(frame: self.window?.bounds ?? CGRect.zero)
                self.loadingView.startAnimation()
                self.window?.addSubview(self.loadingView)
            }
        }
    }
    
    func hideLoadingIndicator() {
        DispatchQueue.main.async {
            guard self.loadingCount != 0 else {
                return
            }
            self.loadingCount -= 1
            if self.loadingCount == 0 {
                self.loadingView.stopAnimation()
                self.loadingView.removeFromSuperview()
            }
        }
    }
    
    func hideNoInternetConnection() {
        loadingCount = 0
        DispatchQueue.main.async {
            self.loadingView.stopAnimation()
            self.loadingView.removeFromSuperview()
        }
    }
}
