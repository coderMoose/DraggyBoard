//
//  BarMarkNode.swift
//
//
//  Created by Daniel on 2023-10-27.
//

import Foundation

class BarMarkNode: Node {
    @Published var label: String
    @Published var value: Double
    
    let barColorModification = BarColorModification()
    
    init() {
        self.label = Self.randomLabel()
        self.value = Double.random(in: 20.0...100.0)
        super.init(nodeType: .barMark, subNodes: nil)
    }

    override func asCode(indentLevel: Int = 0) -> String {
        "\(indentation(indentLevel))BarMark()\")"
    }

    private static func randomLabel() -> String {
        ["Cats", "Dogs", "Birds", "Bears", "Moose", "Eagles", "Foxes", "Apes", "Elk", "Lions", "Horses", "Tigers", "Goats", "Frogs", "Wolves", "Ants", "Lynx", "Owls", "Sharks", "Bees", "Mice", "Hawks", "Cows", "Pigs", "Deer", "Ducks", "Seals", "Fish"].randomElement()!
    }
 }
