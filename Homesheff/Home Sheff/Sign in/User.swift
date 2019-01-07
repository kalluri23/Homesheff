//
//  User.swift
//  Homesheff
//
//  Created by Anurag Yadev on 10/18/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//


//{
//    "id": 117,
//    "firstName": "First name",
//    "lastName": "last name",
//    "password": "Evr6eHL+xPEgVjKB9ErUTa3gMAwhnZAZUFZoUbik4Qs=",
//    "salt": "PndW0L6mlQLGjH29AEUMzX5L1gXrD4",
//    "email": "user9090@homesheff.com",
//    "phone": "1231231234",
//    "zipcode": "21909",
//    "signUpDate": "2018-10-29T23:50:54.000+0000",
//    "isChef": false,
//    "isCustomer": true,
//    "isActive": true,
//    "imageURL": "https://png.icons8.com/color/2x/person-female.png",
//    "services": "string"
//}


import Foundation

 struct UserModel: Codable {
    let id: Int?
    var firstName: String?
    var lastName: String?
    let password: String?
    let salt: String?
    let email: String?
    var phone: String?
    var zipcode: String?
    let signUpDate: String?
    let isChef: Bool?
    let isCustomer: Bool?
    let isActive: Bool?
    let imageURL: String?
    var services: String?
    var location: String?
    var about: String?
    var headertext: String?
}


final class User {
    
    static let defaultUser = User()
    
    var currentUser: UserModel? = nil
    
    private init() {}
    
    func createUser(data: Data?) -> Bool {
        do {
            let jsonDecoder = JSONDecoder()
            let list = try jsonDecoder.decode(UserModel.self, from: data!)
                currentUser = list
            return true
        }
        catch (let error){
            print(error)
            return false
        }
   }
}

struct Details {
    var firstName: String
    var lastName: String
    var email: String
    var password: String
    var imageUrl: String
    var zipCode: String
    var phoneNo: String
    var isChef: Bool
    var isCustomer: Bool
    init(_ dictionary: [String : Any]) {
        firstName = dictionary["first_name"] as! String
        lastName = dictionary["last_name"] as! String
        email = dictionary["email"] as! String
        password = ""
        imageUrl = "https://png.icons8.com/color/2x/person-male.png"
        zipCode = "20017"
        phoneNo = ""
        isChef = false
        isCustomer = false
    }
    init() {
        firstName = ""
        lastName = ""
        email = ""
        password = ""
        imageUrl = "https://png.icons8.com/color/2x/person-male.png"
        zipCode = "20017"
        phoneNo = ""
        isChef = false
        isCustomer = false
    }
}
