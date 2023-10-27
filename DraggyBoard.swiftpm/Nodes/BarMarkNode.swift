//
//  BarMarkNode.swift
//
//
//  Created by Daniel on 2023-10-27.
//

import Foundation

class BarMarkNode: Node {
    let label: String
    let value: Int

     init() {
        self.label = Self.randomLabel()
        self.value = Int.random(in: 20...100)
         super.init(nodeType: .barMark, subNodes: nil)
     }

     override func asCode(indentLevel: Int = 0) -> String {
         "\(indentation(indentLevel))BarMark()\")"
     }

    private static func randomLabel() -> String {
        ["Cats", "Dogs", "Birds", "Bears", "Moose", "Eagles", "Foxes", "Apes", "Elk", "Lions", "Horses", "Tigers", "Goats", "Frogs", "Wolves", "Ants", "Lynx", "Owls", "Sharks", "Bees", "Mice", "Hawks", "Cows", "Pigs", "Deer", "Ducks", "Seals", "Fish"].randomElement()!
    }
 }
