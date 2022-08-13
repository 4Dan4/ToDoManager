//
//  MainModel.swift
//  ToDoManager-iOS
//
//  Created by dan4 on 09.08.2022.
//

import Foundation

struct Task: Codable, Identifiable {
    var id = UUID()
    var name: String
    var isDone: Bool = false
}

struct Project: Codable, Identifiable {
    var id = UUID()
    var name: String
    var task: [Task] = []
}
