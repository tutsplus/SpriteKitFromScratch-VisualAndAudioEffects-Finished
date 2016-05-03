//
//  LaneStateMachine.swift
//  SpriteKit Introduction
//
//  Created by Davis Allie on 22/04/16.
//  Copyright © 2016 tutsplus. All rights reserved.
//

import GameplayKit

class LaneStateMachine: GKStateMachine {

}

class LaneState: GKState {
    var playerNode: PlayerNode

    init(player: PlayerNode) {
        playerNode = player
    }
}

class LeftLane: LaneState {
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        if stateClass == MiddleLane.self {
            return true
        }

        return false
    }

    override func didEnterWithPreviousState(previousState: GKState?) {
        playerNode.moveInDirection(.Left, toLane: self)
    }
}

class MiddleLane: LaneState {
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        if stateClass == LeftLane.self || stateClass == RightLane.self {
            return true
        }

        return false
    }

    override func didEnterWithPreviousState(previousState: GKState?) {
        if previousState is LeftLane {
            playerNode.moveInDirection(.Right, toLane: self)
        } else if previousState is RightLane {
            playerNode.moveInDirection(.Left, toLane: self)
        }
    }
}

class RightLane: LaneState {
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        if stateClass == MiddleLane.self {
            return true
        }

        return false
    }

    override func didEnterWithPreviousState(previousState: GKState?) {
        playerNode.moveInDirection(.Right, toLane: self)
    }
}
