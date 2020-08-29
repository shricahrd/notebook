//
//  HomeViewModel.swift
//  notebook
//
//  Created by Abdorahman Youssef on 2/14/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation

class HomeViewModel: NBParentViewModel {
    
    private var homeUseCases: HomeUseCases?
    private weak var homeViewController: HomeViewController?
    
    override init(viewController: NBParentViewController) {
        super.init(viewController: viewController)
        homeUseCases = HomeUseCases()
        homeViewController = viewController as? HomeViewController
    }
    
    func fetchHomeData(withLoader: Bool = false){
        if withLoader{
            self.homeViewController?.showLoadingView()
        }
        homeUseCases?.fetchHomeData(success: { [weak self] data in
            print("success")
            self?.homeViewController?.refreshControl.endRefreshing()
            if let data = data as? HomeModel{
                self?.homeViewController?.featuredBooksDataSourceVariable.value = data.data?.featured ?? []
                let defaultItem = Genre(JSON: ["id" : "", "name": "الكل"])
                self?.homeViewController?.genresDataSourceVariable.value =  data.data?.genres?.reversed() ?? []
                if let defaultItem = defaultItem{
                    self?.homeViewController?.genresDataSourceVariable.value.append(defaultItem)
                }
                
                self?.homeViewController?.mostReadBooksDataSourceVariable.value = self?.filterMostReadWithListenPrice(mostReadArray: data.data?.mostRead) ?? []
                
                self?.homeViewController?.userGenresDataSourceVariable.value = data.data?.userGenres ?? []
                if let imageObject = data.data?.adImage{
                    self?.homeViewController?.adImageDataSourceVariable.value = imageObject
                }
                self?.homeViewController?.link = data.data?.adImage?.link
                
                self?.homeViewController?.noInternetView.isHidden = true
            }
            if withLoader{
                self?.homeViewController?.hideLoadingView()
            }
        }, failure: { [weak self] (error) in
            self?.homeViewController?.refreshControl.endRefreshing()
            print(error.debugDescription)
            self?.homeViewController?.hideLoadingView()
            if withLoader{
                self?.homeViewController?.hideLoadingView()
            }
            
            if let error = error as? NBErrorCase{
                switch error{
                case .noInternetConnection:
                    self?.homeViewController?.noInternetView.isHidden = false
                default: break
                }
            }
        })
    }
    
    func fetchAdVideoURL(){
        self.homeViewController?.showLoadingView()
        homeUseCases?.fetchAdVideoURL(success: { [weak self] data in
            print("success")
            if let data = data as? AdVideoResponse{
                NBParentNavigationControllerViewController.videoURLString = data.data?.image ?? ""
            }
            self?.homeViewController?.hideLoadingView()
            }, failure: { [weak self] (error) in
                print(error.debugDescription)
                self?.homeViewController?.hideLoadingView()
        })
    }
    
    func deviceInfo(withDeviceId: String, andDeviceModel: String){
        let firebaseToken = LocalStore.fcmToken()
        let request = DeviceInfoRequestPayload.init(deviceId: withDeviceId, deviceModel: andDeviceModel, firebaseToken: firebaseToken)
        homeUseCases?.requestBody = request
        homeUseCases?.deviceInfo(success: { [weak self] data in
            print("success")
            if let _ = data as? RootMeta{
                
            }
            }, failure: { [weak self] (error) in
                print(error.debugDescription)
                self?.homeViewController?.hideLoadingView()
        })
    }
}

extension HomeViewModel{
    func filterMostReadWithListenPrice(mostReadArray: [AdBook]?) -> [AdBook] {
        var filterMostRead: [AdBook] = []
        if let mostReadArray = mostReadArray {
            filterMostRead = mostReadArray.filter( { (book: AdBook) -> Bool in
                if let listenPrice = book.listenPrice{
                    return Float(listenPrice) > 0
                }
                return false
            })
        }
        return filterMostRead
    }
}
