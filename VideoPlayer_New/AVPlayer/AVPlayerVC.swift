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
    var isPlaying: Bool = false
    
     var avPlayer: AVPlayer!
    var avController: AVPlayerViewController!
    
    @IBOutlet var curretTimeLabel: UILabel!
    @IBOutlet var remainingTimeLabel: UILabel!
    @IBOutlet var timeSlider: UISlider!
    
    
    
    override func viewDidLoad() {
        pathURL = Bundle.main.url(forResource: "Tom", withExtension: "mp4")
        
    
        
        if let pathURL = pathURL{
            print("Path found \(pathURL)")

            playAVPlayer()
            
    }else{
            print("vidoe Path Error")
        }
        
        
        
    }
    
    func playAVPlayer() {
            // Create AVPlayer with the video URL

        //let path = NSURL(fileURLWithPath: pathURL)
        avPlayer = AVPlayer(url: pathURL)
        avPlayer.currentItem?.addObserver(self, forKeyPath: "duration",options: [.new, .initial], context: nil)

            // Set up AVPlayerViewController
            avController = AVPlayerViewController()
            avController.player = avPlayer

            // Customize playerViewController's properties
           // avController.showsPlaybackControls = true
            avController.videoGravity = .resizeAspectFill

            // Set the frame of AVPlayerViewController's view to match the videoView's bounds
            avController.view.frame = avPlayerView.bounds

            // Add AVPlayerViewController's view as a subview to videoView
             addChild(avController)
            avPlayerView.addSubview(avController.view)
            // Play the video
//            avPlayer.play()
//            isPlaying = true
        }
    
   
    
        
    
    @IBAction func sliederValueChanged(_ sender: UISlider) {
        
    }
    
    @IBAction func playBtnPressed(_ sender: UIButton) {
        if isPlaying == true {
            avPlayer.pause()
            sender.setTitle("Play", for: .normal)
            isPlaying = false
        }else{
            avPlayer.play()
            sender.setTitle("Pause", for: .normal)
            isPlaying = true
        }
    }
    
   
 
    @IBAction func forwardBtnPressed(_ sender: Any) {
        guard let duration = avPlayer.currentItem?.duration else{
            print("Not Playring")
            return
            
        }
        let currentTime = CMTimeGetSeconds(avPlayer.currentTime())
        let newTime = currentTime + 5.0
        
        if newTime < (CMTimeGetSeconds(duration) - 5.0){
            let time = CMTimeMake(value: Int64(newTime*1000.0), timescale: 1000)
            avPlayer.seek(to: time)
        }
    }
    
    @IBAction func backwardBtnPressed(_ sender: Any) {
        guard let duration = avPlayer.currentItem?.duration else{
            print("Not Playring")
            return
            }
        
        let currentTime = CMTimeGetSeconds(avPlayer.currentTime())
        var newTime = currentTime - 5.0
        
        if newTime < 0 {
            newTime = 0
        }
        
        let time = CMTimeMake(value: Int64(newTime*1000.0), timescale: 1000)
        avPlayer.seek(to: time)
        
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        let duration = avPlayer.currentItem?.duration.seconds
        
         // print(duration)
        if keyPath == "duration", Double(duration!) > 0.0 {
            let time = CMTimeSubtract(avPlayer.currentItem!.duration , avPlayer.currentItem!.currentTime())
            remainingTimeLabel.text = getTimeString(time: time)
        }
        else {
            print("helllo !")
        }
    }
    
    func getTimeString(time: CMTime) -> String{
        print(time)
        let totalSeconds = CMTimeGetSeconds(time)
        let hours = Int(totalSeconds / 3600)
        let mins = Int(totalSeconds/60) % 60
        let sec = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
        
        if hours > 0{
            return String(format: "%i:%02i:%02i", arguments: [hours, mins, sec])
        }else {
            return String(format: "%02i:%02i", arguments: [mins, sec])

        }
        
    }
    
}



