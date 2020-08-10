//
//  UserInterestsViewModel.swift
//  notebook
//
//  Created by Abdorahman Youssef on 3/26/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation

class UserInterestsViewModel: NBParentViewModel {
    
    private var loginUseCases: LoginUseCases?
    private var searchUseCases: SearchUseCases?
    private weak var userInterestsViewController: UserInterestsViewController?
    var isEditingUserGenres = false
    
    override init(viewController: NBParentViewController) {
        super.init(viewController: viewController)
        loginUseCases = LoginUseCases()
        searchUseCases = SearchUseCases()
        userInterestsViewController = viewController as? UserInterestsViewController

    }
    
    func fetchGenres(){
        self.userInterestsViewController?.showLoadingView()
        searchUseCases?.fetchGenres(success: { [weak self] data in
            if let data = data as? GenresResponseModel{
                self?.userInterestsViewController?.genresDataSourceVariable.value = data.data ?? []
                if self?.isEditingUserGenres ?? false{
                    self?.fetchUserGenres()
                }
            }
            self?.userInterestsViewController?.hideLoadingView()
            }, failure: { [weak self] (error) in
                self?.userInterestsViewController?.hideLoadingView()
                if let error = error as? NBErrorCase{
                    self?.handleGenericErrors(error: error)
                }
        })
    }
    
    func updateUserGenres(withGenresIds genresIds: [Int]){
        self.userInterestsViewController?.showLoadingView()
        loginUseCases?.updateUserGenres(withGenresIds: genresIds, success: { [weak self] data in
            if let _ = data as? GenresResponseModel{
                if self?.isEditingUserGenres ?? false{
                    self?.userInterestsViewController?.navigationController?.popViewController(animated: true)
                    self?.userInterestsViewController?.tabBarController?.selectedIndex = 0
                }else{
                    self?.userInterestsViewController?.goToHome()
                }
            }
            self?.userInterestsViewController?.hideLoadingView()
            }, failure: { [weak self] (error) in
                self?.userInterestsViewController?.hideLoadingView()
                if let error = error as? NBErrorCase{
                    self?.handleGenericErrors(error: error)
                }
        })
    }
    
    func fetchUserGenres(){
        self.userInterestsViewController?.showLoadingView()
        loginUseCases?.fetchUserGenres(success: { [weak self] data in
            if let data = data as? GenresResponseModel{
                self?.userInterestsViewController?.setUserGenres(withGenres: data.data ?? [])
            }
            self?.userInterestsViewController?.hideLoadingView()
            }, failure: { [weak self] (error) in
                self?.userInterestsViewController?.hideLoadingView()
                if let error = error as? NBErrorCase{
                    self?.handleGenericErrors(error: error)
                }
        })
    }
    
}
