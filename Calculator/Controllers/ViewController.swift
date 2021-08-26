//
//  ViewController.swift
//  Calculator
//
//  Created by Ewen on 2021/8/24.
//

import UIKit

class ViewController: UIViewController {
    
    var logic = LogicManager()
    var willClearDisplay = false
    var previousIsNumber = true
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createGradientBackground()
    }
    
    func createGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor(red: 227/255, green: 253/255, blue: 245/255, alpha: 1).cgColor,
            UIColor(red: 255/255, green: 230/255, blue: 250/255, alpha: 1).cgColor,
        ]
        gradientLayer.startPoint = CGPoint(x: 0.3, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.7, y: 1)
        gradientLayer.locations = [0, 0.8]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func labelFlash() {
        label.alpha = 0
        UIView.animate(withDuration: 0.05, delay: 0, options: .curveEaseOut, animations: {
            self.label.alpha = 1
        }, completion: nil)
    }
    
    func reset(){
        willClearDisplay = false
        previousIsNumber = true
        logic.clear()
        label.text = "0"
//        print(logic.array, "現在數字：",logic.currentNumber)
    }
    
    // MARK: - 點擊重設
    @IBAction func clearClicked(_ sender: UIButton) {
        UIView.performWithoutAnimation {
            self.resetButton.setTitle("AC", for: .normal)
            self.resetButton.layoutIfNeeded()
        }
        labelFlash()
        reset()
    }
    
    // MARK: - 點擊數字
    @IBAction func numberButtonClicked(_ sender: UIButton) {
        UIView.performWithoutAnimation {
            self.resetButton.setTitle("C", for: .normal)
            self.resetButton.layoutIfNeeded()
        }
        
        if logic.array.count == 1 || label.text! == "Err" {
            reset()
            return
        }
       
        // 先按加減乘除再按數字要先清畫面
        if willClearDisplay == true {
            label.text = ""
            willClearDisplay = false
        }
        
        // 顯示
        if label.text == "0" { label.text = sender.currentTitle }
        else { label.text! += sender.currentTitle! }
        
        // 顯示的數字放到currentNumber
        logic.currentNumber = Double(label.text!)!
        
        previousIsNumber = true
//        print(logic.array, "現在數字：",logic.currentNumber)
    }
    
    // MARK: - 點擊 + - × ÷
    @IBAction func operatorButtonClicked(_ sender: UIButton) {
        labelFlash()
        
        if label.text! == "Err" {
            reset()
            return
        }
        
        logic.currentTag = Double(sender.tag)
        
        if previousIsNumber == true {
            logic.array.append(logic.currentNumber)
            // array.count為 1 則放進 tag。例如：10 ÷
            if logic.array.count == 1 {
                logic.array.append(Double(sender.tag))
            }
            // array.count為 3 才會回傳數字，例如：10 ÷ 2 +
            if let result = logic.calculateArray(operation: "operator") {
                label.text = logic.formatToString(from: result)
            }
        } else {
            // 例如：10 ÷ +
            if logic.array.count == 2 { logic.array[1] = Double(sender.tag) }
            // 例如：10 ÷ 2 = +
            else if logic.array.count == 1 { logic.array.append(Double(sender.tag)) }
        }
        
        willClearDisplay = true
        previousIsNumber = false
//        print(logic.array, "現在數字：",logic.currentNumber)
    }
    
    // MARK: - 點擊 =
    @IBAction func equalButtonClicked(_ sender: UIButton) {
        labelFlash()
        
        if label.text! == "Err" {
            reset()
            return
        }
        
        // array.count為 1 或 2 會執行。例如：10 ÷ 2 = 或 10 ÷ 2 = =
        if let result = logic.calculateArray(operation: "equal") {
            label.text = logic.formatToString(from: result)
        }
        
        previousIsNumber = false
//        print(logic.array, "現在數字：",logic.currentNumber)
    }
    
    // MARK: - 點擊小數點
    @IBAction func decimalClicked(_ sender: UIButton) {
        if logic.array.count == 1 || label.text! == "Err" {
            reset()
            label.text! += "."
//            print(logic.array, "現在數字：",logic.currentNumber)
            return
        }
        
        // 顯示字串沒有包含 . 再串上 .
        if !(label.text?.contains("."))! { label.text! += "." }
        
        previousIsNumber = true
//        print(logic.array, "現在數字：",logic.currentNumber)
    }
    
    // MARK: - 點擊 +/-
    @IBAction func plusMinusClicked(_ sender: UIButton) {
        labelFlash()
        
        if label.text == "0" || label.text! == "Err" {
            reset()
            return
        }
        
        if logic.array.count == 2 {
            // 2 + 3 (+/-) 或是 2 + (+/-) 3
            if previousIsNumber == true {
                logic.currentNumber *= -1
                label.text = logic.formatToString(from: logic.currentNumber)
            } else {
                logic.array[0] *= -1
                label.text = logic.formatToString(from: logic.array[0])
            }
        } else if logic.array.count == 1 {
            logic.array[0] *= -1
            label.text = logic.formatToString(from: logic.array[0])
        } else {
            logic.currentNumber *= -1
            label.text = logic.formatToString(from: logic.currentNumber)
        }
        
        previousIsNumber = true
//        print(logic.array, "現在數字：",logic.currentNumber)
    }
    
    // MARK: - 點擊 delete
    @IBAction func backwardClicked(_ sender:  UIButton) {
        labelFlash()
        
        if label.text!.dropLast() == "-" || label.text!.count == 1 || label.text! == "Err" {
            reset()
            return
        }
        
        if logic.array.count == 2 || logic.array.count == 0 {
            logic.currentNumber = Double(label.text!.dropLast())!
            label.text = String(label.text!.dropLast())
        } else if logic.array.count == 1 {
            logic.array[0] = Double(label.text!.dropLast())!
            label.text = String(label.text!.dropLast())
        }
       
        previousIsNumber = true
//        print(logic.array, "現在數字：",logic.currentNumber)
    }
}
