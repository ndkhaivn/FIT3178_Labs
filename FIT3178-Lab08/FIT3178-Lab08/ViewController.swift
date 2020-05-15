//
//  ViewController.swift
//  FIT3178-Lab08
//
//  Created by Nguyễn Đình Khải on 15/5/20.
//  Copyright © 2020 Monash University. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    let images = ["profile0.jpg", "profile1.jpg", "profile2.jpg", "profile3.jpg", "profile4.jpg", "profile5.jpg", "profile6.jpg"]
    
    var shownImageIndex = 0;
    let motionManager: CMMotionManager = CMMotionManager()
    var lastRotation = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        motionManager.deviceMotionUpdateInterval = 1/60
        motionManager.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: handleMotion(data:error:))
    }
    
    @IBAction func handlePinch(recognizer: UIPinchGestureRecognizer) {
        imageView.transform = imageView.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
        recognizer.scale = 1
    }
    
    @IBAction func handleDoulbeTap(recognizer: UITapGestureRecognizer) {
        showImageWithIndex(0)
    }
    
    func showImageWithIndex(_ index: Int) {
        shownImageIndex = (index + images.count) % images.count
        if let newImage = UIImage(named: images[shownImageIndex]) {
            imageView.image = newImage
        }
    }

    @IBAction func handleSwipe(recognizer: UISwipeGestureRecognizer) {
        print(recognizer.direction)
        var newImageIndex = shownImageIndex
        if recognizer.direction == .left {
            newImageIndex += 1
        } else if recognizer.direction == .right {
            newImageIndex -= 1
        }
        
        showImageWithIndex(newImageIndex)
    }
    
    func handleMotion(data: CMDeviceMotion?, error: Error?) -> Void {
        guard let data = data else {
            print("Motion failure: \(String(describing: error))")
            return
        }
        
        let rotation = atan2(data.gravity.x, data.gravity.y) - Double.pi
        let rotationDiff = rotation - lastRotation
        imageView.transform = imageView.transform.rotated(by: CGFloat(rotationDiff))
        lastRotation = rotation
    }
}

