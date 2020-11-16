//
//  CartViewModel.swift
//  notebook
//
//  Created by Abdorahman Youssef on 4/3/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation
import RxSwift

class CartViewModel: NBParentViewModel {
    
    private weak var cartViewController: CartViewController?
    
    override init(viewController: NBParentViewController) {
        super.init(viewController: viewController)

        cartViewController = viewController as? CartViewController
    }
    
    func fetchCartBooks(){
        if let cart = NBParentViewController.realm?.objects(Cart.self).first{
            cartViewController?.cartBooksDataSourceVariable.value.removeAll()
            cartViewController?.cartBooksDataSourceVariable.value.append(contentsOf: cart.books)
        }
    }
}
