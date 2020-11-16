//
//  LogoutViewModel.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/23/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation

class LogoutViewModel: NBParentViewModel {
    
    private var moreUseCases: MoreUseCases?
    private weak var logoutViewController: LogoutViewController?
    
    override init(viewController: NBParentViewController) {
        super.init(viewController: viewController)
        moreUseCases = MoreUseCases()
        logoutViewController = viewController as? LogoutViewController
    }
    
    func logout(){
        self.logoutViewController?.showLoadingView()
        moreUseCases?.logout(success: { [weak self] data in
            self?.logoutViewController?.hideLoadingView()
            if let _ = data as? LogoutModel{
                self?.logoutViewController?.loggedOutSuccessfully()
            }
            }, failure: { [weak self] (error) in
                self?.logoutViewController?.hideLoadingView()
                if let error = error as? NBErrorCase{
                    self?.handleGenericErrors(error: error)
                }
        })
    }
}
