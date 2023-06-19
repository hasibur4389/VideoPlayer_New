//
//  VLCPlayerCV.swift
//  VideoPlayer_New
//
//  Created by Hasibur Rahman on 19/6/23.
//

import UIKit
import MobileVLCKit

class VLCPlayerCV: UIViewController {

    @IBOutlet var vlcPlayerView: UIView!
    let thePlayer: VLCMediaPlayer = {
        let player = VLCMediaPlayer()
        return player
    }()
    
    var pathURL: String!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        //print("Nowww?")
        pathURL = Bundle.main.path(forResource: "Tom", ofType: "mov")
        
    
        
        if let pathURL = pathURL{
            print("Path found \(pathURL)")

            playVLCPlayer()
            
    }else{
            print("vidoe Path Error")
        }
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(VLCPlayerCV.movieViewTapped(_:)))
               self.vlcPlayerView.addGestureRecognizer(gesture)
    }
    
    
    func playVLCPlayer(){
        let path = NSURL(fileURLWithPath: pathURL)
        var media = VLCMedia(url: path as URL)
        
        thePlayer.media = media
        
        thePlayer.drawable = vlcPlayerView
    
        
        thePlayer.play()
        
    }
    
    @objc func movieViewTapped(_ sender: UITapGestureRecognizer){
       // print("WYhyy")
        if thePlayer.isPlaying {
             thePlayer.pause()
              
           // print("Hellop")
             let remaining = thePlayer.remainingTime
             let time = thePlayer.time

             print("Paused at \(time) with \(remaining) time remaining")
         }
         else {
             thePlayer.play()
             print("Playing")
         }
        
    }
    
    

  

}
