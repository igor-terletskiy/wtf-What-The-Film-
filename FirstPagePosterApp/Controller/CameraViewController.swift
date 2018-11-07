//
//  CameraViewController.swift
//  FirstPagePosterApp
//
//  Created by Igor on 08.10.2018.
//  Copyright © 2018 Gargolye. All rights reserved.
//

import UIKit
import SpriteKit
import ARKit
import Firebase

class CameraViewController: UIViewController, ARSKViewDelegate {

    @IBOutlet weak var sceneView: ARSKView!
    private let configuration = ARWorldTrackingConfiguration()
    private var swipeGesture = UISwipeGestureRecognizer()
   
    var selectedImageName: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(myviewTapped))
        swipeGesture.direction = .down
        sceneView.addGestureRecognizer(swipeGesture)
        sceneView.isUserInteractionEnabled = true
    
        sceneView.delegate = self
        sceneView.showsFPS = false
        sceneView.showsNodeCount = false
        
        if let scene = SKScene(fileNamed: "Scene") {
            sceneView.presentScene(scene)
        }
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "Film library", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }
        configuration.detectionImages = referenceImages//Добавление изображений которые нужно искать
    }
    
    @objc
    func myviewTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    var session: ARSession {
        return sceneView.session
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        sceneView.session.pause()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func resetTracking() {
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "Film library", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Prevent the screen from being dimmed to avoid interuppting the AR experience.
        UIApplication.shared.isIdleTimerDisabled = true
        resetTracking()
    }
    
    // MARK: - ARSKViewDelegate
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        if let imageAnchor = anchor as? ARImageAnchor,
            let _ = imageAnchor.referenceImage.name {
            selectedImageName = imageAnchor.referenceImage.name
            self.performSegue(withIdentifier: "showImageInformation", sender: self)
            return nil
        }
        return nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showImageInformation"{
            if let imageInformationVC = segue.destination as? LearnMoreViewController, let posterName = selectedImageName {
                imageInformationVC.names = posterName
            }
        }
    }
}
