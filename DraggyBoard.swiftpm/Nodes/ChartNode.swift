//
//  ChartNode.swift
//
//
//  Created by Daniel on 2023-10-27.
//

import Foundation

class ChartNode: ContainerNode {
    init(subNodes: [BarMarkNode]?) {
        super.init(nodeType: .chart, subNodes: subNodes)
    }
    
    func addBarMark() {
        subNodes?.append(BarMarkNode())
    }
    
    override func asCode(indentLevel: Int = 0) -> String {
        let innerCode = innerCode(indentLevel: indentLevel)
        let result =
"""
\(indentation(indentLevel))Chart {
\(innerCode)
\(indentation(indentLevel))}
"""
        return result
    }
}
