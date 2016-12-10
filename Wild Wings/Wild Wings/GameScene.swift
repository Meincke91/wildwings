//
//  GameScene.swift
//  Wild Wings 2
//
//  Created by Martin Meincke on 26/01/16.
//  Copyright © 2016 drades. All rights reserved.
//

import SpriteKit

//Bitmask categories
enum ColliderType: UInt32 {
    case playerCol = 1
    case edgeCol = 2
    case bottomEdgeCol = 4
    case foodCol = 8
    case obstacle = 16
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var background: Background!
    var characterControl: CharacterControl!

    var viewSize: CGSize!
    var lastUpdateTime : CFTimeInterval = 0
    var coin: ActionObject!
    
    // 1: not started, 2: game running, 3: game over
    var gameState = 1
    
    override init(size: CGSize){
        super.init(size: size)
        viewSize = size
        background = Background(size: viewSize)
        characterControl = CharacterControl(size: viewSize)
        
        background.createInitalWalls(wallElements: 10)
        
        addChild(background.getBackgroundNode())
        addChild(characterControl.getCharacterNode())
        addChild(background.getAllWallSprites())
        
        setUpPhysicalEnviorenment()
        setUpActionObjects()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if gameState == 2{
            let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
            
            switch(contactMask) {
            case ColliderType.playerCol.rawValue | ColliderType.edgeCol.rawValue:
                characterControl.turnCharacter()
            case ColliderType.playerCol.rawValue | ColliderType.bottomEdgeCol.rawValue:
                bottomCollision()
            case ColliderType.playerCol.rawValue | ColliderType.obstacle.rawValue:
                obstacleCollision()
            case ColliderType.playerCol.rawValue | ColliderType.foodCol.rawValue:
                coinCollision()
            default:
                return
            }
        }
    }
   
    
   override func update(_ currentTime: CFTimeInterval) {
        let timeSinceLastUpdate = currentTime - lastUpdateTime
        if timeSinceLastUpdate > 0.5 && gameState == 2 {
            lastUpdateTime = currentTime
            background.updatePoints(amount: 1)
            addRandomObject()
            
        }
    }
    
    func addRandomObject(){
        let randomObject = getRandomObjectType()
        
        switch randomObject {
        case ObjectType.dradesCoin:
            dropCoin(coin: coin)
        default:
            return
        }
    }
    
    func getRandomObjectType() -> ObjectType{
        let sum = UInt32(objectChances.reduce(0, +))
        var presum = 0
        let random = Int(arc4random_uniform(sum))
        
        for (i, chance) in objectChances.enumerated(){
            presum += chance
            if  presum > random {
                return ObjectType(rawValue: i)!
            }
        }
        
        return ObjectType.empty
    }
    
    func bottomCollision(){
        stopGame()
        print("did hit bottom")
    }
    
    func obstacleCollision(){
        stopGame()
        print("did hit obstacle")
    }
    
    func coinCollision(){
        print("did hit coin")
        resetCoin(coin: coin)
    }
    
    func singleTap(location: CGPoint){
        characterControl.characterJump(tapPosition: location)
    }
    
    func startGame(){
        startPhysicalEnvironment()
        background.startWallNodeAnimation()
        background.updatePoints(amount: 0)
    }
    
    func stopGame(){
        gameState = 3
        background.stopWallNodeAnimation()
    }
    
    
    
    func startPhysicalEnvironment(){
        self.physicsWorld.gravity = CGVector.init(dx: 0, dy: -15)
    }
    
    // set ups
    
    func setUpPhysicalEnviorenment(){
        physicsWorld.contactDelegate = self
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsWorld.gravity = CGVector.zero
        self.physicsBody!.categoryBitMask = ColliderType.edgeCol.rawValue
        self.physicsBody!.contactTestBitMask = ColliderType.edgeCol.rawValue
        
        initMainCollisionBoxes()
        
        print("did setup main physics enviorenment")
    }
    
    func setUpActionObjects(){
        coin = ActionObject(type: ObjectType.dradesCoin, position: CGPoint.init(x: viewSize.width/2, y: viewSize.height+200), colliderType: ColliderType.foodCol , colision: false)
        self.addChild(coin.ObjectSprite)
    }
    
    func dropCoin(coin: ActionObject){
        let fallingAction = SKAction.moveTo(y: -100, duration: 2)
        let randomX = CGFloat(arc4random_uniform(UInt32(viewSize.width/3)))
        
        //print("did drop coin at \(randomX) with width of \(viewSize.width)")
        coin.ObjectSprite.position = CGPoint.init(x: viewSize.width/3 + randomX, y: viewSize.height+200)
        coin.addAction(action: fallingAction)
    }
    
    func resetCoin(coin: ActionObject){
        coin.ObjectSprite.removeAllActions()
        coin.getSprite().position = CGPoint.init(x: -200,y: -200)
       // print("coin y postion: \(coin.getSprite().position.y)")
    }
    
    func initMainCollisionBoxes(){
        //right side collision box
        let rightSide = SKNode()
        
        rightSide.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: viewSize.width-background.wallElementFrame.width/2, y: 0), to: CGPoint(x: viewSize.width-background.wallElementFrame.width/2, y: viewSize.height))
        
        rightSide.physicsBody!.categoryBitMask = ColliderType.edgeCol.rawValue
        rightSide.physicsBody!.contactTestBitMask = ColliderType.playerCol.rawValue
        rightSide.name = "rightCol"
        
        
        //left side collision box
        let leftSide = SKNode()
        leftSide.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: background.wallElementFrame.width/2, y: 0), to: CGPoint(x: background.wallElementFrame.width/2, y:viewSize.height))
        leftSide.physicsBody!.categoryBitMask = ColliderType.edgeCol.rawValue
        leftSide.physicsBody!.contactTestBitMask = ColliderType.playerCol.rawValue
        leftSide.name = "leftCol"
        
        //bottom collision box
        let bottom = SKNode()
        bottom.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: 15), to: CGPoint(x: viewSize.width, y: 15))
        bottom.physicsBody!.categoryBitMask = ColliderType.bottomEdgeCol.rawValue
        bottom.physicsBody!.contactTestBitMask = ColliderType.playerCol.rawValue | ColliderType.foodCol.rawValue
        
        self.addChild(rightSide)
        self.addChild(leftSide)
        self.addChild(bottom)
    }
    
    
    
}
