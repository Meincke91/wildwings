//
//  CharacterControl.swift
//  Wild Wings 2
//
//  Created by Martin Meincke on 28/01/16.
//  Copyright © 2016 drades. All rights reserved.
//

import SpriteKit

class CharacterControl: SKScene{
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var viewSize: CGSize!
    
    private let characterNode = SKSpriteNode(imageNamed: "pig")
    
    override init(size: CGSize){
        super.init(size: size)
        viewSize = size
        createCharacter()
    }

    
    func createCharacter(){
        characterNode.position = CGPoint.init(x: viewSize.width/2, y: viewSize.height/3)
        characterNode.zPosition = 6
        
        characterNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize.init(width: characterNode.frame.width, height: characterNode.frame.height))
        characterNode.physicsBody!.isDynamic = true
        characterNode.physicsBody!.categoryBitMask = ColliderType.playerCol.rawValue
        characterNode.physicsBody!.contactTestBitMask = ColliderType.edgeCol.rawValue | ColliderType.bottomEdgeCol.rawValue | ColliderType.obstacle.rawValue
        characterNode.physicsBody!.collisionBitMask = ColliderType.bottomEdgeCol.rawValue | ColliderType.obstacle.rawValue
        
    }
    
    func startCharacterMovement(){
        characterNode.physicsBody?.velocity = CGVector.init(dx: 450, dy: 0.0)
    }
    
    func getCharacterNode() -> SKSpriteNode{
        return characterNode
    }
    
    func characterJump(tapPosition: CGPoint){
        // turn the character
        if tapPosition.x < viewSize.width/2 {
            self.characterNode.physicsBody?.velocity = CGVector.init(dx: -450, dy: 0.0)
            self.characterNode.xScale = -1
        }
        else{
            self.characterNode.physicsBody?.velocity = CGVector.init(dx: 450, dy: 0.0)
            self.characterNode.xScale = 1
        }
        
        // apply vertical force to character
        if (self.characterNode.physicsBody?.velocity.dy)! < CGFloat(600) {
            self.characterNode.physicsBody?.applyImpulse(CGVector.init(dx: 0.0, dy: 2050))
            if (self.characterNode.physicsBody?.velocity.dy)! > CGFloat(600){
                self.characterNode.physicsBody?.velocity.dy = 600
            }
        }
        else{
            return
        }
    }
    
    func turnCharacter(){
        if self.characterNode.position.x >= self.viewSize.width/2 {
            self.characterNode.physicsBody?.velocity = CGVector.init(dx: -450,dy: 0.0)
            self.characterNode.xScale = -1
        } else {
            self.characterNode.physicsBody?.velocity = CGVector.init(dx: 450, dy: 0.0)
            self.characterNode.xScale = 1
        }
    }
    
    func turnCharacterRight(){
        self.characterNode.physicsBody?.velocity = CGVector.init(dx: 450, dy: 0.0)
        self.characterNode.xScale = 1
    }
    
    func turnCharacterLeft(){
        self.characterNode.physicsBody?.velocity = CGVector.init(dx: -450, dy: 0.0)
        self.characterNode.xScale = -1
    }
}
