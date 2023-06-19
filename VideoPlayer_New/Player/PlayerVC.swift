//
//  PlayerVC.swift
//  VideoPlayer_New
//
//  Created by Hasibur Rahman on 19/6/23.
//

import UIKit
import Player

class PlayerVC: UIViewController {
    
    let player = Player()
    
    var pathURL: URL!


    @IBOutlet var playerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pathURL = Bundle.main.url(forResource: "Tom", withExtension: "mov")
        
    
        
        if let pathURL = pathURL{
            print("Path found \(pathURL)")

            playPlayer()
            
    }else{
            print("vidoe Path Error")
        }
     
    }
    
    func playPlayer(){
        
         player.playerDelegate = self
         player.playbackDelegate = self
        

         
        player.view.frame = playerView.bounds
        playerView.addSubview(player.view)
        addChild(player)
          player.didMove(toParent: self)
        player.playbackLoops = true
    
      
        player.url = pathURL
        player.playFromBeginning()

        
    }
    

 

}

extension PlayerVC: PlayerPlaybackDelegate, PlayerDelegate {
    func playerCurrentTimeDidChange(_ player: Player) {
//        let fraction = Double(player.currentTime) / Double(player.maximumDuration)
//        let fraction = Float(player.currentTime) / Float(player.maximumDuration)
//
//              self._playbackViewController?.setProgress(progress: CGFloat(fraction), animated: true)
        
        
    }
    
    func playerPlaybackWillStartFromBeginning(_ player: Player) {
        
    }
    
    func playerPlaybackDidEnd(_ player: Player) {
        
    }
    
    func playerPlaybackWillLoop(_ player: Player) {
        
    }
    
    func playerPlaybackDidLoop(_ player: Player) {
        
    }
    
    func playerReady(_ player: Player) {
        
    }
    
    func playerPlaybackStateDidChange(_ player: Player) {
        
    }
    
    func playerBufferingStateDidChange(_ player: Player) {
        
    }
    
    func playerBufferTimeDidChange(_ bufferTime: Double) {
        
    }
    
    func player(_ player: Player, didFailWithError error: Error?) {
        
    }
    
    
}
