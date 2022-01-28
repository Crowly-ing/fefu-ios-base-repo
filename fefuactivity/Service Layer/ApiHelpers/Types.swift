import Foundation

struct RegisterBody: Encodable {
    let login: String
    let password: String
    let name: String
    let gender: Int
}

struct LoginBody: Encodable {
    let login: String
    let password: String
}

struct ErrorAPI: Decodable {
    let errors: Dictionary<String, [String]>
}

struct Gender: Decodable {
    let code: Int
    let name: String
}

struct UserProfileModel: Decodable, Identifiable {
    let id: Int
    let name: String
    let login: String
    let gender: Gender
}

struct AuthorizedUser: Decodable {
    let token: String
    let user: UserProfileModel
}

struct UserModel: Decodable {
    let id: Int
    let name: String
    let login: String
}

struct Geo: Decodable, Encodable {
    let lat: Double
    let lon: Double
}

struct ActivityType: Decodable, Identifiable {
    let id: Int
    let name: String
}

struct SocialActivity: Decodable {
    let id: Int
    let created_at: String
    let starts_at: String
    let ends_at: String
    let activity_type: ActivityType
    let geo_track: [Geo]
    let user: UserModel
}

struct PaginationModel: Decodable {
    let total: Int
    let count: Int
    let per_page: Int
    let current_page: Int
    let total_pages: Int
}

struct SocialActivitiesModel: Decodable {
    let items: [SocialActivity]
    let pagination: PaginationModel
}
