//
//  ViewController.swift
//  swift_utilities
//
//  Created by ThanhHai on 11/18/18.
//  Copyright © 2018 ThanhHai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK: - OUTLET
    
    let tags : [String] = ["Dbc", "Do any additional Do any additional Do any additional", "setup after", "loading", "the view", "typically", "from"]

    
    @IBOutlet weak var vwTag: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    
    private func setupView() {
        let tag = HNTagView()
        tag.delegate = self
        tag.frame = vwTag.frame
        tag.backgroundColor = .brown
        tag.showCloseButton = false
        tag.padding = Padding(top: 10, left: 10, bottom: 0, right: 0)
        tag.setTagColor(.clear, selectedColor: .red)
        tag.multiSelect = false
        self.vwTag.addSubview(tag)
        tag.tags = tags
        tag.renderTags()
    }
}

extension ViewController: HNTagViewDelegate {
    func tagViewDidSeletedTag(index: Int) {
        print(tags[index])
    }
    
}
