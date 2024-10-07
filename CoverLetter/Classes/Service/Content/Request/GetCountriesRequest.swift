//
//  GetCountriesRequest.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 21.05.2024.
//

import Alamofire

struct GetCountriesRequest: APIRequestBody {
    var url: String {
        "https://api.countrystatecity.in/v1/countries"
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var headers: HTTPHeaders? {
        [
            "X-CSCAPI-KEY": GlobalDefinitions.countriesCitiesAPIKey
        ]
    }
}
