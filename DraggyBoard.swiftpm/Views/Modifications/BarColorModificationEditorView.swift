//
//  BarColorModificationEditorView.swift
//
//
//  Created by Daniel on 2023-10-27.
//

import SwiftUI

struct BarColorModificationEditorView: View {
    @ObservedObject var barColorModification: BarColorModification
    let redrawEverything: () -> Void

    var body: some View {
        barColorPicker
    }

    private var barColorPicker: some View {
        Picker(selection: $barColorModification.barColor.animation()) {
            ForEach(TextColor.allCases, id: \.rawValue) { textColor in
                Text(textColor.rawValue)
                    .tag(textColor)
            }
        } label: {
            Text("Bar Color")
        }
        .pickerStyle(MenuPickerStyle())
        .onChange(of: barColorModification.barColor) { newValue in
            redrawEverything()
        }
    }
}

#Preview {
    BarColorModificationEditorView(barColorModification: BarColorModification(), redrawEverything: {})
}
