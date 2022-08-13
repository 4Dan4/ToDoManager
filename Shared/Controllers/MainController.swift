//
//  MainController.swift
//  ToDoManager-iOS
//
//  Created by dan4 on 13.08.2022.
//

import UIKit

final class MainController: ObservableObject {
    
    @Published var projects: [Project] = [
        Project(name: "Inbox"),
        Project(name: "Today"),
        Project(name: "Someday")
    ]
    
    @Published var tasks: [Task] = [
        Task(name: "Check post")
    ]
    
    private let projectKey = "projectKey"
    
    
    func saveProjects() {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(projects), forKey: projectKey)
    }
    
    func loadProjects() {
        if let noteData = UserDefaults.standard.data(forKey: projectKey),
            let noteList = try? PropertyListDecoder().decode(Array<Project>.self, from: noteData) {
                projects = noteList
        }
    }
    
}
