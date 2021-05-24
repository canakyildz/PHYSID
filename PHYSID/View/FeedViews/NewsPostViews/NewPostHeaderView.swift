//
//  NewPostHeaderView.swift
//  PHYSID
//
//  Created by Apple on 27.08.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import YoutubeDirectLinkExtractor


class NewPostHeaderView: UICollectionReusableView {
    
    // MARK: - Properties
    
    var playerViewController = AVPlayerViewController()
    
    
    lazy var postImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "123ABC"))
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    lazy var secondImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "Yoga Clothes _ Cut out the distractions just train_ | lululemon"))
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    lazy var playButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "icons8-play-50"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = #colorLiteral(red: 0.07358423223, green: 0.07358423223, blue: 0.07358423223, alpha: 1)
        button.layer.borderWidth = 0.1
        button.imageView?.setDimensions(height: 30, width: 30)
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.cornerRadius = 26
        button.addTarget(self, action: #selector(handlePlayVideo), for: .touchUpInside)
        return button
    }()
    
    lazy var thirdImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "veg"))
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    lazy var fourthImageAdderButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "post-something"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .black
        button.layer.borderWidth = 0.1
        button.imageView?.setDimensions(height: 33, width: 33)
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.cornerRadius = 26
        button.addTarget(self, action: #selector(handleAddFourthary), for: .touchUpInside)
        return button
    }()
    
    lazy var fifthImageAdderButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "post-something"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .black
        button.layer.borderWidth = 0.1
        button.imageView?.setDimensions(height: 33, width: 33)
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.cornerRadius = 26
        button.addTarget(self, action: #selector(handleAddFifthary), for: .touchUpInside)
        return button
    }()
    
    lazy var fourthImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "Ekran Resmi 2020-08-22 23.21.48"))
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    lazy var fifthImageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "adasds"))
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    let fourtharyCaptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 24
        let attributedText = NSMutableAttributedString(string: "", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 12)])
        attributedText.append(NSAttributedString(string: "Evil by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum comes from a line in section 1.10.32.. up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Revolution of PHYSID.Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source.", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)]))
        label.attributedText = attributedText
        return label
    }()
    
    let fiftharyCaptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 24
        let attributedText = NSMutableAttributedString(string: "", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 12)])
        attributedText.append(NSAttributedString(string: "Evil by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum comes from a line in section 1.10.32.. up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Revolution of PHYSID.", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)]))
        label.attributedText = attributedText
        return label
    }()
    
    let captionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 50
        let attributedText = NSMutableAttributedString(string: "", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 13)])
        attributedText.append(NSAttributedString(string: "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur,", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)]))
        label.attributedText = attributedText
        return label
    }()
    
    let oneCaptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 50
        let attributedText = NSMutableAttributedString(string: "", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 13)])
        attributedText.append(NSAttributedString(string: "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur,", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)]))
        label.attributedText = attributedText
        return label
    }()
    
    let secondaryCaptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 11
        let attributedText = NSMutableAttributedString(string: "", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 12)])
        attributedText.append(NSAttributedString(string: "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum comes from a line in section 1.10.32..", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)]))
        label.attributedText = attributedText
        return label
    }()
    
    let thirdaryCaptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 24
        let attributedText = NSMutableAttributedString(string: "", attributes: [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 12)])
        attributedText.append(NSAttributedString(string: "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum comes from a line in section 1.10.32.. up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Re", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)]))
        label.attributedText = attributedText
        return label
    }()
    
    // MARK: - Lifecycle
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        addSubview(postImageView)
        postImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, height: frame.width - 30)
        
        addSubview(captionLabel)
        captionLabel.anchor(top: postImageView.bottomAnchor, left: postImageView.leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 8, paddingRight: 8)
        
        
        addSubview(thirdImageView)
        thirdImageView.anchor(top: captionLabel.bottomAnchor, right: captionLabel.rightAnchor,paddingTop: 8.2, width: frame.width / 2.4, height: frame.width - 45)
        
        addSubview(thirdaryCaptionLabel)
        thirdaryCaptionLabel.anchor(top: thirdImageView.topAnchor, left: leftAnchor, right: thirdImageView.leftAnchor, paddingTop: -4, paddingLeft: 8, paddingRight: 6)
        
        addSubview(oneCaptionLabel)
        oneCaptionLabel.anchor(top: thirdImageView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 7, paddingLeft: 8, paddingRight: 8)
        
        addSubview(secondImageView)
        secondImageView.anchor(top: oneCaptionLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor,paddingTop: 10, height: frame.width - 30)
        
        
        addSubview(playButton)
        playButton.setDimensions(height: 52, width: 52)
        playButton.centerX(inView: secondImageView)
        playButton.centerY(inView: secondImageView)
        
        addSubview(secondaryCaptionLabel)
        secondaryCaptionLabel.anchor(top: secondImageView.bottomAnchor, left: secondImageView.leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 15, paddingLeft: 8, paddingRight: 8)
        
        
        
        addSubview(fourthImageAdderButton)
        bringSubviewToFront(fourthImageAdderButton)
        fourthImageAdderButton.anchor(top: secondaryCaptionLabel.bottomAnchor, paddingTop: 20, width: 52, height: 52)
        fourthImageAdderButton.centerX(inView: self)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleAddFourthary() {
        fourthImageAdderButton.removeFromSuperview()
        addSubview(fourthImageView)
        fourthImageView.anchor(top: secondaryCaptionLabel.bottomAnchor, left: leftAnchor,paddingTop: 15, width: frame.width / 2.4, height: frame.width - 35)
        
        addSubview(fourtharyCaptionLabel)
        fourtharyCaptionLabel.anchor(top: fourthImageView.topAnchor, left: fourthImageView.rightAnchor, right: rightAnchor, paddingLeft: 8, paddingRight: 6)
        
        addSubview(fifthImageAdderButton)
        fifthImageAdderButton.anchor(top: fourthImageView.bottomAnchor, paddingTop: 20, width: 52, height: 52)
        fifthImageAdderButton.centerX(inView: self)
    }
    
    @objc func handleAddFifthary() {
        fifthImageAdderButton.removeFromSuperview()
        addSubview(fifthImageView)
        
        
        addSubview(fiftharyCaptionLabel)
        fiftharyCaptionLabel.anchor(top: fourthImageView.bottomAnchor, left: leftAnchor, right: rightAnchor,paddingTop: 10, paddingLeft: 8, paddingRight: 8)
        
        fifthImageView.anchor(top: fiftharyCaptionLabel.bottomAnchor,left: leftAnchor, right: rightAnchor, paddingTop: 5, width: frame.width, height: frame.width - 30)
        
        
    }
    
    @objc func donePlaying() {
        playerViewController.view.removeFromSuperview()
        playButton.isHidden = false
        isUserInteractionEnabled = true
    }
    
    @objc func handlePlayVideo() {
        let y = YoutubeDirectLinkExtractor()
        y.extractInfo(for: .urlString("https://www.youtube.com/watch?v=XCwFvGzUxZQ"), success: { info in
            let player = AVPlayer(url: URL(string: info.highestQualityPlayableLink!)!)
            DispatchQueue.main.async {
                self.playerViewController.player = player
                self.playButton.isHidden = true
                self.playerViewController.showsPlaybackControls = false
                
                self.playerViewController.videoGravity = AVLayerVideoGravity.resizeAspectFill
                self.isUserInteractionEnabled = true
                self.addSubview(self.playerViewController.view)
                self.playerViewController.view.frame = self.secondImageView.frame
                self.playerViewController.player?.play()
                NotificationCenter.default.addObserver(self, selector: #selector(self.donePlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
            }
            
        }) { error in
            print(error)
        }
    }
    // MARK: - Helpers
    
}
