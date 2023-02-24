//
//  depth_capture.swift
//  Runner
//
//  Created by Jay Palamand on 2/22/23.
//

import Foundation
import AVFoundation

@objc(DeepAR)
class DeepAR: NSObject {
  @objc
  func captureDepthData() -> [Float] {
    var depthData: [Float] = []
    if let device = AVCaptureDevice.default(for: .video), device.isDepthDataDeliverySupported {
      let session = AVCaptureSession()
      session.beginConfiguration()
      let input = try! AVCaptureDeviceInput(device: device)
      session.addInput(input)
      let photoOutput = AVCapturePhotoOutput()
      let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
      settings.isDepthDataDeliveryEnabled = true
      photoOutput.capturePhoto(with: settings, delegate: self)
      session.addOutput(photoOutput)
      session.commitConfiguration()
      session.startRunning()
      let depthMap = photoOutput.recommendedDepthDataFormat(for: settings)
      if let attachment = depthMap?.depthDataMap {
        depthData = Array(UnsafeBufferPointer(start: attachment.float32Data, count: attachment.size.width * attachment.size.height))
      }
    }
    return depthData
  }
}

extension DeepAR: AVCapturePhotoCaptureDelegate {
  func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
  }
}
