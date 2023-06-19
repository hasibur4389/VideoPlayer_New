//
//  AVPlayerVC.swift
//  VideoPlayer_New
//
//  Created by Hasibur Rahman on 19/6/23.
//

import UIKit
import AVFoundation
import AVKit

class AVPlayerVC: UIViewController {

    @IBOutlet var avPlayerView: UIView!
    
    var pathURL: URL!
    var mediaPlayerName: String!
    
    var avPlayer: AVPlayer!
    var avController: AVPlayerViewController!
    
   
    
    
    override func viewDidLoad() {
        pathURL = Bundle.main.url(forResource: "Tom", withExtension: "mov")
        
    
        
        if let pathURL = pathURL{
            print("Path found \(pathURL)")

            playAVPlayer()
            
    }else{
            print("vidoe Path Error")
        }
        
        
        
    }
    
        
    
   
    
   
   
    
}

extension AVPlayerVC {
    
    func playAVPlayer() {
            // Create AVPlayer with the video URL

        //let path = NSURL(fileURLWithPath: pathURL)
        avPlayer = AVPlayer(url: pathURL)

            // Set up AVPlayerViewController
            avController = AVPlayerViewController()
            avController.player = avPlayer

            // Customize playerViewController's properties
            avController.showsPlaybackControls = true
            avController.videoGravity = .resizeAspectFill

            // Set the frame of AVPlayerViewController's view to match the videoView's bounds
            avController.view.frame = avPlayerView.bounds

            // Add AVPlayerViewController's view as a subview to videoView
             addChild(avController)
            avPlayerView.addSubview(avController.view)

            // Play the video
            avPlayer.play()
        }

}


