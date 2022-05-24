//
//  Data+prettyJson.swift
//  MedikationsPlanXML
//
//  Created by Alonso Essenwanger on 21.11.21.
//

import Foundation

extension Data {
    /// Allows us to get a well structured JSON String
    var prettyJson: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.sortedKeys, .prettyPrinted, .withoutEscapingSlashes]),
              let prettyPrintedString = String(data: data, encoding:.utf8) else { return nil }
        
        return prettyPrintedString
    }
}
