//
//  ViewController.swift
//  VideoPlayer_New
//
//  Created by Hasibur Rahman on 19/6/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func AVPlayerPressed(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AVPlayerVC") as! AVPlayerVC
//            vc.pathURL = url
      
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func MobilePlayerPressed(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MobileVideoPlayerVC") as! MobileVideoPlayerVC
//            vc.pathURL = url
      
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func VLCPlayerPressed(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VLCPlayerCV") as! VLCPlayerCV
//            vc.pathURL = url
      
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func playerPressed(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PlayerVC") as! PlayerVC
//            vc.pathURL = url
      
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

