//
// Created by Artur Dąbkowski on 09/12/2021.
//

import Foundation

struct ReleasesDto: Decodable {
    struct Release: Decodable {
        struct Stats: Decodable {
            struct Community: Decodable {
                let in_wantlist: Int
                let in_collection: Int
            }

            let community: Community
        }

        let id: Int
        let status: String?
        let type: String
        let format: String?
        let label: String?
        let title: String
        let resource_url: String
        let role: String
        let artist: String
        let year: Int
        let thumb: String
        let stats: Stats
    }

    struct Pagination: Decodable {
        struct Urls: Decodable {
            let last: String
            let next: String
        }

        let page: Int
        let pages: Int
        let per_page: Int
        let items: Int
        let urls: Urls
    }

    let pagination: Pagination
    let releases: [Release]
}
