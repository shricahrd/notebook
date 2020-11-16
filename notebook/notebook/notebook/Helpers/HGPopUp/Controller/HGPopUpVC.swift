//
//  HGPopUpVC.swift
//  HGPopUp
//
//  Created by hesham ghalaab on 5/25/19.
//  Copyright © 2019 hesham ghalaab. All rights reserved.
//

import UIKit

class HGPopUpVC: UIViewController {

    // MARK: Outlets
    @IBOutlet weak private var tableView: HGTableView!
    @IBOutlet weak private var titleLabel: UILabel!
    
    // MARK: Properties
    /// an array of strings that will hold all the data that is needed to be shown in the pop up to select from it.
    var popUpValues = [String]()
    
    /// a string value to setup the pop up title it can be empty.
    var popUpTitle = String()
    
    /// HGPopUpProtocol is the thing that will communicate between HGPopUpVC and the view controller which make the call of the pop up.
    var delegate: HGPopUpProtocol?
    
    // MARK: Override Functions
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configuration()
        setupData()
        setupUI()
    }
    
    var barStyle = UIStatusBarStyle.lightContent
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return barStyle
    }
    
    // MARK: Methods
    /**
     This function is to configure any protocols.
     */
    private func configuration(){
        let nib = UINib(nibName: HGPopUpCell.identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: HGPopUpCell.identifier)
        tableView.rowHeight = 44
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    /**
     This function is to make a custom design.
     */
    private func setupUI(){
        tableView.layer.cornerRadius = 10
    }
    
    /**
     This function is to setup Some Data.
     */
    private func setupData(){
        titleLabel.text = popUpTitle
    }
    
    /// this function will dismiss the the pop up with the changing of the status bar style.
    private func dismissPopUp(){
        barStyle = .default
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Actions
    /**
     dismiss the view controller when close button was tapped.
     */
    @IBAction private func onTapCloseButton(_ sender: UIButton) {
        dismissPopUp()
    }
    
}


// MARK: UITableViewDelegate, UITableViewDataSource
extension HGPopUpVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return popUpValues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HGPopUpCell.identifier, for: indexPath) as!  HGPopUpCell
        cell.valueLabel.text = popUpValues[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.dismissPopUp()
            self.delegate?.didSelectRowFromPopUp(withRow: indexPath.row)
        }
    }
}

extension HGPopUpVC{
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        
        /* just to make the tableview make its calculation again to resize it self when the view willTransition to a new Collection even landscape or portrait, and you can get ot from UIApplication.shared.statusBarOrientation.isLandscape */
        
        coordinator.animate(alongsideTransition: { [unowned self] _ in
            self.tableView.invalidateIntrinsicContentSize()
        })
    }
}
