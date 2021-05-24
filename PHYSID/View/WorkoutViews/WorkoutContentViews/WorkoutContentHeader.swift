//
//  WorkoutContentHeader.swift
//  PHYSID
//
//  Created by Apple on 21.08.2020.
//  Copyright © 2020 PHYSID. All rights reserved.
//

import UIKit
import Firebase
import AVKit
import AVFoundation
import YoutubeDirectLinkExtractor

protocol WorkoutContentHeaderDelegate: class {
    func handlePlayVideo()
    func dismissalThroughRemove(_ header: WorkoutContentHeader)
}

class WorkoutContentHeader: UICollectionReusableView {
    
    
    // MARK: - Properties
    
    var workoutContent: WorkoutContent! {
        didSet { configureUI() }
    }

    
    private var workoutContentAPTypes: [String]? = [String]()

    
    weak var delegate: WorkoutContentHeaderDelegate?
    
    var playerViewController = AVPlayerViewController()
    
    let workoutView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    lazy var removeContentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Remove", for: .normal)
        button.tintColor = .black
        button.isHidden = true
        button.isEnabled = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.addTarget(self, action: #selector(removeContent), for: .touchUpInside)
        return button
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
    
    lazy var pauseButton: UIButton = {
        let button = UIButton(type: .system)
        button.isHidden = true
        button.setImage(#imageLiteral(resourceName: "icons8-pause-50"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = #colorLiteral(red: 0.07358423223, green: 0.07358423223, blue: 0.07358423223, alpha: 1)
        button.layer.borderWidth = 0.1
        button.imageView?.setDimensions(height: 30, width: 30)
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.cornerRadius = 26
        button.addTarget(self, action: #selector(handePauseVideo), for: .touchUpInside)
        return button
    }()
    
    let workoutNameLabel: UILabel = {
        let label = UILabel()
        label.text = "INTERVAL CARDIO"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    let workoutTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "Full body training"
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = . darkGray
        label.text = "My fifth day with this application. Building into royalty, I promise with all my heart.My fifth day with this application. Building into royalty."
        label.numberOfLines = 40
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    let equipmentDescriptiveLabel: UILabel = {
        let label = UILabel()
        label.text = "Equipment"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    let equipmentContentLabel: UILabel = {
        let descriptiveLabel = UILabel()
        descriptiveLabel.text = "Equipment is not required."
        descriptiveLabel.font = UIFont.systemFont(ofSize: 13, weight: .light)
        return descriptiveLabel
    }()
    
    let favoriteButton: UIButton = {
        let favsButton = UIButton(type: .system)
        favsButton.setImage(#imageLiteral(resourceName: "icons8-star-50-2"), for: .normal)
        favsButton.tintColor = .black
        favsButton.contentMode = .scaleAspectFit
        favsButton.backgroundColor = .white
        favsButton.layer.cornerRadius = 5
        favsButton.imageView?.setDimensions(height: 17, width: 18)
        favsButton.addTarget(self, action: #selector(handleFav), for: .touchUpInside)
        return favsButton
    }()
        
    private let firstLine = UnderLineView()
    private let thirdLine = UnderLineView()
    private let secondLine = UnderLineView()
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        backgroundColor = .white
        
        addSubview(workoutView)
        workoutView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: frame.width)
        
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Service.fetchUser(withUid: uid) { (user) in
            if user.isAdmin {
                self.addSubview(self.removeContentButton)
                self.bringSubviewToFront(self.removeContentButton)
                self.removeContentButton.anchor(top: self.workoutView.bottomAnchor, left: self.workoutView.leftAnchor, paddingTop: 6,paddingLeft: 6, width: 70, height: 30)
                self.removeContentButton.isEnabled = true
                self.removeContentButton.isHidden = false
            }
        }
        
        
        addSubview(playButton)
        playButton.anchor(top: workoutView.bottomAnchor, right: workoutView.rightAnchor, paddingTop: -25, paddingRight: 15,width: 52, height: 52)
        
        addSubview(pauseButton)
        bringSubviewToFront(pauseButton)
        pauseButton.anchor(top: workoutView.bottomAnchor, right: workoutView.rightAnchor, paddingTop: -25, paddingRight: 15,width: 52, height: 52)
        
        
        addSubview(workoutNameLabel)
        workoutNameLabel.anchor(top: workoutView.bottomAnchor, paddingTop: 28)
        workoutNameLabel.centerX(inView: self)
        
        addSubview(workoutTypeLabel)
        workoutTypeLabel.anchor(top: workoutNameLabel.bottomAnchor, paddingTop: 8)
        workoutTypeLabel.centerX(inView: workoutNameLabel)
        
        addSubview(firstLine)
        firstLine.anchor(top: workoutTypeLabel.bottomAnchor, paddingTop: 16, width: 340, height: 0.6)
        firstLine.centerX(inView: self)
        
        addSubview(favoriteButton)
        favoriteButton.anchor(top: firstLine.bottomAnchor ,right: firstLine.rightAnchor, paddingRight: 12)
        
        addSubview(equipmentDescriptiveLabel)
        equipmentDescriptiveLabel.anchor(top: firstLine.bottomAnchor, left: firstLine.leftAnchor, paddingTop: 20)
        addSubview(equipmentContentLabel)
        equipmentContentLabel.anchor(top: equipmentDescriptiveLabel.bottomAnchor, left: equipmentDescriptiveLabel.leftAnchor, paddingTop: 2)
        
        addSubview(secondLine)
        secondLine.anchor(top: equipmentContentLabel.bottomAnchor, paddingTop: 40, width: 340, height: 0.4)
        secondLine.centerX(inView: self)
        
        addSubview(descriptionLabel)
        descriptionLabel.anchor(top: secondLine.bottomAnchor, left: secondLine.leftAnchor, right: secondLine.rightAnchor, paddingTop: 16)
        
        addSubview(thirdLine)
        thirdLine.anchor(top: descriptionLabel.bottomAnchor, left: firstLine.leftAnchor, right: firstLine.rightAnchor,paddingTop: 16, paddingLeft: 0, paddingRight: 0, height: 0.3)
        
        
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Selectors
    
    @objc func handleFav() {
        
        
    }
    
    @objc func handePauseVideo() {
        playerViewController.player?.pause()
        playButton.isHidden = false
        isUserInteractionEnabled = true
    }
    
    @objc func donePlaying() {
        playerViewController.view.removeFromSuperview()
        playButton.isHidden = false
        isUserInteractionEnabled = true
    }
    
    @objc func removeContent() {
        Service.removeWorkoutContent(workoutContent: workoutContent) { (err, ref) in
            if let err = err {
                print(err.localizedDescription)
            }
            self.delegate?.dismissalThroughRemove(self)
        }
    }
    
    @objc func handlePlayVideo() {
        
        guard let workoutVideoUrl = workoutContent.instructionVideoUrl else { return }
        if workoutVideoUrl == "" {
            
        } else {
        
        let y = YoutubeDirectLinkExtractor()
        y.extractInfo(for: .urlString(workoutVideoUrl), success: { info in
            let player = AVPlayer(url: URL(string: info.highestQualityPlayableLink!)!)
            DispatchQueue.main.async {
                self.playerViewController.player = player
                self.playButton.isHidden = true
                self.playerViewController.showsPlaybackControls = false
                
                self.playerViewController.videoGravity = AVLayerVideoGravity.resizeAspectFill
                self.isUserInteractionEnabled = true
                self.addSubview(self.playerViewController.view)
                self.playerViewController.view.frame = self.workoutView.bounds
                self.playerViewController.player?.play()
                NotificationCenter.default.addObserver(self, selector: #selector(self.donePlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
            }
        }) { error in
            print(error)
        }
        }
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        guard let workoutContent = workoutContent else { return }
        guard let workoutImageUrl = workoutContent.imageUrl else { return }
        guard let workoutImageUrlUrl = URL(string: workoutImageUrl) else { return }
        workoutView.sd_setImage(with: workoutImageUrlUrl)
        workoutNameLabel.text = workoutContent.title.uppercased()
        workoutTypeLabel.text = workoutContent.workoutContenttype
        equipmentContentLabel.text = workoutContent.equipments
        descriptionLabel.text = workoutContent.description
    }
}
