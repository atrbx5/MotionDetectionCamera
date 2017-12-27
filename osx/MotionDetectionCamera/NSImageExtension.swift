//
//  NSImageExtension.swift
//  MotionDetectionCamera
//
//  Created by pervushyn.a on 12/8/17.
//  Copyright © 2017 pervushyn.a. All rights reserved.
//

import Cocoa
import CoreML

extension NSImage {
    
    func pixelData() -> [UInt8]? {
        let dataSize = size.width * size.height * 4
        var pixelData = [UInt8](repeating: 0, count: Int(dataSize))
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: &pixelData, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: 4 * Int(size.width), space: colorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)
        
        guard
            let cgImg = self.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            return nil
        }
        
        //context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        context?.draw(cgImg, in: rect)
        return pixelData
    }
    
    func mlMultiArray() -> MLMultiArray? {
        
        guard let pixels = pixelData()?.map({ (Double($0) / 255.0) }) else {
            return nil
        }
        
        let awidth = size.width
        let aheight = size.height
        
        guard let array = try? MLMultiArray(shape: [3, aheight, awidth] as [NSNumber], dataType: .double) else {
            return nil
        }
        
        let r = pixels.enumerated().filter { $0.offset % 4 == 0 }.map { $0.element }
        let g = pixels.enumerated().filter { $0.offset % 4 == 1 }.map { $0.element }
        let b = pixels.enumerated().filter { $0.offset % 4 == 2 }.map { $0.element }
        
        let combination = r + g + b
        for (index, element) in combination.enumerated() {
            array[index] = NSNumber(value: element)
        }
        
        return array
    }
    
}
