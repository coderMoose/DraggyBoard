import SwiftUI

extension ColorScheme {
    var codeColors: CodeColors {
        self == .light ? LightModeCodeColors() : DarkModeCodeColors()
    }
}

protocol CodeColors {
    var typeName: Color { get }
    var propertyName: Color { get }
    var string: Color { get }
    var keywordColor: Color { get }
    var frameworkColor: Color { get }
    var commentColor: Color { get }
}

private struct DarkModeCodeColors: CodeColors {
    let typeName = Color(red: 192.0 / 255.0,
                         green: 169.0 / 255.0,
                         blue: 226.0 / 255.0)

    let propertyName = Color(red: 97.0 / 255.0,
                             green: 161.0 / 255.0,
                             blue: 185.0 / 255.0)

    let string = Color(red: 238.0 / 255.0,
                       green: 136.0 / 255.0,
                       blue: 118.0 / 255.0)

    let keywordColor = Color(red: 238.0 / 255.0,
                             green: 129.0 / 255.0,
                             blue: 177.0 / 255.0)
    
    let frameworkColor = Color(red: 218.0 / 255.0,
                               green: 218.0 / 255.0,
                               blue: 218.0 / 255.0)
    let commentColor = Color(red: 130.0 / 255.0,
                             green: 139.0 / 255.0,
                             blue: 151.0 / 255.0)
}

private struct LightModeCodeColors: CodeColors {
    let typeName = Color(red: 97.0 / 255.0,
                         green: 69.0 / 255.0,
                         blue: 183.0 / 255.0)
    
    let propertyName = Color(red: 54.0 / 255.0,
                             green: 122.0 / 255.0,
                             blue: 171.0 / 255.0)

    let string = Color(red: 194.0 / 255.0,
                       green: 70.0 / 255.0,
                       blue: 50.0 / 255.0)

    let keywordColor = Color(red: 160.0 / 255.0,
                             green: 59.0 / 255.0,
                             blue: 159.0 / 255.0)
    
    let frameworkColor = Color(red: 39.0 / 255.0,
                               green: 39.0 / 255.0,
                               blue: 39.0 / 255.0)
    let commentColor = Color(red: 115.0 / 255.0,
                             green: 126.0 / 255.0,
                             blue: 139.0 / 255.0)
}
