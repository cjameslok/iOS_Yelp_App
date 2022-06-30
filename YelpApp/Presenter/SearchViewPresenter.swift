//
//  SearchViewPresenter.swift
//  YelpApp
//
//  Created by Bell on 2022-06-29.
//

import Foundation
import Alamofire

//protocol StationsViewPresenter {
//    init(view: StationsView)
//    func viewDidLoad()
//}

class SearchViewPresenter {
    
    // TODO update token
    private let token = "Bearer XXX"
    weak var view: SearchView?
    private var businesses:[Business]?
    
    required init(view: SearchView) {
        self.view = view
    }
    
    // MARK: - Protocol methods
    func viewDidLoad() {
        print("View notifies the Presenter that it has loaded.")
//        retrieveItems()
    }
    
    // MARK: - Private methods
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
    

    }
        


        
//        let stations: [Station]? = self.stations?
//            .map { $0 }
//        view?.onStationsRetrieval(stations: stations ?? [])
//        view?.onStationsRetrieval(stations: [])



