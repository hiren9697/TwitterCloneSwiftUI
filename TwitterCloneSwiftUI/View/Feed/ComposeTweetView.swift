//
//  ComposeTweetView.swift
//  TwitterCloneSwiftUI
//
//  Created by Hirenkumar Fadadu on 28/05/23.
//

import SwiftUI
import PhotosUI
import SDWebImageSwiftUI

// MARK: - View
struct ComposeTweetView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = ComposeTweetVM()
    
    let mediaGridHeight: CGFloat = (Geometry.width * 0.6) * 1.5
    
    var body: some View {
        NavigationStack {
            VStack() {
                // 1. Content
                ScrollView {
                    VStack {
                        // 1. Image / Tweet text
                        HStack(alignment: .top) {
                            // 1. Profile Image
                            WebImage(url: appState.currentUser?.profileImageURL)
                                .resizable()
                                .frame(width: 37, height: 37)
                                .clipShape(Circle())
                            // 2. Tweet text box
                            tweetTextBox
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 5)
                        // 2. Media grid
                        if !viewModel.selectedImages.isEmpty {
                            mediaGrid
                                .frame(height: mediaGridHeight)
                        }
                        
                    }
                }
                // 2. Add Image
                HStack {
                    PhotosPicker(selection: $viewModel.selectedPhotoPickerItems,
                                 maxSelectionCount: 2,
                                 label: {
                        Image("ic_image")
                    })
                    Spacer()
                }
                .padding()
            }
            .toolbar {
                // 1. Cancel button
                ToolbarItem(placement: .navigationBarLeading) {
                    cancelButton
                }
                // 2. Tweet Button
                ToolbarItem(placement: .navigationBarTrailing) {
                    tweetButton
                }
            }
        }
        
    }
}

// MARK: - UI Components
extension ComposeTweetView {
    
    private var cancelButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        },
               label: {
            Text("Cancel")
                .font(Font.custom(AppFont.regular.rawValue, size: 14))
                .foregroundColor(AppColor.blue)
        })
    }
    
    private var tweetButton: some View {
        Button(action: {},
               label: {
            Text("Tweet")
                .font(Font.custom(AppFont.regular.rawValue, size: 14))
                .foregroundColor(AppColor.white)
                .padding(.vertical, 5)
                .padding(.horizontal, 9)
                .background(
                    Capsule(style: .circular)
                        .fill(AppColor.blue)
                )
        })
    }
    
    private var tweetTextBox: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $viewModel.text)
                
                .font(Font.custom(AppFont.regular.rawValue, size: 14))
                .foregroundColor(AppColor.primaryTextColor)
                .tint(AppColor.primaryTextColor)
                .frame(minHeight: 70)
                .clipShape(
                    RoundedRectangle(cornerRadius: 8)
                )
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(AppColor.cD3D3D3, lineWidth: 1)
                )
            if viewModel.text.isEmpty {
                Text("What's happening?")
                    .font(Font.custom(AppFont.regular.rawValue, size: 14))
                    .foregroundColor(AppColor.secondaryTextColor)
                    .padding(.top, 7)
                    .padding(.leading, 4.5)
            }
        }
    }
    
    private var mediaGrid: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: [GridItem(.flexible(), spacing: 20)],
                      content: {
                // 1. Leading inset
                Spacer()
                    .frame(width: 20)
                // 2. Content
                ForEach(viewModel.selectedImages) { image in
                    CTMediaItemView(image: image.image)
                }
                // 3. Trailing inset
                Spacer()
                    .frame(width: 20)
            })
        }
    }
}

// MARK: - Media Item View
struct CTMediaItemView: View {
    let image: Image
    let width: CGFloat
    let height: CGFloat
    
    init(image: Image) {
        self.image = image
        self.width = (Geometry.width * 0.6)
        self.height = (Geometry.width * 0.6) * 2
        Log.info("Width: \(width), Height: \(height)")
    }
    
    var body: some View {
        ZStack {
            image
                .resizable()
                .scaledToFill()
                .frame(width: width, height: height)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

// MARK: - Preview
struct ComposeTweetView_Previews: PreviewProvider {
    static var previews: some View {
        ComposeTweetView()
    }
}
