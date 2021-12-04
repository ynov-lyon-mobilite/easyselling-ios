//
//  QueryParameters.swift
//  easyselling
//
//  Created by Maxence on 04/12/2021.
//

import Foundation

struct FilterQueryParameter: QueryParameter {
    let parameterName: String
    var type: FilterType = .EQUAL
    let value: String

    enum FilterType: String {
        case EQUAL = "_eq"
        case INN = "_in"
        case BETWEEN = "_between"
    }

    func encodeToQueryParameter() -> URLQueryItem {
        return URLQueryItem(name: "filter[\(parameterName)][\(type.rawValue)]", value: value)
    }
}

struct SortQueryParameter: QueryParameter {
    let propertyName: String
    let type: SortType

    enum SortType: String {
        case ASC = ""
        case DESC = "-"
    }

    func encodeToQueryParameter() -> URLQueryItem {
        return URLQueryItem(name: "sort[]", value: "\(type.rawValue)\(propertyName)")
    }
}

struct LimitQueryParameter: QueryParameter {
    let numberOfItems: Int

    func encodeToQueryParameter() -> URLQueryItem {
        return URLQueryItem(name: "limit", value: "\(numberOfItems)")
    }
}

protocol QueryParameter {
    func encodeToQueryParameter() -> URLQueryItem
}
