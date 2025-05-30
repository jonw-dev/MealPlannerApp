import SwiftUI
import SwiftData

struct DatePickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedDate: Date
    let scheduledMeals: [ScheduledMeal]
    
    private let calendar: Calendar = {
        var calendar = Calendar.current
        calendar.firstWeekday = 2  // Set Monday as first day
        return calendar
    }()
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    private var weekdaySymbols: [String] {
        // Monday to Sunday, all using two-letter abbreviations
        return ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]
    }
    
    @State private var displayedMonth = Date()
    
    public init(selectedDate: Binding<Date>, scheduledMeals: [ScheduledMeal]) {
        self._selectedDate = selectedDate
        self.scheduledMeals = scheduledMeals
    }
    
    var body: some View {
        VStack {
            // Month navigation
            HStack {
                Button {
                    displayedMonth = calendar.date(byAdding: .month, value: -1, to: displayedMonth) ?? displayedMonth
                } label: {
                    Image(systemName: "chevron.left")
                }
                
                Spacer()
                
                Text(monthYearFormatter.string(from: displayedMonth))
                    .font(.headline)
                
                Spacer()
                
                Button {
                    displayedMonth = calendar.date(byAdding: .month, value: 1, to: displayedMonth) ?? displayedMonth
                } label: {
                    Image(systemName: "chevron.right")
                }
            }
            .padding()
            
            // Weekday headers
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(weekdaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal)
            
            // Calendar grid
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(daysInMonth(), id: \.self) { date in
                    if let date = date {
                        CalendarDayView(
                            date: date,
                            isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                            hasMeal: scheduledMeals.contains { calendar.isDate($0.date, inSameDayAs: date) }
                        )
                        .onTapGesture {
                            selectedDate = date
                            dismiss()
                        }
                    } else {
                        Color.clear
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Select Start Date")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
    }
    
    private var monthYearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    private func daysInMonth() -> [Date?] {
        guard let interval = calendar.dateInterval(of: .month, for: displayedMonth),
              let firstWeekday = calendar.dateComponents([.weekday], from: interval.start).weekday else {
            return []
        }
        
        let offsetDays = (firstWeekday - calendar.firstWeekday + 7) % 7
        let daysInMonth = calendar.range(of: .day, in: .month, for: displayedMonth)?.count ?? 0
        
        var days: [Date?] = Array(repeating: nil, count: offsetDays)
        
        for day in 1...daysInMonth {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: interval.start) {
                days.append(date)
            }
        }
        
        let remainingDays = (7 - (days.count % 7)) % 7
        days.append(contentsOf: Array(repeating: nil, count: remainingDays))
        
        return days
    }
}

struct CalendarDayView: View {
    let date: Date
    let isSelected: Bool
    let hasMeal: Bool
    
    private let calendar = Calendar.current
    
    public init(date: Date, isSelected: Bool, hasMeal: Bool) {
        self.date = date
        self.isSelected = isSelected
        self.hasMeal = hasMeal
    }
    
    var body: some View {
        VStack {
            Text("\(calendar.component(.day, from: date))")
                .font(.callout)
            
            if hasMeal {
                Circle()
                    .fill(.blue)
                    .frame(width: 4, height: 4)
            } else {
                Circle()
                    .fill(.clear)
                    .frame(width: 4, height: 4)
            }
        }
        .frame(height: 40)
        .frame(maxWidth: .infinity)
        .background(isSelected ? Color.blue.opacity(0.2) : Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 1)
        )
    }
} 