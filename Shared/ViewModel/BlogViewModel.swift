//
//  BlogViewModel.swift
//  BlogViewModel
//
//  Created by Michele Manniello on 22/08/21.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

class BlogViewModel: ObservableObject{
//    Posts..
    @Published var posts : [Post]?
    
//    errors...
    @Published var alertMsg = ""
    @Published var showAlert = false
    
//    New Post
    @Published var createPost = false
    @Published var isWriting = false
    
//    Async Await Method..
    func fetchPosts()async {
        do{
            let db = Firestore.firestore().collection("Blog")
            let posts = try await db.getDocuments()
//            Converting to url Model...
            self.posts  = posts.documents.compactMap({ post in
                return  try! post.data(as: Post.self)
            })
            
        }catch{
            alertMsg = error.localizedDescription
            showAlert.toggle()
        }
    }
    
    func deletePost(post: Post){
        guard let _ = posts else {
            return
        }
        let index = posts?.firstIndex(where: { currentPos in
            return currentPos.id == post.id
        }) ?? 0
//        deleting Post...
        Firestore.firestore().collection("Blog").document(post.id ?? "").delete()
        
        withAnimation {
            posts?.remove(at: index)
        }
    }
    func writePost(content: [PostContent],author: String,postTitle : String){
        do{
//            Loading animation
            withAnimation {
                isWriting = true
            }
            
//            Storing to DB...
            var post = Post(title: postTitle, author: author, postContent: content, date: Timestamp(date: Date()))
            var database = Firestore.firestore().collection("Blog").document()
           let _ = try database.setData(from: post)
            post.id = database.documentID
            withAnimation {
//                adding to posts
                posts?.append(post)
                isWriting = true
//                closing PostView..
                createPost = false
            }
        }catch{
            print(error.localizedDescription)
        }
    }
}
