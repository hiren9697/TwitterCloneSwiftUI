//
//  TabBarView.swift
//  TwitterCloneSwiftUI
//
//  Created by Hirenkumar Fadadu on 27/05/23.
//

import SwiftUI

// MARK: - View
struct TabBarView: View {
    @State var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            FeedView()
                .tabItem {
                    Label("", image: selectedTab == 0 ? "ic_tab_home_select" : "ic_tab_home_unselect")
                }.tag(0)
            SearchView()
                .tabItem {
                    Label("", image: selectedTab == 1 ? "ic_tab_search_select" : "ic_tab_search_unselect")
                }.tag(1)
            NotificationView()
                .tabItem {
                    Label("", image: selectedTab == 2 ? "ic_tab_notification_select" : "ic_tab_notification_unselect")
                }.tag(2)
            MessageView()
                .tabItem {
                    Label("", image: selectedTab == 3 ? "ic_tab_message_select" : "ic_tab_message_unselect")
                }.tag(3)
        }
    }
}

// MARK: - Preview
struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
