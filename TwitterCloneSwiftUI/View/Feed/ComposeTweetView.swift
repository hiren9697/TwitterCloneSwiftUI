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
    @StateObject var viewModel: ComposeTweetVM
    let selectedMediaGridWidth: CGFloat = (Geometry.width * 0.6)
    let selectedMediaGridHeight: CGFloat = (Geometry.width * 0.6) * 1.5
    
    init(viewModel: ComposeTweetVM) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 1. Content
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
                            // 2. Local media grid
                            /// Shows only if user hasn't selected any media
                            if !viewModel.localMedia.isEmpty && viewModel.selectedMedia.isEmpty {
                                localMediaGrid
                                    .frame(height: viewModel.localPhotoSize.height)
                            }
                            // 3. Selected media grid
                            if !viewModel.selectedMedia.isEmpty {
                                selectedMediaGrid
                                    .frame(height: selectedMediaGridHeight)
                            }
                            
                        }
                    }
                    // 2. Add Image
                    HStack {
                        // 1. Photos
                        PhotosPicker(selection: $viewModel.selectedPhotoPickerItems,
                                     maxSelectionCount: 3,
                                     photoLibrary: PHPhotoLibrary.shared(),
                                     label: {
                            Image("ic_image")
                                .padding(.horizontal)
                        })
                        // 2. Camera
                        PhotosPicker(selection: $viewModel.selectedPhotoPickerItems,
                                     maxSelectionCount: 3,
                                     photoLibrary: PHPhotoLibrary.shared(),
                                     label: {
                            Image("ic_camera")
                                .padding(.horizontal)
                        })
                        Spacer()
                    }
                    .padding()
                }
                // 2. Loader
                if viewModel.isLoading {
                    LoadingView(color: AppColor.white)
                }
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
        Button(action: {
            viewModel.makeTweet()
        },
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
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: [GridItem(.fixed(100), spacing: 20)],
                      content: {
                // 1. Leading inset
                Spacer()
                    .frame(width: 20)
                // 2. Camera button
                cameraButton
                // 3. Content
                ForEach(viewModel.localMedia) { media in
                    CTLocalMediaItemView(localMedia: media,
                                         size: viewModel.localPhotoSize,
                                         onTapAction: {
                        viewModel.selectedMedia.append(media)
                        viewModel.selectedPhotoPickerItems.append(PhotosPickerItem(itemIdentifier: media.localIdentifier))
                        Log.info(viewModel.selectedMedia.count)
                    })
                }
                // 4. Trailing inset
                Spacer()
                    .frame(width: 20)
            })
        }
    }
    
    private var selectedMediaGrid: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: [GridItem(.flexible(), spacing: 20)],
                      content: {
                // 1. Leading inset
                Spacer()
                    .frame(width: 20)
                // 2. Content
                ForEach(viewModel.selectedMedia) { media in
                    CTSelectedMediaItemView(media: media,
                                            size: viewModel.selectedMediaSize,
                                            action: {
                        if let index = viewModel.selectedMedia.firstIndex(where: { $0 == media }) {
                            viewModel.selectedPhotoPickerItems.remove(at: index)
                        }
                    })
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
            Image("ic_camera_with_background")
        })
    }
    
    private var photosButton: some View {
        Button(action: {},
               label: {
            Image("ic_camera")
        })
    }
}

// MARK: - Selected Media Item View
struct CTSelectedMediaItemView: View {
    let media: LocalMediaRepresentable
    let size: CGSize
    let action: VoidCallback
    
    init(media: LocalMediaRepresentable,
         size: CGSize,
         action: @escaping VoidCallback) {
        self.media = media
        self.size = size
        self.action = action
    }
    
    var body: some View {
        if let displayImage = media.displayImage {
            ZStack(alignment: .topTrailing) {
                displayImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: size.width, height: size.height)
                    .clipShape(RoundedRectangle(cornerRadius: 17))
                if let videoMedia = media.videoMedia {
                    if let duration = videoMedia.videoDuration {
                        VStack {
                            Spacer()
                            CTLocalVideoDurationView(displayText: duration.displayText)
                        }
                    }
                }
                Button(action: action,
                       label: {
                    Image("ic_close")
                        .background {
                            Circle()
                                .stroke(AppColor.white, lineWidth: 10)
                        }
                })
            }
        } else {
            EmptyView()
        }
    }
}

// MARK: - Local Media Item View
struct CTLocalMediaItemView: View {
    let localMedia: LocalMediaRepresentable
    let size: CGSize
    let onTapAction: VoidCallback
    
    init(localMedia: LocalMediaRepresentable,
         size: CGSize,
         onTapAction: @escaping VoidCallback) {
        self.localMedia = localMedia
        self.size = size
        self.onTapAction = onTapAction
    }
    
    var body: some View {
        if let displayImage = localMedia.displayImage {
            Button(action: onTapAction,
                   label: {
                ZStack(alignment: .bottomTrailing) {
                    // 1. Thumbnail image if video OR Image
                    displayImage
                        .resizable()
                        .scaledToFill()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 17))
                    // 2. Duration if video
                    if let videoMedia = localMedia.videoMedia,
                        let duration = videoMedia.videoDuration {
                        CTLocalVideoDurationView(displayText: duration.displayText)
                    }
                }
            })
        } else {
            EmptyView()
        }
    }
}

// MARK: - Video Duration
struct CTLocalVideoDurationView: View {
    let displayText: String
    
    var body: some View {
        Text(displayText)
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

// MARK: - Preview
//struct ComposeTweetView_Previews: PreviewProvider {
//    static var previews: some View {
//        ComposeTweetView()
//    }
//}
