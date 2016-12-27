//
//  CameraUtil.swift
//  ios-camera-demo
//
//  Created by Eiji Kushida on 2016/12/27.
//  Copyright © 2016年 Eiji Kushida. All rights reserved.
//

import UIKit
import AVFoundation

final class CameraUtil: NSObject {

    let imageOutput = AVCapturePhotoOutput()

    func findDevice(position: AVCaptureDevicePosition) -> AVCaptureDevice? {

//        guard let device = AVCaptureDevice.devices().filter({
//            ($0 as! AVCaptureDevice).position == AVCaptureDevicePosition.back
//        }).first as? AVCaptureDevice else {
//            fatalError("No front facing camera found")
//        }
//        return device

        return AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera,
                                             mediaType: AVMediaTypeVideo,
                                             position: position)
    }

    func createView(session: AVCaptureSession?,
                                  device: AVCaptureDevice?) -> AVCaptureVideoPreviewLayer?{

        let videoInput = try! AVCaptureDeviceInput.init(device: device)
        session?.addInput(videoInput)
        session?.addOutput(imageOutput)
        return AVCaptureVideoPreviewLayer.init(session: session)
    }

    func takePhoto() {
        imageOutput.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
    }

    func savePhoto(imageDataBuffer: CMSampleBuffer) {

        if let imageData =
            AVCapturePhotoOutput.jpegPhotoDataRepresentation(
                forJPEGSampleBuffer: imageDataBuffer,
                previewPhotoSampleBuffer: nil),
            let image = UIImage(data: imageData) {

            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }
}

// MARK: - AVCapturePhotoCaptureDelegate
extension CameraUtil: AVCapturePhotoCaptureDelegate {

    func capture(_ captureOutput: AVCapturePhotoOutput,
                 didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?,
                 previewPhotoSampleBuffer: CMSampleBuffer?,
                 resolvedSettings: AVCaptureResolvedPhotoSettings,
                 bracketSettings: AVCaptureBracketedStillImageSettings?,
                 error: Error?) {

                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                savePhoto(imageDataBuffer: photoSampleBuffer!)
    }
}
