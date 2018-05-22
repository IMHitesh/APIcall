//
//  Struct.swift
//  SwiftyJson4.0
//
//  Created by Hitesh Surani on 01/04/18.
//  Copyright © 2018 Brainvire. All rights reserved.
//



struct Course: Decodable {
    let id: Int?
    let name: String?
    let link: String?
    let imageUrl: String?
}

/*
 
 */
struct Person: Decodable {
    let homeworld: String?
    let birth_year: String?
    let eye_color: String?
    let gender: String?
    let hair_color: String?
    let height: String?
    let mass: String?
    let name: String?
    let skin_color: String?
}

struct MainSturct: Decodable {
    let count: Int?
    let results: [Person]?
}
