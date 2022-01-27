import Foundation


class AuthService {
    static let decoder = JSONDecoder()
    static let encoder = JSONEncoder()
    
    init() {
        AuthService.decoder.keyDecodingStrategy = .convertFromSnakeCase
        AuthService.encoder.keyEncodingStrategy = .convertToSnakeCase
    }
    
    static func register(_ body: Data,
                         completion: @escaping ((AuthorizedUser) -> Void),
                         onError :@escaping((ErrorAPI) -> Void)) {
        
        guard let url = URL(string: "https://fefu.t.feip.co/api/auth/register") else {
            print("Битая ссылка")
            return
        }
        
        var urlReq = URLRequest(url: url)
        urlReq.httpMethod = "POST"
        urlReq.httpBody = body
        urlReq.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlReq.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlReq) { data, response, error in
            
            guard let data = data else {
                return
            }
            
            if let res = response as? HTTPURLResponse {
                if res.statusCode == 201 {
                    do {
                        let user = try AuthService.decoder.decode(AuthorizedUser.self, from: data)
                        completion(user)
                        return
                    } catch {
                        print(error)
                    }
                }
                
                if res.statusCode == 422 {
                    do {
                        let err = try AuthService.decoder.decode(ErrorAPI.self, from: data)
                        onError(err)
                        return
                    } catch {
                        print(error)
                    }
                }
            }
        }
        task.resume()
    }
    
    static func login(_ body: Data,
                      completion: @escaping ((AuthorizedUser) -> Void),
                      onError :@escaping((ErrorAPI) -> Void)) {
        
        guard let url = URL(string: "https://fefu.t.feip.co/api/auth/login") else {
            print("Битая ссылка")
            return
        }
        
        var urlReq = URLRequest(url: url)
        urlReq.httpMethod = "POST"
        urlReq.httpBody = body
        urlReq.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlReq.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlReq) { data, response, error in
            
            guard let data = data else {
                return
            }
            
            if let res = response as? HTTPURLResponse {
                if res.statusCode == 200 {
                    do {
                        let user = try AuthService.decoder.decode(AuthorizedUser.self, from: data)
                        completion(user)
                        return
                    } catch {
                        print(error)
                    }
                }
                if res.statusCode == 422 {
                    do {
                        let err = try AuthService.decoder.decode(ErrorAPI.self, from: data)
                        onError(err)
                        return
                    } catch {
                        print(error)
                    }
                }
            }
        }
        task.resume()
    }
}

extension AuthService {
    static func profile(completion: @escaping ((UserProfileModel) -> Void),
                        onError :@escaping((ErrorAPI) -> Void)) {
        guard let url = URL(string: "https://fefu.t.feip.co/api/user/profile") else {
            print("Битая ссылка")
            return
        }
        
        var urlReq = URLRequest(url: url)
        urlReq.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlReq.addValue("application/json", forHTTPHeaderField: "Accept")
        urlReq.httpBody = nil
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            
            print("bad token")
            return
        }
        urlReq.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlReq) { data, response, error in
            
            guard let data = data else {
                return
            }
            
            if let res = response as? HTTPURLResponse {
                if res.statusCode == 200 {
                    do {
                        let profile = try AuthService.decoder.decode(UserProfileModel.self, from: data)
                    completion(profile)
                    return
                } catch let e {
                    print("Decode err: \(e)")
                    }
                }
                if res.statusCode == 422 {
                    do {
                        let err = try AuthService.decoder.decode(ErrorAPI.self, from: data)
                        onError(err)
                        return
                    } catch {
                        print(error)
                    }
                }
            }
        }
        task.resume()
    }
    
    static func logout(completion: @escaping (() -> Void),
                       onError :@escaping((ErrorAPI) -> Void)) {
        guard let url = URL(string: "https://fefu.t.feip.co/api/auth/logout") else {
            print("Битая ссылка")
            return
        }
        
        var urlReq = URLRequest(url: url)
        urlReq.httpMethod = "POST"
        urlReq.httpBody = nil
        urlReq.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlReq.addValue("application/json", forHTTPHeaderField: "Accept")
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            
            print("bad token")
            return
        }
        
        urlReq.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlReq) { data, response, error in
            
            guard let data = data else {
                return
            }
            
            
            if let res = response as? HTTPURLResponse {
                print(res.statusCode)
                if res.statusCode == 200 {
                    completion()
                    return
                }
                if res.statusCode == 422 {
                    do {
                        let err = try AuthService.decoder.decode(ErrorAPI.self, from: data)
                        onError(err)
                        return
                    } catch {
                        print(error)
                    }
                }
            }
        }
        task.resume()
    }
    
    static func activities(completion: @escaping ((SocialActivitiesModel) -> Void),
                           onError :@escaping((ErrorAPI) -> Void)) {
        guard let url = URL(string: "https://fefu.t.feip.co/api/user/activities") else {
            print("Битая ссылка")
            return
        }
        
        var urlReq = URLRequest(url: url)
        
        urlReq.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlReq.addValue("application/json", forHTTPHeaderField: "Accept")
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            
            print("bad token")
            return
        }
        
        urlReq.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: urlReq) { data, response, error in
            guard let data = data else {
                return
            }
            
            
            if let res = response as? HTTPURLResponse {
                print(res.statusCode)
                if res.statusCode == 200 {
                    do {
                        let types = try decoder.decode(SocialActivitiesModel.self, from: data)
                        print(types)
                        completion(types)
                        return
                    } catch let e {
                        print("Decode error: \(e)")
                    }
                } else if res.statusCode == 422 {
                    do {
                        let error = try decoder.decode(ErrorAPI.self, from: data)
                        onError(error)
                    } catch {
                        print("Decode error: \(error)")
                    }
                    
                }
            }
            
        }
        
        task.resume()
        
    }
}
