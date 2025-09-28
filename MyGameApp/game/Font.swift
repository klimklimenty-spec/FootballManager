
import SwiftUI

extension Font {
    enum Fonts: String {
        case semiBold = "Poppins-SemiBold"
        case regular = "Poppins-Regular"
        case bold = "Poppins-Bold"
    }
    
    static func poppins(size: CGFloat, weight: Fonts = .regular) -> Font {
        .custom(weight.rawValue, size: size)
    }
}
