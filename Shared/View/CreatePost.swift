//
//  CreatePost.swift
//  CreatePost
//
//  Created by Michele Manniello on 22/08/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct CreatePost: View {
    @EnvironmentObject var blogData : BlogViewModel
    //  Post Properties...
    @State var postTitle = ""
    @State var authorName = ""
    @State var postContent : [PostContent] =  []
    //    Keyboard Focus State for Textviews
    @FocusState var showKeyboard : Bool
    
    var body: some View {
        //        since we need nav Buttons..
        //        So ncludng navBar..
        NavigationView{
            ScrollView(.vertical, showsIndicators: false){
                VStack(spacing: 15){
                    VStack(alignment: .leading) {
                        TextField("Post Title",text: $postTitle)
                            .font(.title2)
                        Divider()
                    }
                    VStack(alignment: .leading,spacing: 11) {
                        Text("Author:")
                            .font(.caption.bold())
                        
                        TextField("iJustine",text: $authorName)
                        
                        Divider()
                    }
                    .padding(.top,5)
                    .padding(.bottom,20)
                    //                    iterating Post content...
                    ForEach($postContent){ $content in
                        
                        VStack{
                            //                            Image Ulr
                            if content.type == .Image{
                                if content.showImage && content.value != ""{
                                    WebImagev(url: content.value)
                                    //                                    url//                                    if tap change url..
                                        .onTapGesture {
                                            withAnimation {
                                                content.showImage = false
                                            }
                                        }
                                }else{
                                    //                              Textfield For URL...
                                    VStack {
                                        TextField("Image URL",text: $content.value, onCommit:  {
                                            //                                    To show Image when Pressed Return..
                                            withAnimation{
                                                content.showImage = true
                                            }
                                        })
                                        Divider()
                                        
                                    }
                                    .padding(.leading,5)
                                }
                                
                            }else{
                                //                        Custom Text Editor From UIKit...
                                TextView(text: $content.value, height: $content.height, fontSize: getFontSize(type: content.type))
                                    .focused($showKeyboard)
                                //                        Approx height Based on Font for first Display..
                                    .frame(height: content.height == 0 ? getFontSize(type: content.type) * 2 : content.height)
                                    .background(
                                        Text(content.type.rawValue)
                                            .font(.system(size: getFontSize(type: content.type)))
                                            .foregroundColor(.gray)
                                            .opacity(content.value == "" ? 0.7 : 0)
                                            .padding(.leading, 5)
                                        ,alignment: .leading
                                    )
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .contentShape(Rectangle())
//                        Swipe to delete...
                        .gesture(DragGesture().onEnded({ value in
                            if -value.translation.width < (UIScreen.main.bounds.width / 2.5) && !content.showDeleteAlert{
//                                Showing Alert...
                                content.showDeleteAlert = true
                            }
                        }))
                        .alert("Sure to delete this content?",isPresented: $content.showDeleteAlert) {
                            Button("Delete",role: .destructive) {
//                                Deleting Content...
                                let index = postContent.firstIndex { currentPost in
                                    return currentPost.id == content.id
                                } ?? 0
                                withAnimation {
                                    postContent.remove(at: index)
                                }
                            }
                        }
                    }
                    //                    Menu Button to insert Post Content...
                    Menu {
                        //                        iterating Cases...
                        ForEach(PostType.allCases,id: \.rawValue){ type in
                            Button(type.rawValue){
                                //                                Appending new PostContent...
                                withAnimation{
                                    postContent.append(PostContent(value: "", type: type))
                                }
                            }
                        }
                        
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                            .foregroundColor(.primary)
                    }
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity,alignment: .leading)
                    
                }
                .padding()
            }
            //            changing Post title dynamic..
            .navigationTitle(postTitle == "" ? "Post Title" : postTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if !showKeyboard{
                        Button("Cancel"){
                            blogData.createPost.toggle()
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if showKeyboard {
                        Button("Done"){
//                            Closing Keboard..
                            showKeyboard.toggle()
                        }

                    }else{
                        Button("Post"){
                            blogData.writePost(content: postContent,author: authorName,postTitle: postTitle)
                        }
                        .disabled(authorName == "" || postTitle == "")
                    }
                }
            }
        }
    }
}

struct CreatePost_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// Dynamic height...
func getFontSize(type: PostType)-> CGFloat{
//    your own...
    switch type {
    case .Header:
        return 24
    case .SubHeading:
        return 22
    case .Paragraph:
        return 18
    case .Image:
        return 18
    }
}

//Async Image...
struct WebImagev : View{
    var url : String
    
    var body: some View{
        WebImage(url: URL(string: url))
            .onFailure{_ in
                Text("Failed to load Image : (((")
            }
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: UIScreen.main.bounds.width - 30, height: 250)
            .cornerRadius(15)
    }
}



