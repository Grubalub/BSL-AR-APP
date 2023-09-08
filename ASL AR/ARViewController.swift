//
//  ViewController.swift
//  ASL AR
//
//  Created by Gabriel  Cowan on 07/08/2023.
//

import UIKit
import SceneKit
import ARKit

class ARViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
      
        let configuration = ARWorldTrackingConfiguration()
        
        let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
        
        let deviceInput = try? AVCaptureDeviceInput(device: videoDevice!)

        
        if let imageTrack = ARReferenceImage.referenceImages(inGroupNamed: "Letter Cards", bundle: Bundle.main){
            
            configuration.detectionImages = imageTrack
            configuration.maximumNumberOfTrackedImages = 1
            print("Images added")
        }
        configuration.userFaceTrackingEnabled = true
        
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    @objc func playerItemDidReachEnd(notification: NSNotification) {
        if let playerItem: AVPlayerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: CMTime.zero)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
    
        
            let node = SCNNode()
            
            if let imageAnchor = anchor as? ARImageAnchor {
                
                let videoUrl = Bundle.main.url(forResource: imageAnchor.referenceImage.name, withExtension: "mp4")!
                let videoPlayer = AVPlayer(url: videoUrl)
                videoPlayer.volume = 0.0

                        
                        videoPlayer.actionAtItemEnd = .none
                        NotificationCenter.default.addObserver(
                            self,
                            selector: #selector(ARViewController.playerItemDidReachEnd),
                            name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                            object: videoPlayer.currentItem)
                
                let videoNode = SKVideoNode(avPlayer: videoPlayer)
                
                videoNode.play()
                
                let videoScene = SKScene(size: CGSize(width: 1080, height: 1880))
                
                
                videoNode.position = CGPoint(x: videoScene.size.width / 2, y: videoScene.size.height / 2)
                
                videoNode.yScale = -1.0
                
                
                
                videoScene.addChild(videoNode)
                
                
                
                let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width * 2, height: imageAnchor.referenceImage.physicalSize.height * 2)
                
                plane.firstMaterial?.diffuse.contents = videoScene
                
                let planeNode = SCNNode(geometry: plane)
                
                planeNode.eulerAngles.x = -.pi / 4
                

                
                node.addChildNode(planeNode)
                
            }
            
            return node
            
        }
    
    @IBAction func returnHomePage(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
