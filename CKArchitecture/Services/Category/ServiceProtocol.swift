//
//  ServiceProtocol.swift
//  CKArchitecture
//
//  Created by Krzysztof Banaczyk on 10/08/2023.
//

import Foundation

// to ensure the `endpoint` attribute is present in all `Services`
protocol Service {
    var endpoint: String { get }
}
