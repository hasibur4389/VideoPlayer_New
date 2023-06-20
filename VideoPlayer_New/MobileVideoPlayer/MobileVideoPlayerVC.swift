//
//  MobileVideoPlayerVC.swift
//  VideoPlayer_New
//
//  Created by Hasibur Rahman on 19/6/23.
//

import UIKit
import MobilePlayer

class MobileVideoPlayerVC: UIViewController {

    @IBOutlet var mobilePlayerView: UIView!
    var pathURL: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        pathURL = Bundle.main.url(forResource: "Tom", withExtension: "mp4")
        
        
    
        
        if let pathURL = pathURL{
            print("Path found \(pathURL)")

            playMobilePlayer()
            
    }else{
            print("vidoe Path Error")
        }

    }
    
    
    func playMobilePlayer(){
     //   let url = NSURL(fileURLWithPath: pathURL)
        
        let bundle = Bundle.main
        let config = MobilePlayerConfig(fileURL: bundle.url(
            forResource: "Tom",
          withExtension: "mp4")!)
        
        let playerVC = MobilePlayerViewController(
            contentURL: pathURL,
          config: config)
        playerVC.title = "Watermarked Player - MMM"
//        playerVC.view.frame = mobileVideoView.bounds
//        playerVC.view = mobileVideoView
        playerVC.activityItems = [pathURL!]
      
        
        playerVC.controlsHidden = false
       
        playerVC.view.frame = mobilePlayerView.bounds
        mobilePlayerView.addSubview(playerVC.view)
        addChild(playerVC)
       // playerVC.didMove(toParent: self)
      

//        playerVC.didMove(toParent: self)
        
          playerVC.play()
        

    
    }

   

}
