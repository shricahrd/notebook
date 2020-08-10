//
//  AddressViewModel.swift
//  notebook
//
//  Created by Abdorahman Youssef on 4/5/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import Foundation
import RxSwift

class AddressViewModel: NBParentViewModel {
    
    private var moreUseCases: MoreUseCases?
    private weak var addressViewController: AddressViewController?
    
    var country = Variable<String>("")
    var isValidCountry: Bool = false
    var area = Variable<String>("")
    var isValidArea: Bool = false
    var myAddress = Variable<String>("")
    var isValidAddress: Bool = false
    
    var block = Variable<String>("")
    var buildingNo = Variable<String>("")
    var floor = Variable<String>("")
    var isValidFloor: Bool = false
    var isFloorInRange: Bool = false
    var street = Variable<String>("")
    
    var userHasAddress = false
    let disposeBag = DisposeBag()
    var selectedAreaId: Int?
    
    var isComingFromCart = false
    
    override init(viewController: NBParentViewController) {
        super.init(viewController: viewController)
        moreUseCases = MoreUseCases()
        addressViewController = viewController as? AddressViewController
        
        country.asObservable().subscribe({ [weak self] (country) in
            self?.isValidCountry = !(country.element?.isEmpty ?? false)
        }).disposed(by: disposeBag)
        
        area.asObservable().subscribe({ [weak self] (area) in
            self?.isValidArea = !(area.element?.isEmpty ?? false) && (self?.selectedAreaId != nil)
        }).disposed(by: disposeBag)
        
        myAddress.asObservable().subscribe({ [weak self] (myAddress) in
            self?.isValidAddress = !(myAddress.element?.isEmpty ?? false)
        }).disposed(by: disposeBag)
        
        floor.asObservable().subscribe({ [weak self] (floor) in
            // check if the floor field is a number.
            self?.isValidFloor = (floor.element?.isNumber() ?? false)
            // check if the floor count is between 6 and 20
            if let floor = floor.element, floor.count >= 6 , floor.count <= 20{
                self?.isFloorInRange = true
            }else{
                self?.isFloorInRange = false
            }
            
        }).disposed(by: disposeBag)
        
    }
    
    func start() {
        fetchCountryCodes()
        fetchAddress()
    }
    
    func fetchAddress(){
        self.addressViewController?.showLoadingView()
        moreUseCases?.fetchAddress( success: { [weak self] data in
            self?.addressViewController?.hideLoadingView()
            if let response = data as? UserAddressResponse, let address = response.data?.first{
                self?.addressViewController?.setUserAddress(withAddressData: address)
                self?.userHasAddress = true
            }else{
                self?.userHasAddress = false
            }
            self?.addressViewController?.updateTitle(asUserHasAddress: self?.userHasAddress)
            }, failure: { [weak self] (error) in
                self?.addressViewController?.hideLoadingView()
                if let error = error as? NBErrorCase{
                    switch error{
                    default:
                        self?.handleGenericErrors(error: error)
                    }
                }
        })
    }
    
    func fetchCountryCodes(){
        let countries = CountryData.initSomeData()
        self.addressViewController?.setupCountriesView(withCountries: countries)
//        self.addressViewController?.showLoadingView()
//        moreUseCases?.fetchCountryCodes( success: { [weak self] data in
//            self?.addressViewController?.hideLoadingView()
//            if let response = data as? CountriesModel, let countries = response.data{
//                self?.addressViewController?.setupCountriesView(withCountries: countries)
//            }
//            }, failure: { [weak self] (error) in
//                self?.addressViewController?.hideLoadingView()
//                if let error = error as? NBErrorCase{
//                    switch error{
//                    default:
//                        self?.handleGenericErrors(error: error)
//                    }
//                }
//        })
    }
    
    func fetchAreas(withCountryCode code: String){
        self.addressViewController?.showLoadingView()
        moreUseCases?.fetchAreas(withCountryCode: code, success: { [weak self] data in
            self?.addressViewController?.hideLoadingView()
            if let response = data as? AreasModel, let areas = response.data{
                self?.addressViewController?.setupAreasView(withAreas: areas)
            }
            }, failure: { [weak self] (error) in
                self?.addressViewController?.hideLoadingView()
                if let error = error as? NBErrorCase{
                    switch error{
                    default:
                        self?.handleGenericErrors(error: error)
                    }
                }
        })
    }
    
    func createUserAddress(withAddress address: String, andStreet street: String?, andBlock block: String?, andFloor floor: String?, andBuildingNo buildingNo: String?, andCountryCode countryCode: String, andAreaId areaId: String){
        
        let requestBody = UpsertAddressRequestPayload.init(address: address, street: street, block: block, floor: floor, buildingNo: buildingNo, countryCode: countryCode, areaId: areaId)
        moreUseCases?.requestBody = requestBody
        self.addressViewController?.showLoadingView()
        moreUseCases?.createAdderss(success: { [weak self] data in
            self?.addressViewController?.hideLoadingView()
            if let _ = data as? UpsertUserAddressResponse{
                self?.addressViewController?.showAlert(withTitle: "", andMessage: "تم اضافة العنوان بنجاح", completion: { (action) in
                    self?.addressViewController?.navigationController?.popViewController(animated: true)
                })
            }
            }, failure: { [weak self] (error) in
                self?.addressViewController?.hideLoadingView()
                if let error = error as? NBErrorCase{
                    switch error{
                    default:
                        self?.handleGenericErrors(error: error)
                    }
                }
        })
    }
    
    func updateUserAddress(withAddress address: String, andStreet street: String?, andBlock block: String?, andFloor floor: String?, andBuildingNo buildingNo: String?, andCountryCode countryCode: String, andAreaId areaId: String){
        
        let requestBody = UpsertAddressRequestPayload.init(address: address, street: street, block: block, floor: floor, buildingNo: buildingNo, countryCode: countryCode, areaId: areaId)
        moreUseCases?.requestBody = requestBody
        self.addressViewController?.showLoadingView()
        moreUseCases?.updateAdderss(success: { [weak self] data in
            self?.addressViewController?.hideLoadingView()
            if let _ = data as? UpsertUserAddressResponse{
                self?.addressViewController?.showAlert(withTitle: "", andMessage: "تم تعديل العنوان بنجاح", completion: { (action) in
                    self?.addressViewController?.navigationController?.popViewController(animated: true)
                })
            }
            }, failure: { [weak self] (error) in
                self?.addressViewController?.hideLoadingView()
                if let error = error as? NBErrorCase{
                    switch error{
                    default:
                        self?.handleGenericErrors(error: error)
                    }
                }
        })
    }
    
    func purchaseBook(withAddress address: AddressData, andOrderType orderType: String?, andCoupon coupon: String?, andBooks books: [PurchaseBook]){
        
        let requestBody = PurchaseBookRequestPayload.init(address: address, coupon: coupon, orderType: orderType, books: books)
        moreUseCases?.requestBody = requestBody
        self.addressViewController?.showLoadingView()
        moreUseCases?.purchaseBook(success: { [weak self] data in
            self?.addressViewController?.hideLoadingView()
            if let response = data as? PurchaseBookResponse, let url = response.data?.paymentUrl, let invoice = response.data?.invoiceId{
                self?.addressViewController?.continuePayment(withUrl: url, andInvoice: invoice)
            }
            }, failure: { [weak self] (error) in
                self?.addressViewController?.hideLoadingView()
                if let error = error as? NBErrorCase{
                    switch error{
                    default:
                        self?.handleGenericErrors(error: error)
                    }
                }
        })
    }
}
