import Foundation

/// Står for navigation for Vagtplan.
enum DutyScheduleRoute: Hashable, Equatable {
    case createShift
    case editShift(Shift)
}
