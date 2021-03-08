//
//  GameViewController.swift
//  3dTestSingleView
//
//  Created by Amanda Peterson on 3/4/21.
//

import Foundation
import ARKit

class GameViewController: UIViewController {
    
    let arView: ARSCNView = {
        let view = ARSCNView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // arview needs a configuration
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(arView)

        
        arView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        arView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        arView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        arView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        arView.autoenablesDefaultLighting = true
        arView.automaticallyUpdatesLighting = true
        
        arView.session.run(configuration, options:[])
        
        // add debug optons
        //arView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        addRobot()
    } //end viewDidLoad
    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
    
    
    func addRobot(x: Float = 0, y: Float = 0, z: Float = -0.5) {
            guard let robotScene = SCNScene(named: "connectedRobot.scn") else {
                print("Robot not loaded properly.")
                return
            }
            let robotNode = SCNNode()
            let robotSceneChildNodes = robotScene.rootNode.childNodes
            // print(robotSceneChildNodes.count)
            var combinedMoves = [SCNAction]()
            for childNode in robotSceneChildNodes {
                robotNode.addChildNode(childNode)
                
                let childNodeName = String(childNode.name!)
                
                //turn head
                if(childNodeName == "head") {
                    let rotateNode = SCNAction.rotateBy(x: 2, y: 0, z: 0, duration: 5.0)
                    childNode.runAction(rotateNode)
                }
                
                //kick leg
                if(childNodeName == "hips_joint") {
                    let rotateNode = SCNAction.rotateBy(x: 0, y: -2, z: 0, duration: 5.0)
                    childNode.runAction(rotateNode)
                    
                    var children = childNode.childNodes
                    
                    for item in children {
                        print("CH: " + String(item.name!))
                        let rotateNode = SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 5.0)
                        
                        item.runAction(rotateNode)
                    }
                }
            
            }
            // let groupAct = SCNAction.group(combinedMoves)
            // robotNode.runAction(groupAct)
            
            robotNode.position = SCNVector3(x,y,z)
            robotNode.scale = SCNVector3(0.22, 0.22, 0.22)
            
            arView.scene.rootNode.addChildNode(robotNode)
        }

}
