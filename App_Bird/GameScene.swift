//
//  GameScene.swift
//  App_Bird
//
//  Created by cice on 21/4/17.
//  Copyright © 2017 gashe. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    //MARK: - Variables locales
    var background = SKSpriteNode()
    var bird = SKSpriteNode()
    var pipeFinal1 = SKSpriteNode()
    var pipeFinal2 = SKSpriteNode()
    var limitLand = SKNode()
    var timer = Timer()
    
    override func didMove(to view: SKView) {
        
        makeLimitLand()
        makeBird()
        makeBackground()
        makeLoopPipe1AndPipe2()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 70))
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    
    //MARK: - utils
    
    func makeLimitLand(){
        limitLand.position = CGPoint(x: -(self.frame.width/2), y: -(self.frame.height/2))
        limitLand.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 1))
        limitLand.physicsBody?.isDynamic = false
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
            self.addChild(background)
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
        let movePipes = SKAction.moveBy(x: -self.frame.width, y: 0, duration: TimeInterval(self.frame.width / 200))
        let removePipes = SKAction.removeFromParent()
        let moveAndRemovePipes = SKAction.sequence([movePipes, removePipes])
        
        //creamos el pipe arriba
        let pipetexture1 = SKTexture(imageNamed: "pipe1")
        pipeFinal1 = SKSpriteNode(texture: pipetexture1)
        pipeFinal1.position = CGPoint(x: self.frame.width / 2, y: (pipeFinal1.size.height / 2) + (gapHeight / 2) + pipeOffset)
        pipeFinal1.physicsBody = SKPhysicsBody(rectangleOf: pipeFinal1.size)
        pipeFinal1.physicsBody?.isDynamic = false
        pipeFinal1.zPosition = 4
        pipeFinal1.run(moveAndRemovePipes)
        self.addChild(pipeFinal1)
        
    }
    
    func makeLoopPipe1AndPipe2(){
        
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(makePipeFinal), userInfo: nil, repeats: true)
        
        
        
    }
    
    
}
