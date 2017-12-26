//
//  ViewController.swift
//  MotionDetectionCamera
//
//  Created by pervushyn.a on 12/8/17.
//  Copyright © 2017 pervushyn.a. All rights reserved.
//

import Cocoa
import CoreML

class ViewController: NSViewController {
    
    let model = pose_iter_440000a()
    var input: MLMultiArray?
    var net_output: MLMultiArray?
    let testImage = #imageLiteral(resourceName: "PrymitivesTest1")
    
    @IBOutlet weak var inputImage: NSImageView!
    @IBOutlet weak var outputImage: NSImageView!
    @IBOutlet weak var fpsLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        inputImage.image = testImage
        input = testImage.mlMultiArray()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            Log.t()
            self.recognise()
        }
    }
    @IBAction func doIt(_ sender: Any) {
        recognise()
    }
    
    func recognise() {
        
        do {
            let d = Date()
            net_output = try model.prediction(image: input!).net_output
            fpsLabel.stringValue = String(format: "%0.2f sec",  Date().timeIntervalSince(d))
            Log.timeInterval(since: d)
            
            showPosePoints()
            
        } catch {
            Log.d(msg: "\(error)")
        }
        
    }
    
    func showPosePoints() {
        
        guard let net_output = net_output else {
            return
        }
        
        Log.t(msg: "\(net_output)")
        
        let size = testImage.size
        let im = NSImage(size: size)
        
        let rep = NSBitmapImageRep(bitmapDataPlanes: nil,
                                   pixelsWide: Int(size.width),
                                   pixelsHigh: Int(size.height),
                                   bitsPerSample: 8,
                                   samplesPerPixel: 4,
                                   hasAlpha: true,
                                   isPlanar: false,
                                   colorSpaceName: NSColorSpaceName.calibratedRGB,
                                   bytesPerRow: 0,
                                   bitsPerPixel: 0)
        
        
        im.addRepresentation(rep!)
        im.lockFocus()
        
        let rect = NSMakeRect(0, 0, size.width, size.height)
        guard let context = NSGraphicsContext.current?.cgContext
            else { return }
        
        context.clear(rect)
        context.setFillColor(NSColor(calibratedRed: 0, green: 0, blue: 0, alpha: 0.2).cgColor)
        context.fill(rect)
        
        let count = 19//22
        let width = Int(size.width / 8)
        let height = Int(size.height / 8)
        
        
        for i in 0..<count {
            let offset = i * height * width
            
            var maxValue = net_output[offset].doubleValue
            var maxX = 0
            var maxY = 0
            
            for y in 0..<height {
                for x in 0..<width {
                    
                    
                    let value = net_output[offset + y * width + x].doubleValue
                    
                    if value > maxValue {
                        maxValue = value
                        maxX = x
                        maxY = y
                    }
                }
            }
            
            let color = NSColor.red
            
            
            context.fill(CGRect(x: maxX * 8 + 4, y: Int(size.height) - maxY * 8 - 4, width: 2, height: 2))
            
            let attributedText = NSAttributedString(string: "\(i)", attributes: [
                .foregroundColor: color,
                .font: NSFont.systemFont(ofSize: 12)
                ])
            attributedText.draw(at: CGPoint(x:  maxX * 8, y: Int(size.height) - maxY * 8))
            
        }
        
        im.unlockFocus()
        
        
        outputImage.image = im
    }
    
    
}

