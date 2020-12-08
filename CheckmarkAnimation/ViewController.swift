//
//  ViewController.swift
//  CheckmarkAnimation
//
//  Created by Naoyuki Otani on 2020/12/08.
//

import UIKit

class ViewController: UIViewController {

    
    /// チェックマークを描画するビュー
    @IBOutlet weak var checkmarkView: UIView!

    // 線の幅
    private let lineWidth = CGFloat(25)
    // 線の色
    private let lineStrokeColor = UIColor.green.cgColor
    // 円を描くアニメーション時間
    private let circleDrawingTime = CFTimeInterval(0.8)
    // チェックマークを描くアニメーション時間
    private let checkmarkDrawingTime = CFTimeInterval(0.5)
    // チェックマークの開始点
    private let checkmarkStartPoints = CGPoint(x: 42.2784, y: 118.7159)
    // チェックマークの線の移動先座標群
    private let checkmarkMovePoints: [CGPoint] = [
        CGPoint(x: 51.9758, y: 129.4688),
        CGPoint(x: 61.6744, y: 140.2230),
        CGPoint(x: 71.3770, y: 150.9817),
        CGPoint(x: 81.0807, y: 161.7416),
        CGPoint(x: 90.7791, y: 172.4956),
        CGPoint(x: 98.5625, y: 162.2959),
        CGPoint(x: 106.8509, y: 152.5011),
        CGPoint(x: 115.5835, y: 143.0999),
        CGPoint(x: 124.7762, y: 134.1420),
        CGPoint(x: 134.4632, y: 125.7198),
        CGPoint(x: 147.8296, y: 115.5880),
        CGPoint(x: 161.8935, y: 106.4529),
        CGPoint(x: 176.6142, y: 98.4059),
        CGPoint(x: 191.9338, y: 91.5967)
    ]
    
    // 直前のアニメーションレイヤー
    private var animationLayers = [CALayer]()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    /// チェックボタンイベント
    @IBAction func checkButtonAction() {
        
        // 前回描画したレイヤーがあれば消す
        animationLayers.forEach {
            $0.removeFromSuperlayer()
        }
        animationLayers.removeAll()

        // 描画対象のCGRect
        let rect = checkmarkView.bounds
        // 円を描くレイヤーを作成
        let circleLayer = createDrawCircleLayer(to: rect)
        // チェックマークを描くレイヤーを作成
        let checkmarkLayer = createDrawCheckmarkLineLayer(to: rect)

        // アニメーションレイヤーを描画対象のViewのレイヤーに設定
        checkmarkView.layer.addSublayer(circleLayer)
        checkmarkView.layer.addSublayer(checkmarkLayer)

        // 2回目以降の開始時にレイヤーを消すために保持する
        animationLayers.append(circleLayer)
        animationLayers.append(checkmarkLayer)
    }

    
    // MARK: - Private functions
    
    /// 円を描くアニメーションレイヤーの生成
    /// - Parameter rect: 円を描く領域のCGRect
    /// - Returns: 円を描くアニメーションレイヤー
    private func createDrawCircleLayer(to rect: CGRect) -> CAShapeLayer {

        // 円周率(π)
        let pi = CGFloat.pi
        // 中心点
        let centerPoint = CGPoint(x: rect.width / 2.0, y: rect.width / 2.0)
        // 半径
        let radius = CGFloat(rect.width / 2.0)
        // 開始角度(円の右端が0、そこから時計回りに1周で2π)
        let startAngle = pi / 2    // π/2(90度)で円の下側を開始点とする
        // 終了角度
        let endAngle = startAngle + (2 * pi)    // 開始角度に2π(360度)足して、１周した位置を終了角度とする

        // 円を描くレイヤーを作成
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = rect
        // レイヤーの背景色
        shapeLayer.backgroundColor = UIColor.clear.cgColor
        // 線の色
        shapeLayer.strokeColor = lineStrokeColor
        // 線で囲まれた内部の塗り潰し色
        shapeLayer.fillColor = UIColor.clear.cgColor
        // 線の太さ
        shapeLayer.lineWidth = lineWidth
        // 線の終端を角丸とする
        shapeLayer.lineCap = .round
        // ベジェパスを作成
        let circlePath = UIBezierPath(arcCenter: centerPoint,
                                      radius: radius,
                                      startAngle: startAngle,
                                      endAngle: endAngle,
                                      clockwise: true)  // trueで時計回り
        // ベジェパスからCGPathを取得してレイヤーのパスとする
        shapeLayer.path = circlePath.cgPath

        // アニメーションをLayerに設定
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = circleDrawingTime
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        shapeLayer.add(animation, forKey: nil)

        return  shapeLayer
    }

    /// チェックマークを描くアニメーションレイヤーの生成
    /// - Parameter rect: チェックマークを描く領域のCGRect
    /// - Returns: チェックマークを描くアニメーションレイヤー
    private func createDrawCheckmarkLineLayer(to rect: CGRect) -> CAShapeLayer {

        // 線を描くレイヤーを作成
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = rect
        // レイヤーの背景色
        shapeLayer.backgroundColor = UIColor.clear.cgColor
        // 線の色
        shapeLayer.strokeColor = lineStrokeColor
        // 線で囲まれた内部の塗り潰し色
        shapeLayer.fillColor = UIColor.clear.cgColor
        // 線の太さ
        shapeLayer.lineWidth = lineWidth
        // 線の終端を四角とする
        shapeLayer.lineCap = .square

        // ベジェパスを作成
        let checkmarkPath = UIBezierPath()
        // 開始点に移動
        checkmarkPath.move(to: checkmarkStartPoints)
        // 移動先に線を引いていく
        checkmarkMovePoints.forEach {
            checkmarkPath.addLine(to: $0)
        }
        
        // ベジェパスからCGPathを取得してレイヤーのパスとする
        shapeLayer.path = checkmarkPath.cgPath

        // アニメーションをLayerに設定
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fillMode = .backwards
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = checkmarkDrawingTime
        animation.timingFunction
            = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        animation.beginTime = CACurrentMediaTime() + circleDrawingTime
        shapeLayer.add(animation, forKey: nil)

        return  shapeLayer
    }
}
