import SwiftUI

struct ConfirmationDialogView: View {
    let title: String
    let message: String
    let confirmTitle: String
    let confirmRole: ButtonRole?
    let onConfirm: () -> Void
    let onCancel: () -> Void

    var body: some View {
        EmptyView()
            .alert(title, isPresented: .constant(true)) {
                Button("取消", role: .cancel) { onCancel() }
                Button(confirmTitle, role: confirmRole) { onConfirm() }
            } message: {
                Text(message)
            }
    }
}

struct ConfirmationModifier: ViewModifier {
    @Binding var isPresented: Bool
    let title: String
    let message: String
    let confirmTitle: String
    let confirmRole: ButtonRole?
    let onConfirm: () -> Void

    func body(content: Content) -> some View {
        content
            .alert(title, isPresented: $isPresented) {
                Button("取消", role: .cancel) {}
                Button(confirmTitle, role: confirmRole) { onConfirm() }
            } message: {
                Text(message)
            }
    }
}

extension View {
    func confirmationAlert(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        confirmTitle: String = "确认",
        confirmRole: ButtonRole? = nil,
        onConfirm: @escaping () -> Void
    ) -> some View {
        modifier(ConfirmationModifier(
            isPresented: isPresented,
            title: title,
            message: message,
            confirmTitle: confirmTitle,
            confirmRole: confirmRole,
            onConfirm: onConfirm
        ))
    }
}
