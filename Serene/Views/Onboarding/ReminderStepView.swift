import SwiftUI

// Step 5/6: Hora del ritual diario
struct ReminderStepView: View {
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: Spacing.xl) {
            Spacer()

            // Icon
            ZStack {
                Circle()
                    .fill(SereneColors.arenaSoft(colorScheme))
                    .frame(width: 72, height: 72)
                Image(systemName: "bell.badge")
                    .font(.system(size: 30))
                    .foregroundColor(SereneColors.arena(colorScheme))
            }

            VStack(spacing: Spacing.sm) {
                Text("Tu ritual diario")
                    .sereneDisplay(24)
                    .foregroundColor(SereneColors.textPrimary(colorScheme))

                Text("¿A qué hora quieres que te recuerde? Los hábitos funcionan mejor con un momento fijo.")
                    .sereneBody()
                    .foregroundColor(SereneColors.textSecondary(colorScheme))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.md)
            }

            // Time picker
            DatePicker(
                "Hora del recordatorio",
                selection: $viewModel.selectedReminderTime,
                displayedComponents: .hourAndMinute
            )
            .datePickerStyle(.wheel)
            .labelsHidden()
            .padding(.horizontal, Spacing.xl)

            // Suggested times
            VStack(spacing: Spacing.sm) {
                Text("Momentos populares")
                    .sereneMicro()
                    .foregroundColor(SereneColors.textTertiary(colorScheme))

                HStack(spacing: Spacing.md) {
                    quickTimeButton("Mañana", hour: 8, minute: 0)
                    quickTimeButton("Mediodía", hour: 13, minute: 0)
                    quickTimeButton("Noche", hour: 21, minute: 0)
                }
            }

            Spacer()

            Button {
                Task {
                    await viewModel.requestNotifications()
                    viewModel.nextStep()
                }
            } label: {
                Text("Activar recordatorio")
                    .sereneBody(14)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(
                        RoundedRectangle(cornerRadius: Radius.lg)
                            .fill(SereneColors.sage(colorScheme))
                    )
            }
            .padding(.horizontal, Spacing.lg)

            Button {
                viewModel.nextStep()
            } label: {
                Text("Ahora no")
                    .sereneBody(14)
                    .foregroundColor(SereneColors.textTertiary(colorScheme))
            }
            .padding(.bottom, Spacing.lg)
        }
    }

    private func quickTimeButton(_ label: String, hour: Int, minute: Int) -> some View {
        Button {
            if let date = Calendar.current.date(from: DateComponents(hour: hour, minute: minute)) {
                viewModel.selectedReminderTime = date
            }
        } label: {
            VStack(spacing: 2) {
                Text(label)
                    .sereneMicro()
                    .foregroundColor(SereneColors.textSecondary(colorScheme))
                Text(String(format: "%d:%02d", hour, minute))
                    .sereneLabel()
                    .foregroundColor(SereneColors.textPrimary(colorScheme))
            }
            .padding(.horizontal, Spacing.md)
            .padding(.vertical, Spacing.sm)
            .background(
                RoundedRectangle(cornerRadius: Radius.sm)
                    .fill(SereneColors.surface(colorScheme))
            )
        }
    }
}

#Preview {
    ReminderStepView(viewModel: OnboardingViewModel())
}
