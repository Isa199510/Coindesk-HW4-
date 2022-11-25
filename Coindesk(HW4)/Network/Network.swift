//
//  Network.swift
//  Coindesk(HW4)
//
//  Created by Иса on 24.11.2022.
//
import Foundation
import Alamofire

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func  fetchAF(from url: String, completion: @escaping(Result<Coindesk, AFError>) -> Void) {
        AF.request(Link.urlCoindesk.rawValue)
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    let coindesk = Coindesk.getCoindesk(from: value)
                    completion(.success(coindesk))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
