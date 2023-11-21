//
//  String+EXT.swift
//  GourmetGuide
//
//  Created by Min Kim on 11/15/23.
//

import UIKit

extension String{
    /// Converts our api call HTML into usable NSAttributedString
    func convertToHtml() -> NSAttributedString {

        guard let data = data(using: .utf8) else { return NSAttributedString() }

        do {
            let htmlAttrib = NSAttributedString.DocumentType.html
            return try NSAttributedString(data: data,
                                          options: [.documentType : htmlAttrib],
                                          documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
}
