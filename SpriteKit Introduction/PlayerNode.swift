//
//  PlayerNode.swift
//  SpriteKit Introduction
//
//  Created by Davis Allie on 22/04/16.
//  Copyright © 2016 tutsplus. All rights reserved.
//

import UIKit
import SpriteKit

class PlayerNode: SKSpriteNode {

    var leftConstraint: SKConstraint!
    var middleConstraint: SKConstraint!
    var rightConstraint: SKConstraint!

    func disableAllConstraints() {
        leftConstraint.enabled = false
        middleConstraint.enabled = false
        rightConstraint.enabled = false
    }

    func moveInDirection(direction: ButtonDirection, toLane lane: LaneState) {
        disableAllConstraints()

        let changeInX = (direction == .Left) ? -70.0 : 70.0
        let rotation = (direction == .Left) ? M_PI/4 : -M_PI/4

        let duration = 0.5
        let moveAction = SKAction.moveByX(CGFloat(changeInX), y: 0.0, duration: duration)
        let rotateAction = SKAction.rotateByAngle(CGFloat(rotation), duration: duration/2)
        rotateAction.timingMode = .EaseInEaseOut
        let rotateSequence = SKAction.sequence([rotateAction, rotateAction.reversedAction()])
        let moveGroup = SKAction.group([moveAction, rotateSequence])

        let completion = SKAction.runBlock { () -> Void in
            switch lane {
            case is LeftLane:
                self.leftConstraint.enabled = true
            case is MiddleLane:
                self.middleConstraint.enabled = true
            case is RightLane:
                self.rightConstraint.enabled = true
            default:
                break
            }
        }
        
        let sequenceAction = SKAction.sequence([moveGroup, completion])
        runAction(sequenceAction)
    }

}
