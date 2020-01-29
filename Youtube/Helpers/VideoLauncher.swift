//
//  VideoLauncher.swift
//  Youtube
//
//  Created by scott harris on 1/26/20.
//  Copyright © 2020 scott harris. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayerView: UIView {
    
    var player: AVPlayer?
    
    var isPlaying: Bool = false
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .large)
        aiv.color = .white
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()
    
    let videoLengthLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 14)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let videoSlider: UISlider = {
        let slider = UISlider()
        slider.minimumTrackTintColor = .red
        slider.maximumTrackTintColor = .white
        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold, scale: .large)
        let image = UIImage(systemName: "circle.fill", withConfiguration: config)?.withTintColor(.red, renderingMode: .alwaysOriginal)
        slider.setThumbImage(image, for: .normal)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
        return slider
    }()
    
    @objc func handleSliderChange() {
        print(videoSlider.value)
        
        
        if let duration = player?.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            
            let value = Float64(videoSlider.value) * totalSeconds
            
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            player?.seek(to: seekTime, completionHandler: { (completedSeek) in
                // perhaps do something later here
            })
            
        }
        
        
        
    }
    
    let pausePlayButton: UIButton = {
        let button = UIButton(type: .system)
        
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold, scale: .large)
        let image = UIImage(systemName: "pause.fill", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handlePause), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    @objc func handlePause() {
        if isPlaying {
            player?.pause()
            let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold, scale: .large)
            let image = UIImage(systemName: "play.fill", withConfiguration: config)
            pausePlayButton.setImage(image, for: .normal)
        } else {
            player?.play()
            let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold, scale: .large)
            let image = UIImage(systemName: "pause.fill", withConfiguration: config)
            pausePlayButton.setImage(image, for: .normal)
        }
        
        isPlaying = !isPlaying
        
    }
    
    let controlsContainerView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.init(white: 0, alpha: 1)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupPlayerView()
        
        controlsContainerView.frame = frame
        addSubview(controlsContainerView)
        controlsContainerView.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        controlsContainerView.addSubview(pausePlayButton)
        pausePlayButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        pausePlayButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        pausePlayButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        pausePlayButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        controlsContainerView.addSubview(videoLengthLabel)
        videoLengthLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        videoLengthLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        videoLengthLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        videoLengthLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        controlsContainerView.addSubview(videoSlider)
        videoSlider.trailingAnchor.constraint(equalTo: videoLengthLabel.leadingAnchor).isActive = true
        videoSlider.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        videoSlider.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        videoSlider.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        
        backgroundColor = .black
       
    }
    
    private func setupPlayerView() {
//         let urlString = "https://firebasestorage.googleapis.com/v0/b/gameofchats-762ca.appspot.com/o/message_movies%2F12323439-9729-4941-BA07-2BAE970967C7.mov?alt=media&token=3e37a093-3bc8-410f-84d3-38332af9c726"
                
        //        let urlString = "https://devimages-cdn.apple.com/samplecode/avfoundationMedia/AVFoundationQueuePlayer_HLS2/master.m3u8"
                
        let urlString = "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"
                
        if let url = URL(string: urlString) {
            player = AVPlayer(url: url)
            let playerLayer = AVPlayerLayer(player: player)
            self.layer.addSublayer(playerLayer)
            playerLayer.frame = self.frame
            
            player?.play()
            
            player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        // this is when the player is ready and rendering frames
        if keyPath == "currentItem.loadedTimeRanges" {
            activityIndicatorView.stopAnimating()
            controlsContainerView.backgroundColor = .clear
            pausePlayButton.isHidden = false
            isPlaying = true
            
            if let duration = player?.currentItem?.duration {
                let seconds = CMTimeGetSeconds(duration)
                let secondsInt = Int(seconds) % 60
                let minutes = Int(seconds) / 60
                let secondsText = secondsInt > 0 ? "\(secondsInt)" : "00"
                
                let minutesText = minutes > 0 ? "\(minutes)" : "00"
                
                videoLengthLabel.text = "\(minutesText):\(secondsText)"
            }
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class VideoLauncher: NSObject {
    func showVideoPlayer() {
        print("Showing video player animation.....")
        
        if let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            let view = UIView(frame: keyWindow.bounds)
            view.backgroundColor = .white
            
            let x = keyWindow.frame.width - keyWindow.safeAreaInsets.right
            let y = keyWindow.frame.height - keyWindow.safeAreaInsets.bottom
            
            
            view.frame = CGRect(x: x - 10, y: y - 10, width: 10, height: 10)
            
            let height = keyWindow.frame.width * 9 / 16
            let videoPlayerFrame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
            let videoPlayerView = VideoPlayerView(frame: videoPlayerFrame)
            view.addSubview(videoPlayerView)
            
            keyWindow.addSubview(view)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                view.frame = CGRect(x: 0, y: keyWindow.safeAreaInsets.top, width: keyWindow.frame.width, height: keyWindow.frame.height - keyWindow.safeAreaInsets.top)
                
            }, completion: { (completedAnimation) in
                if let kw = keyWindow.rootViewController as? UINavigationController {
                    if let vc = kw.topViewController as? HomeController {
//                        vc.toggleStatusBarHidden()
                    }

                }
                
            })
            
        }
        
        
    }
    
}
