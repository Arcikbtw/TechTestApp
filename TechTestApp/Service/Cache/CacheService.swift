//
// Created by Artur Dąbkowski on 09/12/2021.
//

import Foundation

protocol CacheService: AnyObject {
    func saveData(name: String, data: Data) throws
    func readData(name: String) throws -> Data
}
