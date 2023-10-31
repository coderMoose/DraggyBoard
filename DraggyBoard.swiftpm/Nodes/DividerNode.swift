//
//  DividerNode.swift
//
//
//  Created by Daniel on 2023-10-30.
//

import Foundation

class DividerNode: Node {

    init() {
        super.init(nodeType: .divider, subNodes: nil)
    }

    override func asCode(indentLevel: Int = 0) -> String {
        "\(indentation(indentLevel))Divider()\")"
    }
}
