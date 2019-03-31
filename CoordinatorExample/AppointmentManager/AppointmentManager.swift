//
//  AppointmentManager.swift
//  CoordinatorExample
//
//  Created by Maria Holubieva on 3/31/19.
//  Copyright © 2019 Maria Holubieva. All rights reserved.
//

import Foundation

enum SubcategoryType: String {
    case strength = "Strength"
    case crossfit = "Crossfit"
    case stretching = "Stretching"
    case yoga = "Yoga"
    case dancing = "Dancing"

    func getTrainers() -> [String] {
        switch self {
        case .strength:
            return [ "Alex", "Jane" ]
        case .crossfit:
            return [ "Peter", "Joseph", "Alice" ]
        case .stretching:
            return [ "John" ]
        case .yoga:
            return [ "Alexandr" ]
        case .dancing:
            return [ "Kate" ]
        }
    }
}

enum ActivityType: String {
    case gym = "Gym activity"
    case group = "Group activity"
    case any = "Any"

    func getSubcategories() -> [SubcategoryType] {
        switch self {
        case .gym:
            return [.strength, .crossfit]
        case .group:
            return [.yoga, .stretching, .dancing]
        case .any:
            return [.strength, .crossfit, .stretching, .yoga, .dancing]
        }
    }

    static func all() -> [ActivityType] {
        return [ .gym, .group, .any ]
    }
}

struct Appointment {
    let activityType: ActivityType
    let subcategory: SubcategoryType
    let trainerName: String
    let date: Date
}

class AppointmentManager {

    private(set) var appointmentsList = [Appointment]()

    func save(_ appointment: Appointment) {
        appointmentsList.append(appointment)
    }
}
