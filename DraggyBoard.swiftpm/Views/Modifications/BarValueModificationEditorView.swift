//
//  BarValueModificationEditorView.swift
//
//
//  Created by Daniel on 2023-10-28.
//

import SwiftUI

struct BarValueModificationEditorView: View {

    @ObservedObject var barMarkNode: BarMarkNode
    let redrawEverything: () -> Void

    var body: some View {
        barValuePicker
    }

    private var barValuePicker: some View {
        Slider(value: $barMarkNode.value.animation(),
               in: 20.0...100.0,
               step: 2.0) {
            Text("Value")
        } minimumValueLabel: {
            Text("20")
        } maximumValueLabel: {
            Text("100")
        } onEditingChanged: { didChange in
            redrawEverything()
        }
    }
}

#Preview {
    BarValueModificationEditorView(barMarkNode: BarMarkNode(), redrawEverything: {})
}
