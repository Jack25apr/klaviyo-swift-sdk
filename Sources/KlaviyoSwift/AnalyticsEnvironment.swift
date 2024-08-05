//
//  File.swift
//
//
//  Created by Ajay Subramanya on 8/2/24.
//

import AnyCodable
import Combine
import Foundation
import KlaviyoCore
import UIKit

var analytics = AnalyticsEnvironment.production

struct AnalyticsEnvironment {
    var networkSession: () -> NetworkSession
    var apiURL: String
    var encodeJSON: (AnyEncodable) throws -> Data
    var decoder: DataDecoder
    var uuid: () -> UUID
    var date: () -> Date
    var timeZone: () -> String
    var appContextInfo: () -> AppContextInfo
    var klaviyoAPI: KlaviyoAPI
    var timer: (Double) -> AnyPublisher<Date, Never>
    static let production: AnalyticsEnvironment = .init(
        networkSession: createNetworkSession,
        apiURL: KlaviyoEnvironment.productionHost,
        encodeJSON: { encodable in try KlaviyoEnvironment.encoder.encode(encodable) },
        decoder: DataDecoder.production,
        uuid: { UUID() },
        date: { Date() },
        timeZone: { TimeZone.autoupdatingCurrent.identifier },
        appContextInfo: { AppContextInfo() },
        klaviyoAPI: KlaviyoAPI(),
        timer: { interval in
            Timer.publish(every: interval, on: .main, in: .default)
                .autoconnect()
                .eraseToAnyPublisher()
        })
}
