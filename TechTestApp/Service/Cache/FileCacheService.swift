//
// Created by Artur Dąbkowski on 09/12/2021.
//

import Foundation

final class FileCacheService: CacheService {
    private let fileManager: FileManager

    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }

    func saveData(name: String, data: Data) throws {
        guard let url = makeURL(forFileNamed: name) else {
            throw "Invalid Path"
        }

        do {
            try data.write(to: url)
        } catch {
            debugPrint(error)
            throw "Write to cache error"
        }
    }

    func readData(name: String) throws -> Data {
        guard let url = makeURL(forFileNamed: name) else {
            throw "Invalid Path"
        }
        do {
            return try Data(contentsOf: url)
        } catch {
            debugPrint(error)
            throw "Read cache error"
        }
    }

    private func makeURL(forFileNamed fileName: String) -> URL? {
        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return url.appendingPathComponent(fileName)
    }
}
