//
//  FavoriteView.swift
//  StockMonitoring
//
//  Created by Александр on 01.04.2021.
//

import UIKit

func degree2radian(a:CGFloat)->CGFloat {
    let b = CGFloat(Double.pi) * a/180
    return b
}

func polygonPointArray(sides:Int,x:CGFloat,y:CGFloat,radius:CGFloat,adjustment:CGFloat=0)->[CGPoint] {
    let angle = degree2radian(a: 360/CGFloat(sides))
    let cx = x // x origin
    let cy = y // y origin
    let r  = radius // radius of circle
    var i = sides
    var points = [CGPoint]()
    while points.count <= sides {
        let xpo = cx - r * cos(angle * CGFloat(i)+degree2radian(a: adjustment))
        let ypo = cy - r * sin(angle * CGFloat(i)+degree2radian(a: adjustment))
        points.append(CGPoint(x: xpo, y: ypo))
        i -= 1;
    }
    return points
}

func starPath(x:CGFloat, y:CGFloat, radius:CGFloat, sides:Int, pointyness:CGFloat, startAngle:CGFloat=0) -> CGPath {
    let adjustment = startAngle + CGFloat(360/sides/2)
    let path = CGMutablePath.init()
    let points = polygonPointArray(sides: sides,x: x,y: y,radius: radius, adjustment: startAngle)
    let cpg = points[0]
    let points2 = polygonPointArray(sides: sides,x: x,y: y,radius: radius*pointyness,adjustment:CGFloat(adjustment))
    var i = 0
    path.move(to: CGPoint(x:cpg.x,y:cpg.y))
    for p in points {
        path.addLine(to: CGPoint(x:points2[i].x, y:points2[i].y))
        path.addLine(to: CGPoint(x:p.x, y:p.y))
        i += 1
    }
    path.closeSubpath()
    return path
}

func drawStarBezier(x:CGFloat, y:CGFloat, radius:CGFloat, sides:Int, pointyness:CGFloat) -> UIBezierPath {
    
    let startAngle = CGFloat(-1*(360/sides/4)) //start the star off rotated left a quarter of the angle of the sides so that its bottom points appear flat (at least for 5 sided stars)
    let path = starPath(x: x, y: y, radius: radius, sides: sides, pointyness: pointyness, startAngle: startAngle)
    let bez = UIBezierPath(cgPath: path)
    return bez
}

@IBDesignable
class FavoriteView: UIView {
    
    @IBInspectable
    var isFavorite: Bool = false { didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    override func draw(_ rect: CGRect) {
          super.draw(rect)
          
//          niceBigStar(sides:5)
          
//          allStars(rect: rect)
        let penStar: UIBezierPath = drawStarBezier(x: rect.midX , y: rect.midY, radius: 4, sides: 5, pointyness:2.5)
        
        if isFavorite {
            UIColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1).setFill()
            penStar.fill()
        } else {
            UIColor.gray.setFill()
            penStar.fill()
      }
    }
//      func niceBigStar(sides:Int) {
//          let penStar:UIBezierPath = drawStarBezier(x: 0, y: 0, radius: 5, sides: sides, pointyness:2.5)
//
//          UIColor.blue.setFill()
//          penStar.fill()
//      }
      
//      func allStars(rect:CGRect) {
//          let allStarsPanel = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 40, height: rect.height))
//          UIColor.lightGray.setFill()
//          allStarsPanel.fill()
//
//          let colors = [UIColor.green, UIColor.yellow, UIColor.blue, UIColor.red, UIColor.white]
//          var offset:CGFloat = 0
//          var color = 0
//          for sides in 2...14 {
//              let star = drawStarBezier(x: 20, y: 20 + offset, radius: 5, sides: sides, pointyness:3)
//              colors[color].setStroke()
//              star.stroke()
//              offset += 30
//              color += 1
//              if (color >= colors.count) {
//                  color = 0
//              }
//          }
//      }

}
