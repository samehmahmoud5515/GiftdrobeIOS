//
//  VideoBackgroundController.swift
//  GiftDrobe
//
//  Created by Logic Designs on 6/4/18.
//  Copyright © 2018 Logic Designs. All rights reserved.
//

import UIKit

import AVFoundation

class VideoBackgroundController: UIViewController {
    var avPlayer: AVPlayer!
    var avPlayerLayer: AVPlayerLayer!
    var paused: Bool = false
    
    override func viewDidLoad() {
        
        let theURL = Bundle.main.url(forResource:"app_animation", withExtension: "mp4")
        
        avPlayer = AVPlayer(url: theURL!)
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        avPlayer.volume = 0
        avPlayer.actionAtItemEnd = .none
        
        avPlayerLayer.frame = view.layer.bounds
        view.backgroundColor = .clear
        view.layer.insertSublayer(avPlayerLayer, at: 0)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidReachEnd(notification:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: avPlayer.currentItem)
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        //let p: AVPlayerItem = notification.object as! AVPlayerItem
      //  p.seek(to: kCMTimeZero)
        let userManager = UserDataManager()
        if userManager.getUserId() != ""
        {
        let storyBoard: UIStoryboard = UIStoryboard(name: "FirstFilterSB", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "GenderVC_nav") as! UINavigationController
        self.present(newViewController, animated: true, completion: nil)
        } else {
            let storyBoard: UIStoryboard = UIStoryboard(name: "SiginingSB", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "LoginVC_nav") as! UINavigationController
            self.present(newViewController, animated: true, completion: nil)
        }
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        avPlayer.play()
        paused = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        avPlayer.pause()
        paused = true
    }
}
