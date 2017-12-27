//
//  ViewController.swift
//  NNPoseIOS
//
//  Created by pervushyn.a on 12/6/17.
//  Copyright © 2017 pervushyn.a. All rights reserved.
//
//const std::map<unsigned int, std::string> POSE_COCO_BODY_PARTS {
//    {0,  "Nose"},
//    {1,  "Neck"},
//    {2,  "RShoulder"},
//    {3,  "RElbow"},
//    {4,  "RWrist"},
//    {5,  "LShoulder"},
//    {6,  "LElbow"},
//    {7,  "LWrist"},
//    {8,  "RHip"},
//    {9,  "RKnee"},
//    {10, "RAnkle"},
//    {11, "LHip"},
//    {12, "LKnee"},
//    {13, "LAnkle"},
//    {14, "REye"},
//    {15, "LEye"},
//    {16, "REar"},
//    {17, "LEar"},
//    {18, "Background"}
//};

import UIKit

class ViewController: UIViewController {
    
    let m = pose_iter_440000a()
    var res: pose_iter_440000aOutput?
    
    var imageIndex: Int = 0
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var heatMapImageView: UIImageView!

    @IBOutlet weak var fpsLabel: UILabel!
    
    @IBAction func update(_ sender: Any) {
        imageIndex += 1
        testImage = [#imageLiteral(resourceName: "PrymitivesTest0"), #imageLiteral(resourceName: "PrymitivesTest1"), #imageLiteral(resourceName: "PrymitivesTest2")][imageIndex % 3]
        imageView.image = testImage
        runIt()
    }
    
    var testImage = #imageLiteral(resourceName: "PrymitivesTest0")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = testImage
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.runIt()
        }
        
    }
    
    func runIt() {
        Log.t()
        
        //let b = testImage.cvBuffer()
        
        do {
            let d = Date()
            res = try m.prediction(image: testImage.mlMultiArray()!)
            fpsLabel.text = String(format: "%0.2f sec",  Date().timeIntervalSince(d))
            
            showPosePoints()
        } catch {
            Log.d(msg: "\(error)")
        }
    }
    
    func showPosePoints() {
        
        guard let net_output = res?.net_output else {
            return
        }
        
        Log.t(msg: "\(net_output)")
        
        UIGraphicsBeginImageContextWithOptions(testImage.size, false, 2.0)
        
        guard
            let context = UIGraphicsGetCurrentContext()
            else {
                return
        }
        
        context.setLineWidth(1.0)
        context.setStrokeColor(UIColor.white.cgColor)
        context.setFillColor(UIColor.white.cgColor)
        
        
        for i in 0..<19 {
            let offset = i * 32 * 50
            
            var maxValue = net_output[offset].doubleValue
            var maxX = 0
            var maxY = 0
            
            for y in 0..<32 {
                for x in 0..<50 {
                    
                    
                    let value = net_output[offset + y * 50 + x].doubleValue
                    
                    if value > maxValue {
                        maxValue = value
                        maxX = x
                        maxY = y
                    }
                }
            }
            
            var color = UIColor.red
            
            switch Int(i / 19) {
            case 0:
                color = .red
            case 1:
                color = .green
            case 2:
                color = .blue
            default:
                break
            }
            
            context.fill(CGRect(x: maxX * 8, y: maxY * 8, width: 2, height: 2))
            
            let attributedText = NSAttributedString(string: "\(i % 19 )", attributes: [
                .foregroundColor: color,
                .font: UIFont.systemFont(ofSize: 6)
                ])
            attributedText.draw(at: CGPoint(x:  maxX * 8, y: maxY * 8))
            
        }
        
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        heatMapImageView.image = resultImage//UIImage.image(pixels: pixels, 40, 25)
    }
    
}


//var minValue = net_output[0].doubleValue

//        var pixels = [PixelData]()
//
//        for _ in 0..<40 {
//            for _ in 0..<25 {
//                pixels.append(PixelData(r: 0, g: 0, b: 0, a: 255))
//            }
//        }


//        for x in 0..<40 {
//
//            for y in 0..<25 {
//
//                let i = offset + y * 40 + x
//                let v = net_output[i].doubleValue
//
//                if v > 0 {
//
//                    pixels.append(PixelData(r: UInt8(v * 255.0 / maxValue), g: 0, b: 0, a: 255))
//
//                } else {
//
//                    pixels.append(PixelData(r: 0, g: 0, b: 0, a: 255))
//                }
//            }
//        }

