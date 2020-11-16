//
//  HGPopUpPresenter.swift
//  HGPopUp
//
//  Created by hesham ghalaab on 5/25/19.
//  Copyright © 2019 hesham ghalaab. All rights reserved.
//

import UIKit

class HGPopUpPresenter{
    
    // Here we define a set of supported destinations using an
    // enum, and we can also use associated values to add support
    // for passing arguments from one screen to another.
    enum Destination {
        case HGPopUp(withValues: [String], AndTitle: String)
    }
    
    // In most cases it's totally safe to make this a strong
    // reference, but in some situations it could end up
    // causing a retain cycle, so better be safe than sorry :)
    private weak var viewController: UIViewController?
    
    // MARK: - Initializer
    init(vc: UIViewController?) {
        guard let vc = vc else { return }
        self.viewController = vc
    }
    
    // MARK: - Navigator
    func present(_ destination: Destination) {
        presentViewController(for: destination)
    }
    
    // MARK: - Private
    private func presentViewController(for destination: Destination) {
        switch destination {
        case .HGPopUp(let values, let title):
            presentDefaultPopUpVC(values: values, title: title)
        }
    }
    
    private func presentDefaultPopUpVC(values: [String], title: String){
        let nextVC = HGPopUpVC(nibName: "HGPopUpVC", bundle: nil)
        nextVC.delegate = viewController as? HGPopUpProtocol
        nextVC.popUpValues = values
        nextVC.popUpTitle = title
        nextVC.modalPresentationStyle = .overFullScreen
        nextVC.modalTransitionStyle = .crossDissolve
        DispatchQueue.main.async {
            self.viewController?.present(nextVC, animated: true, completion: nil)
        }
    }
}

