//
//  ViewController.swift
//  notebook
//
//  Created by Abdorahman Youssef on 1/25/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import UIKit
import RealmSwift

class NBParentViewController: UIViewController {
    
    static var window: UIWindow?
    static var realm: Realm?
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        do {
            let migrationBlock: MigrationBlock = { migration, oldSchemaVersion in
                //Leave the block empty
                if (oldSchemaVersion < 1) {}
            }
            Realm.Configuration.defaultConfiguration = Realm.Configuration(schemaVersion: 1, migrationBlock: migrationBlock)
            NBParentViewController.realm = try Realm()
        }catch let err {
            showAlert(withTitle: "", andMessage: "\(err.localizedDescription)")
        }
    }
    
    func showAlert(withTitle title: String, andMessage message: String, completion: ((UIAlertAction) -> Void)? = nil){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "موافق", style: .cancel, handler: completion)
        alert.addAction(okAction)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showLoadingView(){
        LoadingIndicator.shared.showLoadingIndicator()
    }
    
    func hideLoadingView(){
        LoadingIndicator.shared.hideLoadingIndicator()
    }
    
    func goToHome(){
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        if let tabBarViewController = storyboard.instantiateInitialViewController() as? NBParentTabBarViewController{
            if NBParentViewController.window == nil{
                NBParentViewController.window = UIWindow.init(frame: UIScreen.main.bounds)
            }
            NBParentViewController.window?.rootViewController = tabBarViewController
            NBParentViewController.window?.makeKeyAndVisible()
        }
    }
    
    func goToLogin(){
        let storyboard = UIStoryboard.init(name: "Login", bundle: nil)
        if let loginNavigationController = storyboard.instantiateInitialViewController() as? NBParentNavigationControllerViewController {
            if NBParentViewController.window == nil{
                NBParentViewController.window = UIWindow.init(frame: UIScreen.main.bounds)
            }
            NBParentViewController.window?.rootViewController = loginNavigationController
            NBParentViewController.window?.makeKeyAndVisible()
        }
    }
    
    func goToTremsAndConditions(){
        let storyboard = UIStoryboard.init(name: "More", bundle: nil)
        if let termsAndConditionsVC = storyboard.instantiateViewController(withIdentifier: "TermsAndConditionsViewController") as? TermsAndConditionsViewController {
            navigationController?.pushViewController(termsAndConditionsVC, animated: true)
        }
    }
    
    func handleUnauthorizedError(){
        showAlert(withTitle: "عفوا", andMessage: "قم بتسجيل الدخول أولا", completion: { action in
            self.goToLogin()
        })
    }
    
    func removeUserData(){
        LocalStore.removeEmail()
        LocalStore.removeToken()
        LocalStore.removeUsername()
        LocalStore.removePhoneNumber()
        LocalStore.removeFCMToken()
        LocalStore.removeGender()
        LocalStore.removeBirthdate()
    }
    
    func loginAlert(){
        let alert = UIAlertController(title: "", message: "قم بتسجيل الدخول للمتابعة", preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "حسنا", style: .cancel) { (action) in
            self.goToLogin()
        }
        alert.addAction(okAction)
        let cancelAction = UIAlertAction(title: "لاحقا", style: .default, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func continuePayment(withUrl url: String, andInvoice invoice: Int){
        let storyBoard = UIStoryboard.init(name: "More", bundle: nil)
        if let paymentVC = storyBoard.instantiateViewController(withIdentifier: "PaymentWebViewController") as? PaymentWebViewViewController{
            paymentVC.paymentUrl = url
            self.navigationController?.pushViewController(paymentVC, animated: true)
        }
    }
    
    func checkBookFileExists(withLink link: String, completion: @escaping ((_ filePath: URL)->Void)){
        let urlString = link.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        if let url  = URL.init(string: urlString ?? ""){
            let fileManager = FileManager.default
            if let documentDirectory = try? fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create: false){
                
                let filePath = documentDirectory.appendingPathComponent(url.lastPathComponent, isDirectory: false)
                
                do {
                    if try filePath.checkResourceIsReachable() {
                        print("file exist")
                        completion(filePath)
                        
                    } else {
                        print("file doesnt exist")
                        downloadFile(withUrl: url, andFilePath: filePath, completion: completion)
                    }
                } catch {
                    print("file doesnt exist")
                    downloadFile(withUrl: url, andFilePath: filePath, completion: completion)
                }
            }else{
                showAlert(withTitle: "عفوا", andMessage: "حدث خطأ غير متوقع")
            }
        }else{
            showAlert(withTitle: "عفوا", andMessage: "رابط الكتاب غير صحيح")
        }
    }
    
    
    func downloadFile(withUrl url: URL, andFilePath filePath: URL, completion: @escaping ((_ filePath: URL)->Void)){
        guard Connectivity.isConnectedToInternet else{
            let message = "يجب فتح الكتاب مرة واحدة على الأقل مع انترنت"
            showAlert(withTitle: "عفوا", andMessage: message, completion: { action in
                self.navigationController?.popViewController(animated: true)
            })
            return
        }
        
        showLoadingView()
        DispatchQueue.global(qos: .background).async {
            do {
                let bookData = try Data.init(contentsOf: url)
                try bookData.write(to: filePath, options: .atomic)
                print("saved at \(filePath.absoluteString)")
                DispatchQueue.main.async {
                    self.hideLoadingView()
                    completion(filePath)
                }
            } catch let error {
                print(error)
                print("an error happened while downloading or saving the file")
                DispatchQueue.main.async {
                    self.hideLoadingView()
                    self.showAlert(withTitle: "عفوا", andMessage: "حدث خطأ أثناء تنزيل الملف")
                }
                
            }
        }
    }
}

