//
//  Data+ext.swift
//  Practice_attestation
//
//  Created by Alexander Vagin on 24.04.2023.
//

import Foundation

extension Date {

    var displayFormatDayMonth: String {
        self.formatted(
            .dateTime
                .month(.twoDigits)
                .day(.twoDigits)
                .locale(Locale(identifier: "ru_RU"))
        )
    }

    var displayFormatDayMonthYear: String {
        self.formatted(
            .dateTime
                .year(.twoDigits)
                .month(.twoDigits)
                .day(.defaultDigits)
                .locale(Locale(identifier: "ru_RU"))
        )
    }

    var displayFormatDayShortDay: String {
        self.formatted(
            .dateTime
                .month(.defaultDigits)
                .day(.twoDigits)
                .locale(Locale(identifier: "ru_RU"))
        )
    }

    var displayFormatMonth: String {
        self.formatted(
            .dateTime
                .month(.defaultDigits)
                //.day(.defaultDigits)
                .locale(Locale(identifier: "ru_RU"))
        )
    }

    var displayFormatActYear: String {
        self.formatted(
            .dateTime
                .year(.defaultDigits)
                .locale(Locale(identifier: "ru_RU"))
        )
    }

    var displayFormatMonthRusLocale: String {
        self.formatted(
            .dateTime
                .month(.wide)
                .locale(Locale(identifier: "ru_RU"))
        )
    }

    func getDaysOfMonth() -> [Date] {

        //get the current Calendar for our calculations
        let cal = Calendar.current
        //get the days in the month as a range, e.g. 1..<32 for March
        let monthRange = cal.range(of: .day, in: .month, for: self)!
        //get first day of the month
        let comps = cal.dateComponents([.year, .month], from: self)
        //start with the first day
        //building a date from just a year and a month gets us day 1
        var date = cal.date(from: comps)!

        //somewhere to store our output
        var dates: [Date] = []
        //loop thru the days of the month
        for _ in monthRange {
            //add to our output array...
            dates.append(date)
            //and increment the day
            date = cal.date(byAdding: .day, value: 1, to: date)!
        }
        return dates
    }

    static func from(year: Int, month: Int, day: Int) -> Date {
        let components = DateComponents(year: year, month: month, day: day)
        return Calendar.current.date(from: components)!
    }

}
