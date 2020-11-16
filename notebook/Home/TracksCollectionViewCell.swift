//
//  MostReadCollectionViewCell.swift
//  notebook
//
//  Created by Abdorahman Youssef on 2/23/19.
//  Copyright © 2019 clueapps. All rights reserved.
//

import UIKit

class TracksCollectionViewCell: UICollectionViewCell {
    
    static let reusableIdentifier = "TracksCollectionViewCell"
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var trackBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView(){
        self.trackBtn.setTitleColor(UIColor.NBGoldColor(), for: .normal)
        self.trackBtn.layer.borderColor = UIColor.NBGoldColor().cgColor
        self.trackBtn.layer.borderWidth = 1.0
        setClearBackground()
    }
    
    func configureCell(withTrack trackName: String){
        self.trackBtn.setTitle(trackName, for: .normal)
        setupTrackBtnAttributes(withTrack: trackName)
    }
    
    func setClearBackground(){
        containerView.backgroundColor = UIColor.clear
        self.backgroundColor = .clear
    }
    
    func setupTrackBtnAttributes(withTrack trackName: String) {
        
        let yourAttributes : [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor : UIColor.NBGoldColor(),
            NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]
        
            let attributeString = NSMutableAttributedString(string: trackName,
                                                            attributes: yourAttributes)
        //self.trackBtn.setAttributedTitle(attributeString, for: .normal)
    }
}
