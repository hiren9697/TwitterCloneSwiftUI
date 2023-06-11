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
    
    let selectedMediaGridHeight: CGFloat = (Geometry.width * 0.6) * 1.5
    
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
                        if !viewModel.localMedia.isEmpty {
                            localMediaGrid
                                .frame(height: viewModel.localPhotoSize.height)
//                            CTLocalMediaItemView(image: viewModel.localPhotos.first!.image, size: viewModel.localPhotoSize)
                        }
                        // 2. Media grid
                        if !viewModel.selectedImages.isEmpty {
                            selectedMediaGrid
                                .frame(height: selectedMediaGridHeight)
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
            .onAppear {
                viewModel.checkPhotoLibraryAccessPermission()
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
    
    private var localMediaGrid: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: [GridItem(.fixed(100), spacing: 20)],
                      content: {
                // 1. Leading inset
                Spacer()
                    .frame(width: 20)
                // 2. Camera button
                cameraButton
                // 3. Content
                ForEach(viewModel.localMedia) { media in
                    CTLocalMediaItemView(localMedia: media, size: viewModel.localPhotoSize)
                }
                // 4. Trailing inset
                Spacer()
                    .frame(width: 20)
            })
        }
    }
    
    private var selectedMediaGrid: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: [GridItem(.flexible(), spacing: 20)],
                      content: {
                // 1. Leading inset
                Spacer()
                    .frame(width: 20)
                // 2. Content
                ForEach(viewModel.selectedImages) { image in
                    CTSelectedMediaItemView(image: image.image)
                }
                // 3. Trailing inset
                Spacer()
                    .frame(width: 20)
            })
        }
    }
    
    private var cameraButton: some View {
        Button(action: {},
               label: {
            Image("ic_camera")
        })
    }
}

// MARK: - Selected Media Item View
struct CTSelectedMediaItemView: View {
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
                .clipShape(RoundedRectangle(cornerRadius: 17))
        }
    }
}

// MARK: - Local Media Item View
struct CTLocalMediaItemView: View {
    let localMedia: LocalMedia
    let size: CGSize
    
    init(localMedia: LocalMedia, size: CGSize) {
        self.localMedia = localMedia
        self.size = size
//        self.width = width
//        self.height = height
        //Log.info("Width: \(width), Height: \(height)")
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            // 1. Thumbnail image if video OR Image
            localMedia.displayImage
                .resizable()
                .scaledToFill()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: size.height)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 17))
            // 2. Duration if video
            if let duration = localMedia.videoDuration {
                Text(duration.displayText)
                    .font(Font.custom(AppFont.regular.rawValue, size: 12))
                    .foregroundColor(AppColor.white)
                    .padding(5)
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .fill(AppColor.darkGray.opacity(0.7))
                    )
                    .padding(.bottom, 8)
                    .padding(.trailing, 8)
            }
        }
    }
}

// MARK: - Preview
struct ComposeTweetView_Previews: PreviewProvider {
    static var previews: some View {
        ComposeTweetView()
    }
}
