//
//  HNTagView.swift
//  HNTagView
//
//  Created by ThanhHai on 11/14/18.
//  Copyright © 2018 ThanhHai. All rights reserved.
//

import Foundation
import UIKit

struct Padding {
    var top: CGFloat!
    var left: CGFloat!
    var bottom: CGFloat!
    var right: CGFloat!
}

protocol HNTagViewDelegate: class {
    func tagViewDidSeletedTag(index: Int)
}

class HNTagView: UIView {
    
    weak var delegate : HNTagViewDelegate?
    
    //MARK: - PROPERTIES
    open var tags: [String] = Array<String>()
    private var vwTag: [UIView] = Array<UIView>()
    open var showCloseButton: Bool = true
    open var tagFont: UIFont = UIFont.systemFont(ofSize: 14)
    
    private var tagColor: UIColor = .lightGray
    private var selectedColor: UIColor = .lightGray
    
    private var currentSeleted: [Int] = []
    
    open var multiSelect: Bool = true
    
    open var cornerRadius: CGFloat = 16
    open var borderWidth: CGFloat = 1
    open var borderColor: UIColor = .black
    open var heightTag: CGFloat = 30
    open var lineSpacing: CGFloat = 8
    open var itemSpacing: CGFloat = 8
    open var padding: Padding = Padding(top: 0, left: 0, bottom: 0, right: 0)
    private var tagPadding: CGFloat = 4
    private var viewContainer = UIView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Render list TAG into view
    func renderTags() {
        if tags.count == 0 { return }
        
        let safeWidth = self.frame.width - padding.left - padding.right
        
        var xPos: CGFloat = padding.left
        var yPos: CGFloat = padding.top
        for i in 0..<tags.count {
            let width = NSString(string: tags[i]).size(withAttributes: [NSAttributedString.Key.font: tagFont]).width
            print(width)
            let widthOfButton: CGFloat = showCloseButton ? 24 : 0
            
            let bg = UIView()
            bg.tag = i
            
            let gs = UITapGestureRecognizer(target: self, action: #selector(touchTags(_:)))
            bg.addGestureRecognizer(gs)
            
            
            if (xPos + width + 8 + widthOfButton + itemSpacing) > self.frame.width - padding.right {
                yPos += heightTag + lineSpacing
                if yPos + heightTag > self.frame.height {
                    return
                }
                xPos = padding.left
            }
            
            var tempWidth = width + 8 + widthOfButton + 2 * tagPadding
            if tempWidth > safeWidth {
                tempWidth = safeWidth
            }
            
            bg.frame = CGRect(x: xPos, y: yPos, width: tempWidth, height: self.heightTag)
            bg.layer.cornerRadius = self.cornerRadius
            bg.backgroundColor = tagColor
            bg.layer.borderWidth = borderWidth
            bg.layer.borderColor = borderColor.cgColor
            xPos += bg.frame.size.width + itemSpacing
            
            let lblTagName = UILabel()
            lblTagName.font = tagFont
            lblTagName.text = tags[i]
            lblTagName.frame = CGRect(x: tagPadding, y: 0, width: bg.frame.width - widthOfButton - 2 * tagPadding, height: bg.frame.height)
            lblTagName.textAlignment = .center
            bg.addSubview(lblTagName)
            
            if showCloseButton {
                let btnClose = UIButton()
                btnClose.frame = CGRect(x: bg.frame.width - 4 - widthOfButton, y: 3, width: widthOfButton, height: widthOfButton)
                btnClose.contentEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
                btnClose.layer.cornerRadius = widthOfButton / 2
                btnClose.setImage(UIImage(named: "close"), for: .normal)
                bg.addSubview(btnClose)
            }
            vwTag.append(bg)
            self.addSubview(bg)
        }
    }
    
    //Set color to TAG
    func setTagColor(_ normalColor: UIColor, selectedColor: UIColor?) {
        tagColor = normalColor
        if let selected = selectedColor {
            self.selectedColor = selected
        } else {
            self.selectedColor = normalColor
        }
    }
    
    //Get list index tag
    func getCurrentTagID() -> [Int] {
        return currentSeleted
    }
    
    @objc private func touchTags(_ sender: UIGestureRecognizer) {
        
        if multiSelect {
            if let id = sender.view?.tag {
                if !currentSeleted.contains(id) {
                    currentSeleted.append(id)
                }
            }
        } else {
            if let id = sender.view?.tag {
                for vw in vwTag {
                    if currentSeleted.contains(vw.tag) {
                        vw.backgroundColor = tagColor
                    }
                }
                currentSeleted = [id]
            }
        }
        sender.view?.backgroundColor = selectedColor
        guard let delegate = delegate else {
            return
        }
        delegate.tagViewDidSeletedTag(index: sender.view?.tag ?? -1)
    }
    
}
