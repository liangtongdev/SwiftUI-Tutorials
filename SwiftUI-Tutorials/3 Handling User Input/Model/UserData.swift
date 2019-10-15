//
//  UserData.swift
//  3 Handling User Input
//
//  Created by liangtong on 2019/10/15.
//  Copyright © 2019 COM.LIANGTONG. All rights reserved.
//

import SwiftUI
import Combine

final class UserData: ObservableObject{
    @Published var showFavoritesOnly = false
    @Published var landmarks = landmarkData
}
