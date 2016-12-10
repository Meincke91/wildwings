//
//  Wall.swift
//  Wild Wings 2
//
//  Created by Martin Meincke on 26/01/16.
//  Copyright © 2016 drades. All rights reserved.
//

import SpriteKit

enum WallType{
    case TreeWall, houseWall
}

class Wall {
    private var wallType: SKSpriteNode!
    private var obstacles: [Obstacle]!
    
    init(type: WallType, position: CGPoint){
        self.obstacles = []
        self.wallType = SKSpriteNode(imageNamed: String(describing: type))
        self.wallType.anchorPoint = CGPoint.zero
        self.wallType.zPosition = 4
        self.wallType.position = position
    }
    
    func removeAllObstacles(){
        for obstacle in obstacles! {
            obstacle.removeObstacleSprite()
        }
        self.obstacles = []
    }
    // setters
    
    func setObstacle(obstacle: Obstacle) {
        wallType.addChild(obstacle.getObstacleSprite())
        self.obstacles.append(obstacle)
    }
    
    func setSpritePosition(position: CGPoint) {
        self.wallType.position = position
    }
    
    func setSpriteYposition(yPosition: CGFloat){
        self.wallType.position.y = yPosition
    }
    
    func setSpriteXposition(xPosition: CGFloat){
        self.wallType.position.x = xPosition
    }

    
    // getters
    
    func getWallSpriteFrame() -> CGRect {
        return self.wallType.frame
    }
    
    func getWallTypesSprite() -> SKSpriteNode{
        return self.wallType
    }
    
    func getObstacles() -> [Obstacle] {
        return self.obstacles
    }
}
