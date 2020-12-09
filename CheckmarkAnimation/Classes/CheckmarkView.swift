//
//  CheckmarkView.swift
//  CheckmarkAnimation
//
//  Created by Naoyuki Otani on 2020/12/09.
//  Copyright © 2020 BV Factory. All rights reserved.
//

import UIKit

/// チェックマークがアニメーションするView
class CheckmarkView: UIView {

    // 線の幅
    private let lineWidth = CGFloat(25)
    // 線の色
    private let lineStrokeColor = UIColor.green.cgColor
    // 円を描くアニメーション時間
    private let circleDrawingTime = CFTimeInterval(0.8)
    // チェックマークを描くアニメーション時間
    private let checkmarkDrawingTime = CFTimeInterval(0.4)

    // チェックマークの開始点
    private var checkmarkStartPoints: CGPoint {
        // 下の定数座標は240x240のサイズの場合のため実際のサイズに調整する
        return CGPoint(x: 42.2784 * bounds.width / 240.0, y: 118.7159 * bounds.height / 240.0)
    }
    // チェックマークの線の移動先座標群
    private var checkmarkMovePoints: [CGPoint] {
        // 下の定数座標は240x240のサイズの場合のため実際のサイズに調整する
        let ratioX = bounds.width / 240.0
        let ratioY = bounds.height / 240.0
        return [
           CGPoint(x: 51.9758 * ratioX, y: 129.4688 * ratioY),
           CGPoint(x: 61.6744 * ratioX, y: 140.2230 * ratioY),
           CGPoint(x: 71.3770 * ratioX, y: 150.9817 * ratioY),
           CGPoint(x: 81.0807 * ratioX, y: 161.7416 * ratioY),
           CGPoint(x: 90.7791 * ratioX, y: 172.4956 * ratioY),
           CGPoint(x: 98.5625 * ratioX, y: 162.2959 * ratioY),
           CGPoint(x: 106.8509 * ratioX, y: 152.5011 * ratioY),
           CGPoint(x: 115.5835 * ratioX, y: 143.0999 * ratioY),
           CGPoint(x: 124.7762 * ratioX, y: 134.1420 * ratioY),
           CGPoint(x: 134.4632 * ratioX, y: 125.7198 * ratioY),
           CGPoint(x: 147.8296 * ratioX, y: 115.5880 * ratioY),
           CGPoint(x: 161.8935 * ratioX, y: 106.4529 * ratioY),
           CGPoint(x: 176.6142 * ratioX, y: 98.4059 * ratioY),
           CGPoint(x: 191.9338 * ratioX, y: 91.5967 * ratioY)
       ]
    }
    
    // 直前のアニメーションレイヤー
    private var animationLayers = [CALayer]()

    
    // MARK: - Public functions
    
    /// アニメーションを開始する
    func startAnimation() {
        // 前回描画したレイヤーがあれば消しておく
        animationLayers.forEach {
            $0.removeFromSuperlayer()
        }
        animationLayers.removeAll()

        // 円を描くレイヤーを作成
        let circleLayer = createDrawCircleLayer(to: bounds)
        // チェックマークを描くレイヤーを作成
        let checkmarkLayer = createDrawCheckmarkLineLayer(to: bounds)

        // アニメーションレイヤーを描画対象のViewのレイヤーに設定
        layer.addSublayer(circleLayer)
        layer.addSublayer(checkmarkLayer)

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
        let endAngle = startAngle + (2 * pi)    // 開始角度に2π(360度)足して一周した位置

        // 円を描くレイヤーを作成
        let circleLayer = CAShapeLayer()
        // 描画領域の設定
        circleLayer.frame = rect
        // レイヤーの背景色
        circleLayer.backgroundColor = UIColor.clear.cgColor
        // 線の色
        circleLayer.strokeColor = lineStrokeColor
        // 線で囲まれた内部の塗り潰し色
        circleLayer.fillColor = UIColor.clear.cgColor
        // 線の太さ
        circleLayer.lineWidth = lineWidth
        // 線の終端を角丸とする
        circleLayer.lineCap = .round

        // ベジェパスを作成
        let circlePath = UIBezierPath(arcCenter: centerPoint,
                                      radius: radius,
                                      startAngle: startAngle,
                                      endAngle: endAngle,
                                      clockwise: true)  // trueで時計回り
        // ベジェパスからCGPathを取得してレイヤーのパスとする
        circleLayer.path = circlePath.cgPath

        // アニメーションをLayerに設定
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = circleDrawingTime
        animation.timingFunction
            = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        circleLayer.add(animation, forKey: nil)

        return  circleLayer
    }

    /// チェックマークを描くアニメーションレイヤーの生成
    /// - Parameter rect: チェックマークを描く領域のCGRect
    /// - Returns: チェックマークを描くアニメーションレイヤー
    private func createDrawCheckmarkLineLayer(to rect: CGRect) -> CAShapeLayer {

        // 線を描くレイヤーを作成
        let checkmarkLayer = CAShapeLayer()
        // 描画領域の設定
        checkmarkLayer.frame = rect
        // レイヤーの背景色
        checkmarkLayer.backgroundColor = UIColor.clear.cgColor
        // 線の色
        checkmarkLayer.strokeColor = lineStrokeColor
        // 線で囲まれた内部の塗り潰し色
        checkmarkLayer.fillColor = UIColor.clear.cgColor
        // 線の太さ
        checkmarkLayer.lineWidth = lineWidth
        // 線の終端を四角とする
        checkmarkLayer.lineCap = .square

        // ベジェパスを作成
        let checkmarkPath = UIBezierPath()
        // 開始点に移動
        checkmarkPath.move(to: checkmarkStartPoints)
        // 移動先にパスを引いていく
        checkmarkMovePoints.forEach {
            checkmarkPath.addLine(to: $0)
        }
        // ベジェパスからCGPathを取得してレイヤーのパスとする
        checkmarkLayer.path = checkmarkPath.cgPath

        // アニメーションをLayerに設定
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fillMode = .backwards     // アニメーション開始まで始点に戻しておく
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = checkmarkDrawingTime
        animation.timingFunction
            = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        animation.beginTime = CACurrentMediaTime() + circleDrawingTime  // 円が描画完了するまで兄メーションを遅延させる
        checkmarkLayer.add(animation, forKey: nil)

        return  checkmarkLayer
    }
}
