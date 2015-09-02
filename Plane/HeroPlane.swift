

import SpriteKit

class HeroPlane: SKSpriteNode {
    var label : SKLabelNode?
    var att:Int = 1
    var hp:Int = 3
    
    init() {
        let tt = SKTexture(imageNamed:"hero_fly_1")
        super.init(texture: tt, color: UIColor.whiteColor(), size: tt.size())
        self.setScale(0.5)
        
        let t1 = SKTexture(imageNamed:"hero_fly_1")
        let t2 = SKTexture(imageNamed:"hero_fly_2")
        
        let heroFly = SKAction.animateWithTextures([t1,t2], timePerFrame: 0.1)
        self.runAction(SKAction.repeatActionForever(heroFly))
        
        label = SKLabelNode(fontNamed:"MarkerFelt-Thin")
        label!.text = "空军一号"
        label!.zPosition = 2
        label!.fontColor = SKColor.blackColor()
        label!.position = CGPointMake(0.0, -self.size.height - 20)
        self.addChild(label!)
    }
    func onSetName(name:String){
        label!.text = name
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
