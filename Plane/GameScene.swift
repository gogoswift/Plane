/**
交流QQ群
我们都爱Swift：398888638
一起学Swift：8477435
一起学Swift2群：109816704

Swift学习路线图：http://www.hcxy.me/wwdc/html/xuexiliuchengtu/index.html

*/

import SpriteKit

class GameScene: SKScene,SKPhysicsContactDelegate{
    var hero:HeroPlane = HeroPlane()
    var heroName:String = "空军1号"
    var arrEnemy:[EnemyPlane] = []
    var labScore:Int = 0
    var life:Int = 50
    //练习代码区域
    func onLoop(){

        
    }
    //初始化设置
    func onTestInit(){
        
        
    }
    override func didMoveToView(view: SKView) {
        onTestInit()
        onInit()
        initActions()
        initScoreLabel()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "restart", name: "restartNotification", object: nil)
    }
    func restart(){
        isOver = false
        labScore = 0
        life  = 50
        removeAllChildren()
        removeAllActions()
        
        onInit()
        initActions()
        initScoreLabel()
        
    }
    func onInit()
    {
        // init texture
            let backgroundTexture = SKTexture(imageNamed:"background")
            backgroundTexture.filteringMode = .Nearest
            
            // set action
            
            let moveBackgroundSprite = SKAction.moveByX(0, y:-backgroundTexture.size().height, duration: 5)
            let resetBackgroundSprite = SKAction.moveByX(0, y:backgroundTexture.size().height, duration: 0)
            let moveBackgroundForever = SKAction.repeatActionForever(SKAction.sequence([moveBackgroundSprite,resetBackgroundSprite]))
        
            
            for index in 0..<2 {
                let backgroundSprite = SKSpriteNode(texture:backgroundTexture)
                
                backgroundSprite.position = CGPointMake(size.width/2,size.height / 2 + CGFloat(index) * backgroundSprite.size.height)
                backgroundSprite.zPosition = 0
                backgroundSprite.runAction(moveBackgroundForever)
                addChild(backgroundSprite)
            }
        
        
            

            physicsWorld.contactDelegate = self
            physicsWorld.gravity = CGVectorMake(0, 0)
        
        
        hero = HeroPlane()
        hero.position = CGPointMake(self.size.width/2, self.size.height/2)
        hero.zPosition = 1
        hero.onSetName(heroName)
        
        hero.physicsBody = SKPhysicsBody(texture:SKTexture(imageNamed: "hero_fly_1"),size:hero.size)
        hero.physicsBody?.allowsRotation = false
        hero.physicsBody?.categoryBitMask = RoleCategory.HeroPlane.rawValue
        hero.physicsBody?.collisionBitMask = 0
        hero.physicsBody?.contactTestBitMask = RoleCategory.EnemyPlane.rawValue
        self.addChild(hero)
        
        let spawn = SKAction.runBlock{() in
            self.createBullet()}
        let wait = SKAction.waitForDuration(0.2)
        hero.runAction(SKAction.repeatActionForever(SKAction.sequence([spawn,wait])))
        if isSound {
            runAction(SKAction.repeatActionForever(SKAction.playSoundFileNamed("game_music.mp3", waitForCompletion: true)))
        }
        
        initEnemyPlane()
        onTestInit()
    }
    func createBullet()
    {
        onLoop()
        let bulletTexture = SKTexture(imageNamed:"bullet1")
        let bullet = SKSpriteNode(texture:bulletTexture)
        bullet.setScale(0.5)
        bullet.position = CGPointMake(hero.position.x, hero.position.y + hero.size.height/2 + bullet.size.height/2)
        bullet.zPosition = 1
        let bulletMove = SKAction.moveByX(0, y: size.height, duration: 0.5)
        let bulletRemove = SKAction.removeFromParent()
        bullet.runAction(SKAction.sequence([bulletMove,bulletRemove]))
        
        bullet.physicsBody = SKPhysicsBody(rectangleOfSize: bullet.size)
        bullet.physicsBody?.allowsRotation = false
        bullet.physicsBody?.categoryBitMask = RoleCategory.Bullet.rawValue
        bullet.physicsBody?.collisionBitMask = RoleCategory.EnemyPlane.rawValue
        bullet.physicsBody?.contactTestBitMask = RoleCategory.EnemyPlane.rawValue
        
        addChild(bullet)
        
        // play bullet music
        if isSound {
            runAction(SKAction.playSoundFileNamed("bullet.mp3", waitForCompletion: false))
        }
        
        
    }
    
    func initEnemyPlane()
    {
        let spawn = SKAction.runBlock{() in
            self.createEnemyPlane()}
        let wait = SKAction.waitForDuration(0.4)
        runAction(SKAction.repeatActionForever(SKAction.sequence([spawn,wait])))
    }
    
    func createEnemyPlane(){
        
        let choose = arc4random() % 100
        var type:EnemyPlaneType
        var speed:Float
        var enemyPlane:EnemyPlane
        switch choose{
        case 0..<75:
            type = .Small
            speed = Float(arc4random() % 3) + 2
            enemyPlane = EnemyPlane.createSmallPlane()
        case 75..<97:
            type = .Medium
            speed = Float(arc4random() % 3) + 4
            enemyPlane = EnemyPlane.createMediumPlane()
        case _:
            type = .Large
            speed = Float(arc4random() % 3) + 6
            enemyPlane = EnemyPlane.createLargePlane()
            if isSound{
                runAction(SKAction.playSoundFileNamed("enemy2_out.mp3", waitForCompletion: false))
            }
            
        }
        
        enemyPlane.zPosition = 1
        enemyPlane.physicsBody?.dynamic = false
        enemyPlane.physicsBody?.allowsRotation = false
        enemyPlane.physicsBody?.categoryBitMask = RoleCategory.EnemyPlane.rawValue
        enemyPlane.physicsBody?.collisionBitMask = RoleCategory.Bullet.rawValue | RoleCategory.HeroPlane.rawValue
        enemyPlane.physicsBody?.contactTestBitMask = RoleCategory.Bullet.rawValue | RoleCategory.HeroPlane.rawValue
        let x = CGFloat(rand()) % CGFloat(self.size.width-400) + 200
        
        enemyPlane.position = CGPointMake(x, self.size.height)
        
        let moveAction = SKAction.moveToY(0, duration: NSTimeInterval(speed))
        let remove = SKAction.removeFromParent()
        let removeFromArr = SKAction.runBlock{() in
            
            for i in 0..<self.arrEnemy.count {
                if self.arrEnemy[i] == enemyPlane{
                    self.arrEnemy.removeAtIndex(i)
                    break
                }
            }
        
        }
        enemyPlane.runAction(SKAction.sequence([moveAction,remove,removeFromArr]))

        
        addChild(enemyPlane)
        
        arrEnemy.append(enemyPlane)
        
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if isOver {
            self.resignFirstResponder()
            NSNotificationCenter.defaultCenter().postNotificationName("restartNotification", object: nil)
        }else{
            for touch in touches {
                let location = touch.locationInNode(self)
                hero.runAction(SKAction.moveTo(location, duration: 0.1))
            }
        }
        
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touchesBegan(touches, withEvent: event)
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let enemyPlane = contact.bodyA.categoryBitMask & RoleCategory.EnemyPlane.rawValue == RoleCategory.EnemyPlane.rawValue ? contact.bodyA.node as! EnemyPlane : contact.bodyB.node as! EnemyPlane
        
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        if collision == RoleCategory.EnemyPlane.rawValue | RoleCategory.Bullet.rawValue{
            
            // hit bullet
            let bullet = contact.bodyA.categoryBitMask & RoleCategory.Bullet.rawValue == RoleCategory.Bullet.rawValue ? contact.bodyA.node as! SKSpriteNode : contact.bodyB.node as! SKSpriteNode
            
            bullet.runAction(SKAction.removeFromParent())
            
            enemyPlaneCollision(enemyPlane)
            
            
            
        } else if collision == RoleCategory.EnemyPlane.rawValue | RoleCategory.HeroPlane.rawValue{
//            print("hit plane")
            
            
            life--
            if life <= 0 {
                life = 0
                self.scoreLabel.text = "得分：\(self.labScore)      生命：\(self.life)"
                // hit hero plane
                let heroPlane = contact.bodyA.categoryBitMask & RoleCategory.HeroPlane.rawValue == RoleCategory.HeroPlane.rawValue ? contact.bodyA.node as! SKSpriteNode : contact.bodyB.node as! SKSpriteNode
                
                heroPlane.runAction(heroPlaneBlowUpAction,completion:{() in
                    self.runAction(SKAction.sequence([
                        SKAction.playSoundFileNamed("game_over.mp3", waitForCompletion: true),
                        SKAction.runBlock({() in
                            let label = SKLabelNode(fontNamed:"MarkerFelt-Thin")
                            label.text = "GameOver"
                            label.zPosition = 2
                            label.fontColor = SKColor.blackColor()
                            label.position = CGPointMake(self.size.width/2, self.size.height/2 + 20)
                            self.addChild(label)
                            self.isOver = true
                        })
                        ])
                        ,completion:{() in
                            self.resignFirstResponder()
                            NSNotificationCenter.defaultCenter().postNotificationName("gameOverNotification", object: nil)
                        }
                    )}
                )
            }
            
            
        }
    }
    
    func enemyPlaneCollision(enemyPlane:EnemyPlane)
    {
        enemyPlane.hp -= hero.att
//        print("\(enemyPlane.enemyName):\(enemyPlane.hp)")
        
        if enemyPlane.hp < 0 {
            enemyPlane.hp = 0
        }
        if enemyPlane.hp > 0 {
            switch enemyPlane.type{
            case .Small:
                enemyPlane.runAction(smallPlaneHitAction)
            case .Large:
                enemyPlane.runAction(largePlaneHitAction)
            case .Medium:
                enemyPlane.runAction(mediumPlaneHitAction)
            }
            
        } else {
            for i in 0..<self.arrEnemy.count {
                if self.arrEnemy[i] == enemyPlane{
                    self.arrEnemy.removeAtIndex(i)
                    break
                }
            }
            switch enemyPlane.type{
            case .Small:
                changeScore(.Small)
                enemyPlane.runAction(smallPlaneBlowUpAction)
                if isSound{
                    runAction(SKAction.playSoundFileNamed("enemy1_down.mp3", waitForCompletion: false))
                }
                
            case .Large:
                changeScore(.Large)
                
                enemyPlane.runAction(largePlaneBlowUpAction)
                if isSound{
                    runAction(SKAction.playSoundFileNamed("enemy2_down.mp3", waitForCompletion: false))
                }
            case .Medium:
                changeScore(.Medium)
                enemyPlane.runAction(mediumPlaneBlowUpAction)
                if isSound{
                    runAction(SKAction.playSoundFileNamed("enemy3_down.mp3", waitForCompletion: false))
                }
            }
        }
    }
    func initScoreLabel()
    {
        scoreLabel = SKLabelNode(fontNamed:"MarkerFelt-Thin")
        
        scoreLabel.text = "得分：\(labScore)      生命：\(life)"
        scoreLabel.zPosition = 2
        scoreLabel.fontColor = SKColor.blackColor()
        scoreLabel.horizontalAlignmentMode = .Left
        scoreLabel.position = CGPointMake(330,CGFloat(self.size.height - 52))
        addChild(scoreLabel)
    }
    
    func changeScore(type:EnemyPlaneType)
    {
        var score:Int
        switch type {
        case .Large:
            score = 30000
        case .Medium:
            score = 6000
        case .Small:
            score = 1000
        }
        
        scoreLabel.runAction(SKAction.runBlock({() in
            self.scoreLabel.text = "得分：\(self.labScore + score)      生命：\(self.life)"}))
        
    }
    
    func initActions()
    {
        // small hit action
        // nil
        
        
        
        // small blow up action
        var smallPlaneBlowUpTexture = [SKTexture]()
        for i in 1...4 {
            smallPlaneBlowUpTexture.append( SKTexture(imageNamed:"enemy1_blowup_\(i)"))
        }
        smallPlaneBlowUpAction = SKAction.sequence([SKAction.animateWithTextures(smallPlaneBlowUpTexture, timePerFrame: 0.1),SKAction.removeFromParent()])
        
        // medium hit action
        var mediumPlaneHitTexture = [SKTexture]()
        mediumPlaneHitTexture.append( SKTexture(imageNamed:"enemy3_hit_1"))
        mediumPlaneHitTexture.append( SKTexture(imageNamed:"enemy3_fly_1"))
        mediumPlaneHitAction = SKAction.animateWithTextures(mediumPlaneHitTexture, timePerFrame: 0.1)
        
        // medium blow up action
        var mediumPlaneBlowUpTexture = [SKTexture]()
        for i in 1...4 {
            mediumPlaneBlowUpTexture.append( SKTexture(imageNamed:"enemy3_blowup_\(i)"))
        }
        mediumPlaneBlowUpAction = SKAction.sequence([SKAction.animateWithTextures(mediumPlaneBlowUpTexture, timePerFrame: 0.1),SKAction.removeFromParent()])
        
        // large hit action
        var largePlaneHitTexture = [SKTexture]()
        largePlaneHitTexture.append( SKTexture(imageNamed:"enemy2_hit_1"))
        largePlaneHitTexture.append(SKTexture(imageNamed:"enemy2_fly_2"))
        largePlaneHitAction = SKAction.animateWithTextures(largePlaneHitTexture, timePerFrame: 0.1)
        
        // large blow up action
        var largePlaneBlowUpTexture = [SKTexture]()
        for i in 1...7 {
            largePlaneBlowUpTexture.append( SKTexture(imageNamed:"enemy2_blowup_\(i)"))
        }
        largePlaneBlowUpAction = SKAction.sequence([SKAction.animateWithTextures(largePlaneBlowUpTexture, timePerFrame: 0.1),SKAction.removeFromParent()])
        
        // hero plane blow up action
        var heroPlaneBlowUpTexture = [SKTexture]()
        for i in 1...4 {
            heroPlaneBlowUpTexture.append( SKTexture(imageNamed:"hero_blowup_\(i)"))
        }
        heroPlaneBlowUpAction = SKAction.sequence([SKAction.animateWithTextures(heroPlaneBlowUpTexture, timePerFrame: 0.1),SKAction.removeFromParent()])
        
        
    }
    
    enum RoleCategory:UInt32{
        case Bullet = 1
        case HeroPlane = 2
        case EnemyPlane = 4
    }
    
    
    var scoreLabel:SKLabelNode!
    var pauseButton:SKSpriteNode!
    
    var isSound:Bool = true
    var isOver:Bool = false
    
    var smallPlaneHitAction:SKAction!
    var smallPlaneBlowUpAction:SKAction!
    var mediumPlaneHitAction:SKAction!
    var mediumPlaneBlowUpAction:SKAction!
    var largePlaneHitAction:SKAction!
    var largePlaneBlowUpAction:SKAction!
    var heroPlaneBlowUpAction:SKAction!
    
}
