import SpriteKit

enum EnemyPlaneType:Int{
    case Small = 0
    case Medium = 1
    case Large = 2
}

class EnemyPlane:SKSpriteNode {
    var label : SKLabelNode?
    var hp:Int = 5
    var type:EnemyPlaneType = .Small
    var tName:String = ""
    var enemyName:String {
        get{
            return tName
        }
        set(newValue){
            label?.text = newValue
            self.tName = newValue
        }
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
        label = SKLabelNode(fontNamed:"MarkerFelt-Thin")
        label!.text = enemyName
        label!.zPosition = 2
        label!.fontColor = SKColor.blackColor()
        label!.position = CGPointMake(0.0, -self.size.height)
        self.addChild(label!)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    class func createSmallPlane()->EnemyPlane{
        let planeTexture = SKTexture(imageNamed:"enemy1_fly_1")
        let plane = EnemyPlane(texture:planeTexture)
        plane.enemyName = "小蜜蜂"
        plane.hp = 1
        plane.type = EnemyPlaneType.Small
        plane.setScale(0.5)
        
        plane.physicsBody = SKPhysicsBody(texture:planeTexture,size:plane.size)
        //plane.physicsBody = SKPhysicsBody(rectangleOfSize: plane.size)
        

        return plane
    }
    
    class func createMediumPlane()->EnemyPlane{
        let planeTexture = SKTexture(imageNamed:"enemy3_fly_1")
//        plane.enemyName = "大黄蜂"
        let plane = EnemyPlane(texture:planeTexture)
        plane.enemyName = "阿帕奇"
        plane.hp = 5
        plane.type = EnemyPlaneType.Medium
        plane.setScale(0.5)
        //plane.physicsBody = SKPhysicsBody(rectangleOfSize: plane.size)
        plane.physicsBody = SKPhysicsBody(texture:planeTexture,size:plane.size)
        return plane
    }
    
    class func createLargePlane()->EnemyPlane{
        let planeTexture = SKTexture(imageNamed:"enemy2_fly_1")
        let plane = EnemyPlane(texture:planeTexture)
        plane.enemyName = "太空堡垒"
        plane.hp = 7
        plane.type = EnemyPlaneType.Large
        plane.setScale(0.5)
        //plane.physicsBody = SKPhysicsBody(rectangleOfSize: plane.size)
        plane.physicsBody = SKPhysicsBody(texture:planeTexture,size:plane.size)
        return plane
    }
    
}