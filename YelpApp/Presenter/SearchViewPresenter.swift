//
//  SearchViewPresenter.swift
//  YelpApp
//
//  Created by Bell on 2022-06-29.
//

import Foundation
import Alamofire

class SearchViewPresenter {
    
    // TODO update token
    private let token = "Bearer jqJWAk-7WYqlFHYYYPO1n1ZXmIX5HqyZa5ND8dY39W9t95N1-uaF7EWw0ws4NTSaTAO2D2qLXlG2HvYmF9sL-PMddInum1okvFA_O_Jov0t9x4A8RtXBcVMvIxq7YnYx"
    weak var view: SearchView?
    private var businesses:[Business]?
    
    required init(view: SearchView) {
        self.view = view
    }
    
    func viewDidLoad() {
        print("View notifies the Presenter that it has loaded.")
//        retrieveItems()
    }
    
    private func retrieveItems() {
        print("Presenter retrieves station from API")
        
        // TODO update bearer token
        let headers = HTTPHeaders(["Authorization": token])
        
        let request = AF.request("https://api.yelp.com/v3/businesses/search?location=NYC", headers: headers)
        
        request.responseDecodable { (response: DataResponse<BusinessResults, AFError>) in
            switch response.result {
                case let .success(value):
                    self.view?.onBusinessRetrieval(businessList: value.businesses)
                    
                case let .failure(error):
                    print(error)
            }
        }
    }
    
    public func retrieveBusinesses(location: String, term: String) {
        print("Presenter retrieves station from API")
        
        let headers = HTTPHeaders(["Authorization": token])
        
        let parameters: Parameters = [
        "location": location,
        "term": term
        ]
        
        let request = AF.request("https://api.yelp.com/v3/businesses/search?", parameters: parameters, headers: headers)
        
        request.responseDecodable { (response: DataResponse<BusinessResults, AFError>) in
            switch response.result {
                case let .success(value):
                    self.view?.onBusinessRetrieval(businessList: value.businesses)
                    
                case let .failure(error):
                    print(error)
            }
        }
    }
    
    public func retrieveBusinessesByCoordinate(term: String, latitude: Double, longitude: Double) {
        print("Presenter retrieves station from API")
        
        let headers = HTTPHeaders(["Authorization": token])
        
        let parameters: Parameters = [
        "latitude": latitude,
        "longitude": longitude,
        "term": term
        ]
        
        let request = AF.request("https://api.yelp.com/v3/businesses/search?", parameters: parameters, headers: headers)
        
        request.responseDecodable { (response: DataResponse<BusinessResults, AFError>) in
            switch response.result {
                case let .success(value):
                    self.view?.onBusinessRetrieval(businessList: value.businesses)
                    
                case let .failure(error):
                    print(error)
            }
        }
    }
    

    }

