//
//  ViewController.swift
//  CheckmarkAnimation
//
//  Created by Naoyuki Otani on 2020/12/08.
//

import UIKit
import AudioToolbox

class ViewController: UIViewController {

    /// チェックマークを描画するビュー
    @IBOutlet weak var checkmarkView: CheckmarkView!

    
    /// チェックボタンイベント
    @IBAction func checkButtonAction() {
        
        // アニメーションを開始する
        checkmarkView.startAnimation()
                
    }

    
}
