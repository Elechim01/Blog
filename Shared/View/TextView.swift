//
//  TextView.swift
//  TextView
//
//  Created by Michele Manniello on 22/08/21.
//

import SwiftUI

struct TextView: UIViewRepresentable  {
    @Binding var text : String
    @Binding var height: CGFloat
    var fontSize : CGFloat
    
    func makeCoordinator() -> Coordinator {
        return TextView.Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) ->  UITextView {
        let view = UITextView()
        view.backgroundColor = .clear
        view.font = .systemFont(ofSize: fontSize)
        view.text = text
        view.layoutManager.delegate = context.coordinator
        view.delegate = context.coordinator
        return view
    }
    func updateUIView(_ uiView: UITextView, context: Context) {
        
    }
    class Coordinator: NSObject,UITextViewDelegate,NSLayoutManagerDelegate {
        var parent : TextView
        init(parent : TextView) {
            self.parent = parent
        }
//        spacing..
        func layoutManager(_ layoutManager: NSLayoutManager, lineSpacingAfterGlyphAt glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
            return 10
        }
        
        
//        For Dyamic Text heigt...
        func textViewDidChange(_ textView: UITextView) {
            let height = textView.contentSize.height
            self.parent.height = height
            
//            Updating Text...
            self.parent.text = textView.text
        }
        func textViewDidBeginEditing(_ textView: UITextView) {
            let height = textView.contentSize.height
            self.parent.height = height
        }
    }
}

