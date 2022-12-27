//
//  DateFormatStyle.swift
//  Countdown Watch App
//
//  Created by Yunxi Jiang on 27/12/2022.
//

import Foundation

/// `ProductivityChart` uses this type to format the dates on the x-axis.
struct DateFormatStyle: FormatStyle {
    enum CodingKeys: CodingKey {
        case dateFormatTemplate
    }
    
    private var dateFormatTemplate: String
    private var formatter: DateFormatter
    
    init(dateFormatTemplate: String) {
        self.dateFormatTemplate = dateFormatTemplate
        formatter = DateFormatter()
        formatter.locale = Locale.autoupdatingCurrent
        formatter.setLocalizedDateFormatFromTemplate(dateFormatTemplate)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        dateFormatTemplate = try container.decode(String.self, forKey: .dateFormatTemplate)
        formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate(dateFormatTemplate)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(dateFormatTemplate, forKey: .dateFormatTemplate)
    }
    
    func format(_ value: Date) -> String {
        formatter.string(from: value)
    }
}
