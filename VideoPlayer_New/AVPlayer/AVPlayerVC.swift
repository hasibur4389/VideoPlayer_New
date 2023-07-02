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
    var isFrameImagesFull: Bool = false
    var oldIndexPath: [IndexPath]? = nil
    let framesPerView = 100.0
    var oldMidX: Int = 0
    
    
    @IBOutlet var myCollectionView: UICollectionView!
    
     var avPlayer: AVPlayer!
    var avController: AVPlayerViewController!
    
    @IBOutlet var curretTimeLabel: UILabel!
    @IBOutlet var remainingTimeLabel: UILabel!
    @IBOutlet var timeSlider: UISlider!
    
    
    
    override func viewDidLoad() {
        
        // Video path as URL
        pathURL = Bundle.main.url(forResource: "Tom", withExtension: "mp4")
        
   
        
        if let pathURL = pathURL{
            print("Path found \(pathURL)")
            
            // Configuring AVPlayer
            playAVPlayer()
            
       
            
    }else{
            print("vidoe Path Error")
        }
        
        
        // get frame from 1569 seconds
       // let time = CMTimeMake(value: 6569, timescale: 1000)
//        if let frameImage = getTthFrame(time: time){
//            framView.image = frameImage
//        }else{
//            print("Error frameImage")
//        }
        
//        if let frameImage = getTthPixelBuffer(item: (avPlayer.currentItem)!, time: time){
//            framView.image = frameImage
//        }else{
//            print("Error frameImage")
//        }
      
        
        // getALL Frames
          
        
      
        
//        queue.async {
//            self.extractAllFrames()
//            DispatchQueue.main.async {
//                self.myCollectionView.reloadData()
//            }
//        }
        
        
      
        //myCollectionView.reloadData()
        
        
        // getting all the frames
     
        
        
      
        
        
//         if let frameImage = getTthFrame(time: time){
//             framView.image = frameImage
//         }else{
//             print("Error frameImage")
//         }
       
       
        let isScrolling: Bool = myCollectionView.isDragging || myCollectionView.isDecelerating

        if isScrolling == false {
            print("Is scrolling yes")
//            let visibleRect = CGRect(origin: self.myCollectionView.contentOffset, size: self.myCollectionView.bounds.size)
//              let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
//              let visibleIndexPath = self.myCollectionView.indexPathForItem(at: visiblePoint)
//              print("Visible IndexPath \(visibleIndexPath![1])")
//
//              var interval = (self.avPlayer.currentItem?.duration.seconds)! / 60.0
//              interval = interval.rounded()
//              if self.isPlaying == false{
//                  print("in seeek")
//                  let time = interval*Double(visibleIndexPath![1])
//              self.avPlayer.seek(to: CMTime(seconds: time, preferredTimescale: 1000))
//          }
            
        }
    }
    
  
    
    func playAVPlayer() {
            // Create AVPlayer with the video URL
           avPlayer = AVPlayer(url: pathURL)
        
        // for duration creating a KVC relationship
       
      //  print("\(avPlayer.currentItem?.duration)")
        avPlayer.currentItem?.addObserver(self, forKeyPath: "duration",options: [.new, .initial], context: nil)
        addObserver()
       
       
            // Set up AVPlayerViewController
            avController = AVPlayerViewController()
            avController.player = avPlayer

            // Customize playerViewController's properties
            avController.showsPlaybackControls = false
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
    
    
   
    // Getting frames not all but timed frames
    func getTimedframes(){
        // dividing the duration using framesPerView to get the interval
        
        var interval = (avPlayer.currentItem?.duration.seconds)! / framesPerView
        var duration = (avPlayer.currentItem?.duration.seconds)!
        interval = interval.rounded()
        print(interval)
        var temp = interval
        interval = 0.0
        
        for _ in 0...Int(framesPerView)-1{
            if interval + temp >  duration{
                break
            }
            else{
                interval += temp
            }
         let time = CMTime(seconds: interval, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
            print(time)
            frameImages.append(getTthFrame(time: time)!)
            
            print("interval is \(interval) and time is \(time)")
        }
        myCollectionView.reloadData()
        
    }
        
    
    @IBAction func sliederValueChanged(_ sender: UISlider) {
        avPlayer.seek(to: CMTimeMake(value: Int64(sender.value * 1000), timescale: 1000))
    }
    
    // Adding Periodic observer after 0.5 seconds
    func addObserver(){
        let intervel = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let mainDispathcQueue = DispatchQueue.main
        _ = avPlayer.addPeriodicTimeObserver(forInterval: intervel, queue: mainDispathcQueue, using: { [weak self] time in
            guard let currentItem = self!.avPlayer.currentItem else {return}
            self!.timeSlider.maximumValue = Float(currentItem.duration.seconds)
            self!.timeSlider.minimumValue = 0
            self!.timeSlider.value = Float(currentItem.currentTime().seconds)
            self!.curretTimeLabel.text = self!.getTimeString(time: currentItem.currentTime())
//
            // collectioview
            //MARK: Here i want to seek to the postition of the frame, the frame middle of the colleectionview each time i scroll the collectionview
            //            print("where me?")
//            let visibleRect = CGRect(origin: self!.myCollectionView.contentOffset, size: self!.myCollectionView.bounds.size)
//            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
//            let visibleIndexPath = self!.myCollectionView.indexPathForItem(at: visiblePoint)
//            print("Visible IndexPath \(visibleIndexPath![1])")
//
//            var interval = (self!.avPlayer.currentItem?.duration.seconds)! / 60.0
//            interval = interval.rounded()
//            if self!.isPlaying == false{
//                print("in seeek")
//                let time = interval*Double(visibleIndexPath![1])
//            self!.avPlayer.seek(to: CMTime(seconds: time, preferredTimescale: 1000))
        //}
//
           // self!.avPlayer.seek(to: CMTimeMake(value: Int64(visibleIndexPath![1]*1000), timescale: 1000))
            
          //  getCurrentFrame()
            
            // getting the current frame
            if let frameImage = self!.getTthFrame(time: currentItem.currentTime()){
                self!.framView.image = frameImage
                print("imageeee")
                   }else{
                       print("Error frameImage")
                   }
        })
        
    }
    
    
    func getCurrentFrame(){
        guard let avPlayer = avPlayer ,
               let asset = avPlayer.currentItem?.asset else {
                   return
           }
           
           let imageGenerator = AVAssetImageGenerator(asset: asset)
           imageGenerator.appliesPreferredTrackTransform = true
           let times = [NSValue(time:avPlayer.currentTime())]
           
           imageGenerator.generateCGImagesAsynchronously(forTimes: times) { _, image, _, _, _ in
               if let img = image {
                   DispatchQueue.main.async {
                       self.framView.image = UIImage(cgImage: img)
                   }
                   
               }
           }
        
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
            
            print("Called first time")
            if isFrameImagesFull == false{
                getTimedframes()
                isFrameImagesFull = true
            }
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
    
//    func getTthPixelBuffer(item: AVPlayerItem, time: CMTime) -> UIImage? {
//        let videoOutput = AVPlayerItemVideoOutput(pixelBufferAttributes: [kCVPixelBufferPixelFormatTypeKey as String : NSNumber(value: kCVPixelFormatType_32BGRA)])
//        item.a dd(videoOutput)
//        if let pixelBuffer = videoOutput.copyPixelBuffer(forItemTime: time, itemTimeForDisplay: nil) {
//            let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
//               let tempContext = CIContext(options: nil)
//            let videoImage = tempContext.createCGImage(ciImage, from: CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer)))!
//            let image = UIImage(cgImage: videoImage)
//               return image
//           }
//           return nil
//       }
    
  
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


extension AVPlayerVC: UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let collectionView = scrollView as? UICollectionView{
            print(collectionView.indexPathsForVisibleItems )
            let indexPaths = collectionView.indexPathsForVisibleItems
            
            if oldIndexPath == nil{
                oldIndexPath = indexPaths
            }
            else if oldIndexPath == indexPaths{
                print("same so returned")
                return
                
            }else{
                oldIndexPath = indexPaths
            }
            
            print("still here?")
            var index = 0
            for indexPath in indexPaths {
                index += indexPath[1]
            }
            let midX = (index / 6)
             print("midX \(midX)")
            if oldMidX == 0{
                oldMidX = midX
            }else if oldMidX == midX{
                return
            }else {
                oldMidX = midX
            }
            
            var interval = (self.avPlayer.currentItem?.duration.seconds)! / self.framesPerView
                interval = interval.rounded()
            let time = Double(midX) * interval
            self.avPlayer.seek(to: CMTime(seconds: Double(time), preferredTimescale: CMTimeScale(NSEC_PER_SEC)))

            
              //  print("Is scrolling yes")
//                let visibleRect = CGRect(origin: self.myCollectionView.contentOffset, size: self.myCollectionView.bounds.size)
//            let midX = visibleRect.midX
//            print("mid of X is  \(midX)")
//            let visiblePoint = CGPoint(x: (visibleRect.midX/2.0).rounded(), y: visibleRect.midY*0)
//            let visibleIndexPath = self.myCollectionView.indexPathForItem(at: visiblePoint)
//                //  print("Visible IndexPath \(visibleIndexPath![1])")
//
//                  var interval = (self.avPlayer.currentItem?.duration.seconds)! / 60.0
//                  interval = interval.rounded()
//            if self.isPlaying == false{
//                print("in seeek")
//                let idx = Double(visibleIndexPath![1]).rounded()
//                let time = interval*Double(visibleIndexPath![1])
//                self.avPlayer.seek(to: CMTime(seconds: time, preferredTimescale: 1000))
//            }
//
//
//
        }
    }
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            CGSize(width: (collectionView.frame.size.width)/5 - 1, height: (collectionView.frame.size.width)/5 - 1)
        }
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 1
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 1
        }
    
    
    
    
    
    
}
