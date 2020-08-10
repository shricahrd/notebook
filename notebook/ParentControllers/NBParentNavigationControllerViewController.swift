//
//  NBParentNavigationControllerViewController.swift
//  notebook
//
//  Created by Abdorahman Youssef on 2/9/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
//import RealmSwift

class NBParentNavigationControllerViewController: UINavigationController {
    
    static var videoURLString = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        addPlayButton()
        addSearchButton()
    }
    
    func setupView(){
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = UIColor.NBNavBarBGColor()
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.GulfBold(withSize: FontSize.small)]
        navigationBar.barStyle = .black
    }
    
    func setupScreenTitle(withTitle title: String){
        navigationBar.topItem?.title = title
    }
    
    func addPlayButton(){
        navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "playButton"), style: .plain, target: self, action: #selector(self.playButtonTapped))
    }
    
    @objc func playButtonTapped(){
        print("play button tapped")
        if let videoURL = URL(string: NBParentNavigationControllerViewController.videoURLString){
            let player = AVPlayer(url: videoURL)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        }
    }
    
    func addSearchButton(){
        navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "icSearchWhite"), style: .plain, target: self, action: #selector(self.searchButtonTapped))
    }
    
    @objc func searchButtonTapped(){
        print("search button tapped")
        let searchStoryboard = UIStoryboard.init(name: "Search", bundle: nil)
        if let searchVC = searchStoryboard.instantiateInitialViewController(){
            self.pushViewController(searchVC, animated: true)
        }
    }
    
    func removeSearchButton(){
        navigationBar.topItem?.rightBarButtonItem = nil
    }
    
    func removePlayButton(){
        navigationBar.topItem?.leftBarButtonItem = nil
    }
    
    func addBackButton(){
        navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "left"), style: .plain, target: self, action: #selector(self.backButtonTapped))
    }
    
    @objc func backButtonTapped(){
        popViewController(animated: true)
    }
    
    var cartButton: UIBarButtonItem?
    
    func addCartButton(){
        
        if cartButton == nil{
            cartButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "cartNavbar"), style: .plain, target: self, action: #selector(self.goToCart))
            navigationBar.topItem?.rightBarButtonItems?.append(self.cartButton ?? UIBarButtonItem())
        }
        let booksCounter = getCartCount()
        if booksCounter > 0{
            self.cartButton?.image = #imageLiteral(resourceName: "basketFilled")
            self.cartButton?.tintColor = UIColor.white
        }else{
            self.cartButton?.image = #imageLiteral(resourceName: "cartNavbar")
            self.cartButton?.tintColor = UIColor.white
        }
    }

    @objc func goToCart(){
        let storyBoard = UIStoryboard.init(name: "Home", bundle: nil)
        if let cartVC = storyBoard.instantiateViewController(withIdentifier: "CartViewController") as? NBParentViewController{
            self.pushViewController(cartVC, animated: true)
        }
    }
    
    func getCartCount() -> Int {
        var count = 0
        do {
//            let realm = try Realm()
//            if let cart = realm.objects(Cart.self).first{
//                for book in cart.books{
//                    count += book.counter
//                }
//            }
            return count
            
        }catch let err {
            print(err.localizedDescription)
        }
        return count
    }
}
