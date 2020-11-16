//
//  NBParentViewModel.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/21/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation

class NBParentViewModel {
    
    weak var viewController: NBParentViewController?
    
    init(){
    }
    
    init(viewController: NBParentViewController) {
        self.viewController = viewController
    }
    
    func handleGenericErrors(error: NBErrorCase){
        switch error {
        case .unauthorized:
            self.viewController?.handleUnauthorizedError()
        case let .unprocessableEntity(_, code, model):
            self.viewController?.showAlert(withTitle: "\(code ?? 0)", andMessage: "\((model as? NBError)?.errorMessage ?? "")")
        case let .gone(message: _, code: _, errorModel: model):
            self.viewController?.showAlert(withTitle: "", andMessage: "\((model as? NBError)?.meta?.message ?? "")")
        case .noInternetConnection:
            self.viewController?.showAlert(withTitle: "لا يوجد اتصال في الإنترنت", andMessage: "خطأ غير متوقع\nحاول مرة أخرى")
        default:
            self.viewController?.showAlert(withTitle: "\(error)", andMessage: "خطأ غير متوقع\nحاول مرة أخرى")
        }
    }
}
