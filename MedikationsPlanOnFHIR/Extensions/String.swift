//
//  String.swift
//  MedikationsPlanXML
//
//  Created by Alonso Essenwanger on 19.12.21.
//

import Foundation

extension String {
    /// Removes white spaces on Strings
    var noWhiteSpaces: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// Adds the hyphen symbold to the corresponding positon of a UUID string
    var toUUID: String {
        return "\(self.subString(from: 0, to: 8))-\(self.subString(from: 8, to: 12))-\(self.subString(from: 12, to: 16))-\(self.subString(from: 16, to: 20))-\(self.subString(from: 20, to: 32))"
    }
    
    /// Returns a sub string of the given string
    func subString(from: Int, to: Int) -> String {
       let startIndex = self.index(self.startIndex, offsetBy: from)
       let endIndex = self.index(self.startIndex, offsetBy: to)
       return String(self[startIndex..<endIndex])
    }
}
