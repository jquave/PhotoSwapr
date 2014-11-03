//
//  CameraViewController.swift
//  PhotoSwapr
//
//  Created by Jameson Quave on 9/30/14.
//  Copyright (c) 2014 JQ Software LLC. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    // If we find a device we'll store it here for later use
    var captureDevice : AVCaptureDevice?
    let captureSession = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer?
    var panGesture : UIPanGestureRecognizer?
    var tapGesture : UITapGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        
        let devices = AVCaptureDevice.devices()
        
        // Loop through all the capture devices on this phone
        for device in devices {
            // Make sure this particular device supports video
            if (device.hasMediaType(AVMediaTypeVideo)) {
                // Finally check the position and confirm we've got the back camera
                if(device.position == AVCaptureDevicePosition.Back) {
                    captureDevice = device as? AVCaptureDevice
                    
                    if captureDevice != nil {
                        beginSession()
                    }
                }
            }
        }
        
        panGesture = UIPanGestureRecognizer(target: self, action: "didPan:")
        
        if let gesture = panGesture {
            self.view.addGestureRecognizer(gesture)
        }
        
        tapGesture = UITapGestureRecognizer(target: self, action: "didTap:")
        if let gesture = tapGesture {
            self.view.addGestureRecognizer(gesture)
        }
        
    }
    
    func didTap(gesture : UITapGestureRecognizer) {
        // Capture a photo
        if let device = captureDevice {
            // Create a new instance of the AVCaptureStillImageOutput class
            // in order to perform an AV capture on the camera device
            var capturedImageOutput = AVCaptureStillImageOutput()
            // Add the current session to the image output chain
            captureSession.addOutput(capturedImageOutput)
            // Grab the first available connection in the output chain
            if let captureConnection = capturedImageOutput.connections[0] as? AVCaptureConnection {
                // Capture the image to imageSamplebuffer
                capturedImageOutput.captureStillImageAsynchronouslyFromConnection(captureConnection, completionHandler: { (imageSampleBuffer, error) -> Void in
                    // Convert the sample buffer in to a jpeg representation in the form of an NSData
                    // This is suitable for writing to disk
                    var imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageSampleBuffer)
                    if let img = UIImage(data: imageData) {
                        self.didTakePicture(img)
                    }
                })
            }
        }
    }
    
    func didTakePicture(img : UIImage) {
        var previewVC = UIViewController(nibName: nil, bundle: nil)
        previewVC.view = UIImageView(image: img)
        self.presentViewController(previewVC, animated: true, completion: nil)
    }
    
    func beginSession() {
        var err : NSError? = nil
        // The capture session currently has no inputs, it's just an empty session
        // Add a new input from the captureDevice
        captureSession.addInput(AVCaptureDeviceInput(device: captureDevice, error: &err))
        
        // Check for errors setting the input
        if err != nil {
            println("error: \(err?.localizedDescription)")
        }

        // Set our previewLayer instance variable to be a new preview layer
        // instantiated with the captureSession
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        // Add the layer to the view as a sublayer
        self.view.layer.addSublayer(previewLayer)
        
        // Make it fill the entire contents of the view
        previewLayer?.frame = self.view.layer.frame
        
        // Begin the session
        captureSession.startRunning()
    }
    
    var targetFocus : Float = 0.0
    func didPan(gesture : UIPanGestureRecognizer) {
        // Only look at moved and ended state, if they just began
        // panning, then there's nothing to do yet
        if( gesture.state == .Ended ) {
            
            // Get the translation
            // (distance moved in both directions)
            // based on the coordinate system of the main view
            let translation = gesture.translationInView(self.view)
            
            // Isolate just the x component of this translation
            let xTranslation = translation.x
            
            // Divid by the width of the view, so we can get a value
            // between 0.0 and 1.0 that represents how far the
            // user panned.
            let xTranslationPer = xTranslation / UIScreen.mainScreen().bounds.size.width
            targetFocus = targetFocus + Float(xTranslationPer)
            
            targetFocus = max(targetFocus, 0.0)
            targetFocus = min(targetFocus, 1.0)
            
            adjustCamera(targetFocus)
        }
    }
    
    func adjustCamera(focusPer : Float) {
        if let device = captureDevice {
            if(device.lockForConfiguration(nil)) {
                device.setFocusModeLockedWithLensPosition(focusPer, completionHandler: { (time) -> Void in
                    //
                })
                device.unlockForConfiguration()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
