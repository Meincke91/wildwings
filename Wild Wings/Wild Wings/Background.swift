//
//  Background.swift
//  Wild Wings 2
//
//  Created by Martin Meincke on 27/01/16.
//  Copyright © 2016 drades. All rights reserved.
//

import SpriteKit

class Background: SKScene {

    private var leftWalls: [Wall] = []
    private var rightWalls: [Wall] = []
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let backgroundNodes = SKNode()
    let pointsLabel = SKLabelNode()
    
    var viewSize: CGSize!
    let wallElementFrame = SKSpriteNode(imageNamed: "TreeWall").frame
    
    override init(size: CGSize){
        super.init(size: size)
        viewSize = size
        loadBackgroundImages()
        addLabelNodes()
    }
    
    func loadBackgroundImages(){
        let mountain1 = SKSpriteNode(imageNamed: "mountain1")
        let mountain2 = SKSpriteNode(imageNamed: "mountain2")
        let mountain3 = SKSpriteNode(imageNamed: "mountain3")
        
        mountain1.anchorPoint = CGPoint.zero
        mountain2.anchorPoint = CGPoint.zero
        mountain3.anchorPoint = CGPoint.zero
        
        backgroundNodes.addChild(mountain1)
        backgroundNodes.addChild(mountain2)
        backgroundNodes.addChild(mountain3)
    }
    
    func createInitalWalls(wallElements: Int){
        let treeWallFrame = SKSpriteNode(imageNamed: "TreeWall").frame
        
        for i in 0...wallElements {
            let wall = Wall(type: WallType.TreeWall, position: CGPoint.init(x: 0 , y: CGFloat(i) * treeWallFrame.height))
            leftWalls.append(wall)
        }
        
        for i in 0...wallElements {
            //let wall = Wall(type: WallType.TreeWall, position: CGPointMake(viewSize.width - treeWallFrame.width/2 , CGFloat(i) * treeWallFrame.height/2))
            let wall = Wall(type: WallType.TreeWall, position: CGPoint.init(x: viewSize.width, y: CGFloat(i) * treeWallFrame.height))
            wall.getWallTypesSprite().xScale = -1
            rightWalls.append(wall)
        }
    }
    
    func addLabelNodes(){
        pointsLabel.position = CGPoint.init(x: viewSize.width/2, y: viewSize.height/5)
        pointsLabel.zPosition = 4
        backgroundNodes.addChild(pointsLabel)
    }
    
    func startWallNodeAnimation(){
        for (i, wall) in leftWalls.enumerated(){
            let moveSideAction = SKAction.moveTo(y: -wallElementFrame.height, duration: 0.5 + 0.5 * Double(i))
            wall.getWallTypesSprite().run(moveSideAction, completion: {self.checkWallNodePosition(wallElement: wall)} )
        }
        
        for (i, wall) in rightWalls.enumerated(){
            let moveSideAction = SKAction.moveTo(y: -wallElementFrame.height, duration: 0.5 + 0.5 * Double(i))
            wall.getWallTypesSprite().run(moveSideAction, completion: {self.checkWallNodePosition(wallElement: wall)} )
        }
    }
    
    func stopWallNodeAnimation(){
        for wall in leftWalls{
            wall.getWallTypesSprite().removeAllActions()
        }
        for wall in rightWalls{
            wall.getWallTypesSprite().removeAllActions()
        }
    }
    
    func checkWallNodePosition(wallElement: Wall){
        let moveSideAction = SKAction.moveBy( x: 0,  y: -wallElementFrame.height * 10, duration: 5)
        
        wallElement.getWallTypesSprite().removeAllActions()
        wallElement.setSpriteYposition(yPosition: 9 * wallElementFrame.height)
        self.addObstacleToWallElement(wallElement: wallElement)
        wallElement.getWallTypesSprite().run(moveSideAction, completion: {self.checkWallNodePosition(wallElement: wallElement)} )
    }
    
    func addObstacleToWallElement(wallElement: Wall){
        
        wallElement.removeAllObstacles()
        
        let obstacleType = self.getRandomObstacleType()
        
        
        switch obstacleType {
        case ObstacleType.smallBranch, ObstacleType.shortBranch:
            for obstacle in getOppositeWall(wallElement: wallElement).getObstacles(){
                if obstacle.getObstacleType() == ObstacleType.hollowTree {
                    return
                }
            }
            let obstaclePosition = CGPoint.init(x: wallElementFrame.width/2,y: 0)
            let obstacle = Obstacle(type: obstacleType, position:obstaclePosition, colision: true)
            wallElement.setObstacle(obstacle: obstacle)
        case ObstacleType.hollowTree:
            getOppositeWall(wallElement: wallElement).removeAllObstacles()
            
            let obstaclePosition = CGPoint.init(x: wallElementFrame.width/3,y: 0)
            let mirrorPosition = CGPoint.init(x: self.viewSize.width - wallElementFrame.width/3, y: 0)
            
            let birdObstacle = Obstacle(type: ObstacleType.hollowBird, position: obstaclePosition, colision: true)
            
            let birdAction = SKAction.moveBy(x: self.viewSize.width, y: 0, duration: 5)
            
            let obstacle = Obstacle(type: ObstacleType.hollowTree, position: obstaclePosition, colision: false)
            let obstacle2 = Obstacle(type: ObstacleType.hollowTree, position: mirrorPosition, colision: false)
            
            
            obstacle2.getObstacleSprite().xScale = -1
            
            wallElement.setObstacle(obstacle: obstacle)
            wallElement.setObstacle(obstacle: obstacle2)
            wallElement.setObstacle(obstacle: birdObstacle)
            birdObstacle.addAction(action: birdAction)
            
        case ObstacleType.longBranch:
            print(wallElement.getObstacles().count)
            let obstaclePosition = CGPoint.init(x: wallElementFrame.width/2, y: 0)
            let obstacle = Obstacle(type: obstacleType, position:obstaclePosition, colision: true)
            obstacle.getObstacleSprite().xScale = 2
            wallElement.setObstacle(obstacle: obstacle)
        default:
            return
        }
    }
    
    func getOppositeWall(wallElement: Wall) -> Wall{
        let leftIndex = (leftWalls.index{$0 === wallElement})
        let rightIndex = (rightWalls.index{$0 === wallElement})
        
        if  leftIndex != nil {
            return rightWalls[leftIndex!]
        }
        return leftWalls[rightIndex!]
        
    }
    
    func getRandomObstacleType() -> ObstacleType {
        let sum = UInt32(obstacleChances.reduce(0, +))
        var presum = 0
        let random = Int(arc4random_uniform(sum))
        
        for (i, chance) in obstacleChances.enumerated(){
            presum += chance
            if  presum > random {
                return ObstacleType(rawValue: i)!
            }
        }
        
        return ObstacleType.empty
    }
    
    
    func updatePoints(amount: Int){
        points = points + amount
        pointsLabel.text = String(points)
    }
    
    
    // getters and setters
    
    func getAllWallSprites() -> SKNode{
        let wallSprites = SKNode()
        
        for wall in leftWalls {
            wallSprites.addChild(wall.getWallTypesSprite())
        }
        for wall in rightWalls {
            wallSprites.addChild(wall.getWallTypesSprite())
        }
        return wallSprites
    }
    
    func getBackgroundNode() -> SKNode{
        return self.backgroundNodes
    }
    
}
