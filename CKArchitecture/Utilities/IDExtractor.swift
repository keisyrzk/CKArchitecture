//
//  IDExtractor.swift
//  CKArchitecture
//
//  Created by Krzysztof Banaczyk on 14/08/2023.
//

import Foundation

extension String {
    
    var uriId: String? {
        if let lastPathComponent = self.split(separator: "/").last {
            return String(lastPathComponent)
        }
        else {
            print("Unable to extract number")
            return nil
        }
    }
}
