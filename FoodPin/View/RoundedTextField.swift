//
//  RoundedTextField.swift
//  FoodPin
//
//  Created by WeiFangChou on 2021/4/29.
//

import UIKit

class RoundedTextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        //回傳繪製矩刑是針對文字欄位得文字
        
        return bounds.inset(by: padding)
        
    }
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        //回傳繪製矩形是針對文字欄位的可編輯文字
        return bounds.inset(by: padding)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        //回傳的矩形是用於可編輯的文字
        return bounds.inset(by: padding)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
    }

}
