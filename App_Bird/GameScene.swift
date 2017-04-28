//
//  GameScene.swift
//  App_Bird
//
//  Created by cice on 21/4/17.
//  Copyright © 2017 gashe. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //MARK: - Variables locales
    var background = SKSpriteNode()
    var bird = SKSpriteNode()
    var pipeFinal1 = SKSpriteNode()
    var pipeFinal2 = SKSpriteNode()
    var limitLand = SKNode()
    var timer = Timer()
    
    //grupo de colisiones
    let birdGroup : UInt32 = 1
    let objectGroup : UInt32 = 2
    let gapGroup : UInt32 = 4
    let movingGroup = SKNode()
    
    
    //grupo de los labels
    var score = 0
    var scoreLabel = SKLabelNode()
    var gameOverLabel = SKLabelNode()
    var gameOver = false
    
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -5.0)
        self.addChild(movingGroup)
        
        makeLimitLand()
        makeBird()
        makeBackground()
        makeLoopPipe1AndPipe2()
        makeLabel()
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == gapGroup || contact.bodyB.categoryBitMask == gapGroup{
            score += 1
            scoreLabel.text = "\(score)"
        }else if !gameOver{
            gameOver = true
            movingGroup.speed = 0
            timer.invalidate()
            makeLabelGameOver()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !gameOver{
            bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 70))
        }else{
            resetGame()
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    
    //MARK: - utils
    
    func makeLimitLand(){
        limitLand.position = CGPoint(x: -(self.frame.width/2), y: -(self.frame.height/2))
        limitLand.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 1))
        limitLand.physicsBody?.isDynamic = false
        limitLand.physicsBody?.categoryBitMask = objectGroup
        limitLand.zPosition = 2
        self.addChild(limitLand)
    }
    
    func makeBackground(){
        
        let backgroundFinal = SKTexture(imageNamed: "bg")
        let moveBackground = SKAction.moveBy(x: -backgroundFinal.size().width, y: 0, duration: 9)
        let replaceBackground = SKAction.moveBy(x: backgroundFinal.size().width, y: 0, duration: 0)
        let moveBackgroundForever = SKAction.repeatForever(SKAction.sequence([moveBackground, replaceBackground]))
        
        for c_imagen in 0..<3{
            background = SKSpriteNode(texture: backgroundFinal)
            background.position = CGPoint(x: -(backgroundFinal.size().width/2) + (backgroundFinal.size().width * CGFloat(c_imagen)), y: 0)
            background.zPosition = 0
            background.size.height = self.frame.height
            background.run(moveBackgroundForever)
            self.movingGroup.addChild(background)
        }
        
    }
    
    func makeBird(){
        
        //1 -> creación de texturas
        let birdTexture1 = SKTexture(imageNamed: "flappy1")
        let birdTexture2 = SKTexture(imageNamed: "flappy2")
        
        //2 -> acción
        let animacionBird = SKAction.animate(with: [birdTexture1, birdTexture2], timePerFrame: 0.1)
        
        //3 -> acción para siempre
        let makeBirdForever = SKAction.repeatForever(animacionBird)
        
        //4 -> asignamos la textura a nuestro SKSpriteNode
        bird = SKSpriteNode(texture: birdTexture1)

        
        //5 -> posición en el espacio
        bird.position = CGPoint(x: 0, y: 0)
        bird.zPosition = 15
        
        //GRUPO DE FISICAS
        //bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.width / 2)
        bird.physicsBody = SKPhysicsBody(texture: birdTexture1, alphaThreshold: 0.5, size: CGSize(width: bird.size.width, height: bird.size.height))
        
        bird.physicsBody?.isDynamic = true
        
        bird.physicsBody?.categoryBitMask = birdGroup
        bird.physicsBody?.collisionBitMask = objectGroup
        bird.physicsBody?.contactTestBitMask = objectGroup | gapGroup
        
        
        bird.physicsBody?.allowsRotation = false
        
        
        
        //6 -> animación
        bird.run(makeBirdForever)
        self.addChild(bird)
        
        
    }
    
    
    func makePipeFinal(){
        
        let gapHeight = bird.size.height * 4
        let movementAmount = arc4random_uniform(UInt32(self.frame.height / 2))
        let pipeOffset = CGFloat(movementAmount) - self.frame.height / 4
        
        //mover la tubería
        let movePipes = SKAction.moveBy(x: -self.frame.width - 600, y: 0, duration: TimeInterval(self.frame.width / 200))
        let removePipes = SKAction.removeFromParent()
        let moveAndRemovePipes = SKAction.sequence([movePipes, removePipes])
        
        //creamos el pipe arriba
        let pipetexture1 = SKTexture(imageNamed: "pipe1")
        pipeFinal1 = SKSpriteNode(texture: pipetexture1)
        pipeFinal1.position = CGPoint(x: (self.frame.width / 2) + pipeFinal1.size.width, y: (pipeFinal1.size.height / 2) + (gapHeight / 2) + pipeOffset)
        pipeFinal1.physicsBody = SKPhysicsBody(rectangleOf: pipeFinal1.size)
        pipeFinal1.physicsBody?.isDynamic = false
        pipeFinal1.physicsBody?.categoryBitMask = objectGroup
        pipeFinal1.zPosition = 4
        pipeFinal1.run(moveAndRemovePipes)
        self.movingGroup.addChild(pipeFinal1)
        
        //creamos el pipe arriba
        let pipetexture2 = SKTexture(imageNamed: "pipe2")
        pipeFinal2 = SKSpriteNode(texture: pipetexture2)
        pipeFinal2.position = CGPoint(x: (self.frame.width / 2) + pipeFinal2.size.width, y: -(pipeFinal2.size.height / 2) - (gapHeight / 2) + pipeOffset)
        pipeFinal2.physicsBody = SKPhysicsBody(rectangleOf: pipeFinal2.size)
        pipeFinal2.physicsBody?.isDynamic = false
        pipeFinal2.physicsBody?.categoryBitMask = objectGroup
        pipeFinal2.zPosition = 4
        pipeFinal2.run(moveAndRemovePipes)
        self.movingGroup.addChild(pipeFinal2)
        
        
        makeGapNode(pipeOffset, gapHeight: gapHeight, moveAndRemovePipes: moveAndRemovePipes)
        
    }
    
    func makeGapNode(_ pipeOffset : CGFloat, gapHeight : CGFloat, moveAndRemovePipes : SKAction){
        let gap = SKNode()
        gap.position = CGPoint(x: (self.frame.width / 2) + pipeFinal1.size.width, y: pipeOffset)
        gap.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: pipeFinal2.size.width, height: gapHeight))
        gap.physicsBody?.isDynamic = false
        gap.run(moveAndRemovePipes)
        gap.zPosition = 7
        gap.physicsBody?.categoryBitMask = gapGroup
        self.movingGroup.addChild(gap)
    }
    
    func makeLoopPipe1AndPipe2(){
        
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(makePipeFinal), userInfo: nil, repeats: true)
        
        
    }
    
    
    
    func makeLabel(){
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = 60
        scoreLabel.text = "0"
        scoreLabel.position = CGPoint(x: 0, y: self.frame.height / 2 - 90)
        scoreLabel.zPosition = 10
        self.addChild(scoreLabel)
        
      
    }
    
    func makeLabelGameOver(){
        gameOverLabel.fontName = "Helvetica"
        gameOverLabel.fontSize = 30
        gameOverLabel.text = "GAME OVER :("
        gameOverLabel.position = CGPoint(x: 0, y: 0)
        gameOverLabel.zPosition = 11
        self.addChild(gameOverLabel)
        
        
    }
    
    func resetGame(){
        score = 0
        scoreLabel.text = "0"
        movingGroup.removeAllChildren()
        makeBackground()
        makeLoopPipe1AndPipe2()
        bird.position = CGPoint(x: 0, y: 0)
        bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        gameOverLabel.removeFromParent()
        movingGroup.speed = 1
        gameOver = false
    }
    
    
    
    
    
}
