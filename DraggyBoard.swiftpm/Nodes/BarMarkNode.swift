//
//  BarMarkNode.swift
//
//
//  Created by Daniel on 2023-10-27.
//

import Foundation

class BarMarkNode: Node {

    init() {
        super.init(nodeType: .barMark, subNodes: nil)
    }

    override func asCode(indentLevel: Int = 0) -> String {
        "\(indentation(indentLevel))BarMark()\")"
    }
}
