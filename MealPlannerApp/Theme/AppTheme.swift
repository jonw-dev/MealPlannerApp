import SwiftUI

enum AppTheme {
    // Custom colors
    static let primary = Color("PrimaryColor")
    static let secondary = Color("SecondaryColor")
    static let accent = Color("AccentColor")
    static let background = Color("BackgroundColor")
    static let cardBackground = Color("CardBackground")
    
    // Text styles
    static let titleStyle: Font = .system(.title, design: .rounded, weight: .bold)
    static let headlineStyle: Font = .system(.headline, design: .rounded, weight: .semibold)
    static let bodyStyle: Font = .system(.body, design: .rounded)
    static let captionStyle: Font = .system(.caption, design: .rounded)
    
    // Common view modifiers
    struct CardStyle: ViewModifier {
        func body(content: Content) -> some View {
            content
                .padding()
                .background(AppTheme.cardBackground)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
    }
    
    struct PrimaryButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(AppTheme.primary)
                .foregroundColor(.white)
                .cornerRadius(10)
                .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
        }
    }
    
    struct SecondaryButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(AppTheme.secondary.opacity(0.1))
                .foregroundColor(AppTheme.secondary)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(AppTheme.secondary, lineWidth: 1)
                )
                .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
        }
    }
}

// View extensions for easy access to modifiers
extension View {
    func cardStyle() -> some View {
        modifier(AppTheme.CardStyle())
    }
} 