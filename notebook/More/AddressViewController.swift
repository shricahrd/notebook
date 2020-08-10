//
//  AddressViewController.swift
//  notebook
//
//  Created by Abdorahman Youssef on 4/5/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AddressViewController: NBParentViewController, UIGestureRecognizerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var areaPickerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var areaPickerView: UIPickerView!
    @IBOutlet weak var countryPickerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var countryPickerView: UIPickerView!
    @IBOutlet weak var addMyAddressButton: UIButton!
    @IBOutlet weak var floorTextField: UITextField!
    @IBOutlet weak var buildingNoTextField: UITextField!
    @IBOutlet weak var blockTextField: UITextField!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var myAddressTextField: UITextField!
    @IBOutlet weak var areaTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    
    @IBOutlet weak var countryCodeForMobileLabel: UILabel!
    
    let disposeBag = DisposeBag()
    var addressVM: AddressViewModel!
    var countryCodes = [CountryData](){
        didSet{
            countryPickerView.reloadAllComponents()
        }
    }
    
    var areas = [AreaData](){
        didSet{
            areaPickerView.reloadAllComponents()
        }
    }
    
    var firstTimeToLoadAreas = true
    var isComingFromCart = false
    var booksToPurchase: [PurchaseBook]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addressVM = AddressViewModel.init(viewController: self)
        addressVM.isComingFromCart = isComingFromCart
        setupView()
        addressVM.start()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
        title = "عنواني"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        (navigationController as? NBParentNavigationControllerViewController)?.addBackButton()
    }
    
    func setupView(){
        addMyAddressButton.titleLabel?.font = UIFont.GulfRegular(withSize: FontSize.vTiny)
        floorTextField.font = UIFont.GulfBold(withSize: FontSize.vTiny)
        buildingNoTextField.font = UIFont.GulfBold(withSize: FontSize.vTiny)
        blockTextField.font = UIFont.GulfBold(withSize: FontSize.vTiny)
        streetTextField.font = UIFont.GulfBold(withSize: FontSize.vTiny)
        myAddressTextField.font = UIFont.GulfBold(withSize: FontSize.vTiny)
        areaTextField.font = UIFont.GulfBold(withSize: FontSize.vTiny)
        countryTextField.font = UIFont.GulfBold(withSize: FontSize.vTiny)
        addMyAddressButton.roundCorners(withRadius: 6)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        _ = countryTextField.rx.observe(String.self, "text").subscribe(onNext: { [weak self] text in
            self?.addressVM.country.value = text ?? ""
        }).disposed(by: disposeBag)
        
        _ = areaTextField.rx.observe(String.self, "text").subscribe(onNext: { [weak self] text in
            self?.addressVM.area.value = text ?? ""
        }).disposed(by: disposeBag)
        
        _ = myAddressTextField.rx.observe(String.self, "text").subscribe(onNext: { [weak self] text in
            self?.addressVM.myAddress.value = text ?? ""
        }).disposed(by: disposeBag)
        
        _ = streetTextField.rx.observe(String.self, "text").subscribe(onNext: { [weak self] text in
            self?.addressVM.street.value = text ?? ""
        }).disposed(by: disposeBag)
        
        _ = blockTextField.rx.observe(String.self, "text").subscribe(onNext: { [weak self] text in
            self?.addressVM.block.value = text ?? ""
        }).disposed(by: disposeBag)
        
        _ = buildingNoTextField.rx.observe(String.self, "text").subscribe(onNext: { [weak self] text in
            self?.addressVM.buildingNo.value = text ?? ""
        }).disposed(by: disposeBag)
        
        _ = floorTextField.rx.observe(String.self, "text").subscribe(onNext: { [weak self] text in
            self?.addressVM.floor.value = text ?? ""
        }).disposed(by: disposeBag)
        
        _ = myAddressTextField.rx.text.map{ $0 ?? "" }.bind(to: addressVM.myAddress ).disposed(by: disposeBag)
        _ = streetTextField.rx.text.map{ $0 ?? "" }.bind(to: addressVM.street ).disposed(by: disposeBag)
        _ = blockTextField.rx.text.map{ $0 ?? "" }.bind(to: addressVM.block ).disposed(by: disposeBag)
        _ = buildingNoTextField.rx.text.map{ $0 ?? "" }.bind(to: addressVM.buildingNo ).disposed(by: disposeBag)
        _ = floorTextField.rx.text.map{ $0 ?? "" }.bind(to: addressVM.floor ).disposed(by: disposeBag)

        
        countryPickerView.delegate = self
        countryPickerView.dataSource = self
        
        areaPickerView.delegate = self
        areaPickerView.dataSource = self
        
        
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.NBGoldColor()]
        
        let countryHolder = NSAttributedString(string: "الدولة", attributes: attributes)
        let areaHolder = NSAttributedString(string: "المنطقة", attributes: attributes)
        let myAddressHolder = NSAttributedString(string: "العنوان", attributes: attributes)
        let streetHolder = NSAttributedString(string: "الشارع (اختياري)", attributes: attributes)
        let blockHolder = NSAttributedString(string: "القطعة (اختياري)", attributes: attributes)
        let buildingNoHolder = NSAttributedString(string: "رقم المنزل", attributes: attributes)
        let floorHolder = NSAttributedString(string: "رقم التواصل", attributes: attributes)
        
        countryTextField.attributedPlaceholder = countryHolder
        areaTextField.attributedPlaceholder = areaHolder
        myAddressTextField.attributedPlaceholder = myAddressHolder
        streetTextField.attributedPlaceholder = streetHolder
        blockTextField.attributedPlaceholder = blockHolder
        buildingNoTextField.attributedPlaceholder = buildingNoHolder
        floorTextField.attributedPlaceholder = floorHolder
        
        //areaPickerView.setValue(UIColor.white, forKeyPath: "textColor")
        //countryPickerView.setValue(UIColor.white, forKeyPath: "textColor")
    }
    
    func setUserAddress(withAddressData address: AddressData){
        myAddressTextField.text = address.address
        streetTextField.text = address.street
        blockTextField.text = address.block
        buildingNoTextField.text = address.building_no
        
        let phoneNumberAndCountryCode = LocalStore.phoneNumberAndCountryCode(from: address.floor ?? "")
        countryCodeForMobileLabel.text = phoneNumberAndCountryCode.0
        floorTextField.text = phoneNumberAndCountryCode.1
        
        areaTextField.text = address.area_name?.area_name
        countryTextField.text = address.country_code
        addressVM.selectedAreaId = Int(address.area_id ?? "-1")
        if let code = address.country_code{
            addressVM.fetchAreas(withCountryCode: code)
        }
    }
    
    @IBAction func countryButtonClicked(_ sender: UIButton) {
       showCountryPicker()
    }
    
    @IBAction func areaButtonClicked(_ sender: UIButton) {
        showAreaPicker()
    }
    
    func showCountryPicker(){
        UIView.transition(with: countryPickerView, duration: 0.2, options: .transitionCrossDissolve, animations: {
            if self.countryPickerView.isHidden {
                self.countryPickerView.isHidden = false
                self.countryPickerViewHeightConstraint.constant = 216
            }else{
                self.countryPickerView.isHidden = true
                self.countryPickerViewHeightConstraint.constant = 0
            }
        })
    }
    
    func showAreaPicker(){
        UIView.transition(with: areaPickerView, duration: 0.2, options: .transitionCrossDissolve, animations: {
            if self.areaPickerView.isHidden {
                self.areaPickerView.isHidden = false
                self.areaPickerViewHeightConstraint.constant = 216
            }else{
                self.areaPickerView.isHidden = true
                self.areaPickerViewHeightConstraint.constant = 0
            }
        })
    }
    
    @IBAction func addMyAddressButtonClicked(_ sender: UIButton) {
        
        if !addressVM.isValidCountry {
            showAlert(withTitle: "", andMessage: "من فضلك اختر البلد")
        }else if !addressVM.isValidArea {
            showAlert(withTitle: "", andMessage: "من فضلك اختر المنطقة")
        }else if !addressVM.isValidAddress {
            showAlert(withTitle: "", andMessage: "من فضلك قم بكتابة العنوان")
        }else if !addressVM.isValidFloor {
            showAlert(withTitle: "", andMessage: "برجاء إدخال رقم التواصل بشكل صحيح")
        }else if !addressVM.isFloorInRange{
            showAlert(withTitle: "", andMessage: "رقم التواصل يتكون من أرقام فقط ما بين ٦ إلى ٢٠ رقم")
        }else {
            guard let areaId = addressVM.selectedAreaId else {
                showAlert(withTitle: "", andMessage: "Invalid area id!")
                return
            }
            
            if isComingFromCart{
                
                var areaData: AreaData?
                var userId: Int?
                if let tempUserIdString = LocalStore.userId(), let tempUserId = Int.init(tempUserIdString){
                    userId = tempUserId
                    areaData = AreaData.init(area_name: addressVM.area.value, id: tempUserId)
                }
                
                let mobile = "\(countryCodeForMobileLabel.text ?? "")\(addressVM.floor.value)"
                let countryCode = getCountryCode(fromName: addressVM.country.value)
                let addressDetails = AddressData.init(address: addressVM.myAddress.value, area_id: String(areaId), area_name: areaData, block: addressVM.block.value, building_no: addressVM.buildingNo.value, country_code: countryCode, floor: mobile, id: userId, street: addressVM.street.value, user_id: nil)
                
                if let books = booksToPurchase{
                    let orderType = OrderType.printed.rawValue
                    let coupon = ""
                    addressVM.purchaseBook(withAddress: addressDetails, andOrderType: orderType, andCoupon: coupon, andBooks: books)
                }
                
            }else{
                if addressVM.userHasAddress{
                    let mobile = "\(countryCodeForMobileLabel.text ?? "")\(addressVM.floor.value)"
                    let countryCode = getCountryCode(fromName: addressVM.country.value)
                    addressVM.updateUserAddress(withAddress: addressVM.myAddress.value, andStreet: addressVM.street.value, andBlock: addressVM.block.value, andFloor: mobile, andBuildingNo: addressVM.buildingNo.value, andCountryCode: countryCode, andAreaId: "\(areaId)")
                }else{
                    let mobile = "\(countryCodeForMobileLabel.text ?? "")\(addressVM.floor.value)"
                    let countryCode = getCountryCode(fromName: addressVM.country.value)
                    addressVM.createUserAddress(withAddress: addressVM.myAddress.value, andStreet: addressVM.street.value, andBlock: addressVM.block.value, andFloor: mobile, andBuildingNo: addressVM.buildingNo.value, andCountryCode: countryCode, andAreaId: "\(areaId)")
                }
            }
        }
    }
    
    private func getCountryCode(fromName countryName: String) -> String{
        for country in countryCodes{
            if countryName == country.countryName{
                return country.countryCode
            }
        }
        return ""
    }
    
    func updateTitle(asUserHasAddress hasAddress: Bool? = false){
        
        if isComingFromCart{
            title = "إتمام الدفع"
            addMyAddressButton.setTitle("إتمام الدفع", for: .normal)
            return
        }
        
        if hasAddress ?? false{
            title = "عدل عنوانك"
            addMyAddressButton.setTitle("عدل عنوانك", for: .normal)
        }else{
            title = "أضف عنوانك"
            addMyAddressButton.setTitle("أضف عنوانك", for: .normal)
        }
    }
    
    func setupCountriesView(withCountries countries: [CountryData]){
        countryCodes = countries
        countryPickerView.selectRow(0, inComponent: 0, animated: false)
    }
    
    func setupAreasView(withAreas areas: [AreaData]){
        self.areas = areas
        if !firstTimeToLoadAreas{
            areaPickerView.selectRow(0, inComponent: 0, animated: false)
            areaTextField.text = areas.first?.area_name
            addressVM.selectedAreaId = areas.first?.id
        }else{
            firstTimeToLoadAreas = false
            if let selectedArea = areas.first(where: { (area) -> Bool in
                area.id == addressVM.selectedAreaId
            }){
                areaTextField.text = selectedArea.area_name
            }
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == countryPickerView{
            return countryCodes.count
            
        }else if pickerView == areaPickerView{
            return areas.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let attributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        if pickerView == countryPickerView{
            let attributedString = NSAttributedString(string: countryCodes[row].countryName ?? "", attributes: attributes)
            
            return attributedString
            
        }else if pickerView == areaPickerView{
            let attributedString = NSAttributedString(string: areas[row].area_name ?? "", attributes: attributes)
            
            return attributedString
        }
        
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == countryPickerView{
            countryTextField.text = countryCodes[row].countryName
            showCountryPicker()
            let code = countryCodes[row].countryCode
            addressVM.fetchAreas(withCountryCode: code)
            
        }else if pickerView == areaPickerView{
            addressVM.selectedAreaId = areas[row].id
            areaTextField.text = areas[row].area_name
            showAreaPicker()
        }
    }
    
    @IBAction func onTapDropDownCountryCode(_ sender: UIButton) {
        let presenter = HGPopUpPresenter(vc: self)
        presenter.present(.HGPopUp(withValues: CountryCode.values, AndTitle: "اختر كود الدولة"))
    }
    
}

extension AddressViewController: HGPopUpProtocol{
    func didSelectRowFromPopUp(withRow row: Int) {
        let selectedCountryCode = CountryCode.init(row: row)
        self.countryCodeForMobileLabel.text = selectedCountryCode.rawValue
    }
}
