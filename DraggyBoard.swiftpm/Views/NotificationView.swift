import SwiftUI

struct NotificationView: View {
    
    let notificationText: String
    @Binding var showNotification: Bool

    var body: some View {
        if showNotification {
            notification
        }
    }
    
    private var notification: some View {
        VStack {
            HStack {
                Image(systemName: "lightbulb.circle")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .foregroundColor(.blue)
                    .padding()
                Text(notificationText)
                    .font(.title3)
                    .bold()
                    .padding()
                    .foregroundColor(Color(.label))
            }
            .background(Color(.systemBackground))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color(.label), lineWidth: 2)
            )
            .cornerRadius(20)
            .clipped()
            Spacer()
        }
        .padding(.top, 20)
        .frame(width: 800)
        .onTapGesture {
            withAnimation(.linear(duration: 0.8)) {
                showNotification = false
            }
        }
        .transition(.move(edge: .top))
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView(notificationText: "Test notification", showNotification: .constant(true))
    }
}
