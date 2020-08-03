import UIKit

// MARK: - Models

struct Person: Decodable {
    let name: String
//    let height: String
//    let mass: String
//    let hair_color: String
//    let skin_color: String
//    let eye_color: String
//    let birth_year: String
//    let gender: String
//    let homeworld: String
    let films: [URL]
//    let species: [String]
//    let vehicles: [String]
//    let starships: [String]
//    let created: String
//    let edited: String
//    let url: String
}

struct Film: Decodable {
    let title: String
//    let episode_id: String
    let opening_crawl: String
//    let director: String
//    let producer: String
    let release_date: String
//    let characters: [String]
//    let planets: [String]
//    let starships: [String]
//    let vehicles: [String]
//    let species: [String]
//    let created: String
//    let edited: String
//    let url: String
}

// MARK: - Model Controllers

class SwapiService {
    static private let baseURL = URL(string: "https://swapi.dev/api/")
    
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        // 1 - Prepare URL
        guard let baseURL = baseURL else {return completion(nil)}
        let finalURL = baseURL.appendingPathComponent("people/\(id)")
        print(finalURL)
        // 2 - Contact server
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            // 3 - Handle
            if let error = error {
                print(error.localizedDescription)
                return completion(nil)
            }
            // 4 - Check for data
            guard let data = data else {return completion(nil)}
            // 5 - Decode Person from JSON
            do {
                let person = try JSONDecoder().decode(Person.self, from: data)
                return completion(person)
            } catch {
                print(error.localizedDescription)
                return completion(nil)
            }
        }.resume()
    }
    static func fetchFilm(url: URL, completion: @escaping (Film?) -> Void) {
        // 1 - Contact server
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            // 2 - Handle errors
            if let error = error {
                print(error.localizedDescription)
                return completion(nil)
            }
            // 3 - Check for data
            guard let data = data else {return completion(nil)}
            // 4 - Decode Film from JSON
            do {
                let film = try JSONDecoder().decode(Film.self, from: data)
                return completion(film)
            } catch {
                print(error.localizedDescription)
                return completion(nil)
            }
        }.resume()
    }
}

SwapiService.fetchPerson(id: 10) { (person) in
    if let person = person {
        print(person.name)
        for film in person.films {
            fetchFilm(url: film)
        }
    }
}

func fetchFilm(url: URL) {
    SwapiService.fetchFilm(url: url) { (film) in
        if let film = film {
            print(film.title)
        }
    }
}

