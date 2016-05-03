//
//  MainScene.swift
//  SpriteKit Introduction
//
//  Created by Davis Allie on 22/04/16.
//  Copyright © 2016 tutsplus. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class MainScene: SKScene, SKPhysicsContactDelegate {

    var player: PlayerNode!

    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)

        size = view.frame.size

        if let foundPlayer = childNodeWithName("Player") as? PlayerNode {
            player = foundPlayer
        }

        let center = size.width/2.0, difference = CGFloat(70.0)

        player.leftConstraint = SKConstraint.positionX(SKRange(constantValue: center - difference))
        player.middleConstraint = SKConstraint.positionX(SKRange(constantValue: center))
        player.rightConstraint = SKConstraint.positionX(SKRange(constantValue: center + difference))

        player.leftConstraint.enabled = false
        player.rightConstraint.enabled = false

        player.constraints = [player.leftConstraint, player.middleConstraint, player.rightConstraint]
        
        physicsWorld.contactDelegate = self

        let timer = NSTimer(timeInterval: 3.0, target: self, selector: #selector(spawnObstacle(_:)), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)

        let camera = SKCameraNode()
        self.camera = camera
        camera.position = CGPoint(x: center, y: player.position.y + 200)
        let moveForward = SKAction.moveBy(CGVectorMake(0, 100), duration: 1.0)
        camera.runAction(SKAction.repeatActionForever(moveForward))
        addChild(camera)

        player.xScale = 0.4; player.yScale = 0.4 // Makes car smaller to fit better between obstacles

        let light = SKLightNode()
        light.lightColor = UIColor.whiteColor()
        light.falloff = 0.5

        player.addChild(light)
    }

    func spawnObstacle(timer: NSTimer) {
        if player.hidden {
            timer.invalidate()
            return
        }

        let spriteGenerator = GKShuffledDistribution(lowestValue: 1, highestValue: 2)
        let obstacle = SKSpriteNode(imageNamed: "Obstacle \(spriteGenerator.nextInt())")
        obstacle.xScale = 0.3
        obstacle.yScale = 0.3

        let physicsBody = SKPhysicsBody(circleOfRadius: 15)
        physicsBody.contactTestBitMask = 0x00000001
        physicsBody.pinned = true
        physicsBody.allowsRotation = false
        obstacle.physicsBody = physicsBody

        let center = size.width/2.0, difference = CGFloat(85.0)
        var x: CGFloat = 0

        let laneGenerator = GKShuffledDistribution(lowestValue: 1, highestValue: 3)
        switch laneGenerator.nextInt() {
        case 1:
            x = center - difference
        case 2:
            x = center
        case 3:
            x = center + difference
        default:
            fatalError("Number outside of [1, 3] generated")
        }
        
        obstacle.position = CGPoint(x: x, y: (player.position.y + 800))
        addChild(obstacle)
        
        obstacle.lightingBitMask = 0xFFFFFFFF
        obstacle.shadowCastBitMask = 0xFFFFFFFF
    }

    // MARK: - Physics Contact Delegate Methods

    func didBeginContact(contact: SKPhysicsContact) {
        if contact.bodyA.node == player || contact.bodyB.node == player {
            if let explosionPath = NSBundle.mainBundle().pathForResource("Explosion", ofType: "sks"),
                let smokePath = NSBundle.mainBundle().pathForResource("Smoke", ofType: "sks"),
                let explosion = NSKeyedUnarchiver.unarchiveObjectWithFile(explosionPath) as? SKEmitterNode,
                let smoke = NSKeyedUnarchiver.unarchiveObjectWithFile(smokePath) as? SKEmitterNode {

                player.removeAllActions()
                camera?.removeAllActions()
                player.hidden = true
                player.removeFromParent()

                explosion.position = player.position
                smoke.position = player.position

                addChild(smoke)
                addChild(explosion)
            }
        }
    }

}
