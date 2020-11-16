//
//  LauncherViewController.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/8/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import UIKit
import Gifu

class LauncherViewController: NBParentViewController {

    @IBOutlet weak var logoGifImageView: GIFImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadGif()
    }
    
    private func loadGif(){
        logoGifImageView.animate(withGIFNamed: "LogoSplash.gif", loopCount: 1) { [weak self] in
            let timeTakenToComplete = (self?.logoGifImageView.gifLoopDuration ?? 1) * Double(1)
            DispatchQueue.main.asyncAfter(deadline: .now() + timeTakenToComplete) {
                self?.checkWhereToGo()
            }
        }
    }
    
    private func checkWhereToGo(){
        NBParentViewController.window = UIApplication.shared.windows.first
        if let token = LocalStore.token(), !token.isEmpty{
            self.goToHome()
        }else{
            self.goToLogin()
        }
    }
    
    

}
