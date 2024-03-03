//
//  userModel.swift
//  mvvm_Demo_API
//
//  Created by Mohamed Abd Elhakam on 25/12/2023.
//

import Foundation
struct User : Codable {
    let id : Int
    let name : String
    let email : String
    let company : Company
}


struct Company : Codable {
    let name : String
}


