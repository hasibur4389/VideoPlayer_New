//
//  AVPlayerVC.swift
//  VideoPlayer_New
//
//  Created by Hasibur Rahman on 19/6/23.
//

import UIKit
import AVFoundation
import AVKit
import VideoToolbox

class AVPlayerVC: UIViewController {

    @IBOutlet var avPlayerView: UIView!
    
    @IBOutlet var framView: UIImageView!
    
    var frameImages: [UIImage] = []
    var pathURL: URL!
    var mediaPlayerName: String!
    var isPlaying: Bool = false
    
    
    @IBOutlet var myCollectionView: UICollectionView!
    
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
        
        
        // get frame from 1569 seconds
        let time = CMTimeMake(value: 6569, timescale: 1000)
        if let frameImage = getTthFrame(time: time){
            framView.image = frameImage
        }else{
            print("Error frameImage")
        }
        
//        if let frameImage = getTthPixelBuffer(item: (avPlayer.currentItem)!, time: time){
//            framView.image = frameImage
//        }else{
//            print("Error frameImage")
//        }
      
        
        // getALL Frames
       
        
        let queue = DispatchQueue(label:"mQueue")
        
        queue.async {
            self.extractAllFrames()
            DispatchQueue.main.async {
                self.myCollectionView.reloadData()
            }
        }
      
        //myCollectionView.reloadData()
        
            
        
       
       
        
    }
    
    func playAVPlayer() {
            // Create AVPlayer with the video URL

        //let path = NSURL(fileURLWithPath: pathURL)
        avPlayer = AVPlayer(url: pathURL)
        
        // for duration
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
    
    
    func getTthFrame(time: CMTime) -> UIImage? {
        let asset = AVAsset(url: pathURL)
        let imgGenerator = AVAssetImageGenerator(asset: asset)
        imgGenerator.appliesPreferredTrackTransform = true
        
        imgGenerator.requestedTimeToleranceBefore = .zero
        imgGenerator.requestedTimeToleranceAfter = .zero
        do {
            let cgImage = try imgGenerator.copyCGImage(at: time, actualTime: nil)
              return UIImage(cgImage: cgImage)
          } catch {
              print("Failed to generate image: \(error.localizedDescription)")
              return nil
          }
        
      
        
    }
    
    func getTthPixelBuffer(item: AVPlayerItem, time: CMTime) -> UIImage? {
        let videoOutput = AVPlayerItemVideoOutput(pixelBufferAttributes: [kCVPixelBufferPixelFormatTypeKey as String : NSNumber(value: kCVPixelFormatType_32BGRA)])
        item.add(videoOutput)
        if let pixelBuffer = videoOutput.copyPixelBuffer(forItemTime: time, itemTimeForDisplay: nil) {
            let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
               let tempContext = CIContext(options: nil)
            let videoImage = tempContext.createCGImage(ciImage, from: CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer)))!
            let image = UIImage(cgImage: videoImage)
               return image
           }
           return nil
       }
    
  
    func extractAllFrames(){
        
        let asset = AVAsset(url: pathURL)
        let reader = try! AVAssetReader(asset: asset)

        
        // gotta fix this
        let videoTrack = asset.tracks(withMediaType: AVMediaType.video)[0]

        // read video frames as BGRA
        let trackReaderOutput = AVAssetReaderTrackOutput(track: videoTrack, outputSettings:[String(kCVPixelBufferPixelFormatTypeKey): NSNumber(value: kCVPixelFormatType_32BGRA)])

        reader.add(trackReaderOutput)
        reader.startReading()
        
      // var frames: [CGImage] = []
        while let sampleBuffer = trackReaderOutput.copyNextSampleBuffer() {
            print("sample at time \(CMSampleBufferGetPresentationTimeStamp(sampleBuffer))")
            if let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
                // process each CVPixelBufferRef here
                frameImages.append(UIImage(pixelBuffer: imageBuffer)!)
                // see CVPixelBufferGetWidth, CVPixelBufferLockBaseAddress, CVPixelBufferGetBaseAddress, etc
            }
        }
        
        print("Done extracting frames \(frameImages.count)")
      
   
    }
    
//    func extractFramesPerMillisecond() {
//        let asset = AVAsset(url: pathURL)
//        let reader = try! AVAssetReader(asset: asset)
//
//        // Set the time range to extract frames from
//        reader.timeRange = CMTimeRangeMake(start: CMTimeMake(0, 1000), duration: avPlayer.currentItem?.duration)
//
//        // Create an array to store the frames
//        var frames: [CGImage] = []
//
//        // Loop through the sample buffers and extract the frames
//        while let sampleBuffer = reader.copyNextSampleBuffer() {
//            // Get the image buffer from the sample buffer
//            if let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) {
//                // Convert the image buffer to a UIImage object
//                let image = UIImage(pixelBuffer: imageBuffer)!
//
//                // Store the image in the array
//                frames.append(image)
//            }
//        }
//
//        // Calculate the time between each frame in milliseconds
//        let frameInterval = CMTimeGetSeconds(reader.timeRange.duration) / frames.count
//
//        // Print the frames per millisecond
//        print("Frames per millisecond: \(frameInterval)")
//    }


    
}




extension AVPlayerVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        frameImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CollectionViewCell
        else{
            return UICollectionViewCell()
        }
        
        let item = frameImages[indexPath.row]
//        cell.urlString = item.urls["thumb"]
//        cell.myLabel.numberOfLines = 0
//        cell.myLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
//        cell.myLabel.text = item.description
//        cell.myImageView.layer.cornerRadius = 15
        cell.frameImage.image = item
      //  print("returnin cell \(indexPath)")
        
        return cell
    }
    
    
}


extension UIImage {
        public convenience init?(pixelBuffer: CVPixelBuffer) {
            var cgImage: CGImage?
            VTCreateCGImageFromCVPixelBuffer(pixelBuffer, options: nil, imageOut: &cgImage)

            guard let cgImage = cgImage else {
                return nil
            }

            self.init(cgImage: cgImage)
        }
    }

