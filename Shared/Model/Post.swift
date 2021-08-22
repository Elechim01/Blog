//
//  Post.swift
//  Post
//
//  Created by Michele Manniello on 22/08/21.
//

import SwiftUI
import FirebaseFirestoreSwift
import Firebase

// Post Model...
struct Post: Identifiable,Codable{
    
    @DocumentID var id : String?
    var title : String
    var author : String
    var postContent: [PostContent]
    var date : Timestamp
    
    enum CodingKeys: String,CodingKey {
        case id
        case title
        case author
        case postContent
        case date
    }
}

// Post Content Model..
struct PostContent: Identifiable,Codable {
    var id = UUID().uuidString
    var value: String
    var type : PostType
//    For Height..
//    Only for UI not for backend..
    var height: CGFloat = 0
    var showImage: Bool = false
    var showDeleteAlert: Bool = false
    
    enum CodingKeys: String,CodingKey{
//        Since firestore keyname is key...
        case type = "key"
        case value
    }
}
//Content Type...
// Eg Header , Paragraph...
enum PostType: String,CaseIterable,Codable {
    case Header = "Header"
    case SubHeading = "Subheading"
    case Paragraph = "Pargraph"
    case Image = "Image"
}
