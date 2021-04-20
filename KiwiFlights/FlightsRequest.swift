//
//  FlightsRequest.swift
//  KiwiFlights
//
//  Created by Milos Petrusic on 19.4.21..
//

import Foundation

enum FlightsError: Error {
    case noDataAvailable
}

struct FlightsRequest {
    let resourceURL: URL
    
    init(dateFrom: String, dateTo: String) {
        let resourceString = "https://api.skypicker.com/flights?v=3&sort=popularity&asc=0&locale=en&daysInDestinationFrom=&daysInDestinationTo=&affilid=&children=0&infants=0&flyFrom=49.2-16.61-250km&to=anywhere&featureName=aggregateResults&dateFrom=\(dateFrom)&dateTo=\(dateTo)&typeFlight=oneway&returnFrom=&returnTo=&one_per_date=0&oneforcity=1&wait_for_refresh=0&adults=1&limit=5&partner=picky"
        guard let resourceURL = URL(string: resourceString) else { fatalError() }
        self.resourceURL = resourceURL
    }
    
    func getData(completion: @escaping (Result<[FlightsDetails], FlightsError>) -> Void) {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: resourceURL) { (data, response, error) in
            guard let jsonData = data else { return }
            do {
                let decoder = JSONDecoder()
                let flightsResponse = try decoder.decode(FlightsModel.self, from: jsonData)
                let flightsData = flightsResponse.data
                print(resourceURL)
                completion(.success(flightsData))
            } catch {
                completion(.failure(.noDataAvailable))
            }
        }
        task.resume()
    }
}
