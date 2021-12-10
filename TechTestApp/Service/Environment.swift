//
// Created by Artur Dąbkowski on 09/12/2021.
//

import Foundation

protocol EnvironmentProtocol: AnyObject {
    var baseUrl: String { get }
    var token: String { get }
    var artistUuid: String { get }
    var artistName: String { get }
}

final class Environment: EnvironmentProtocol {
    let baseUrl: String = "https://api.discogs.com/"
    let token: String = "Discogs token=oNdChVBXGYjxVenMAqmhDuFNYBuBCVGSUloAQQGQ"
    let artistUuid: String = "251595"
    let artistName: String = "Iron Maiden"
}
