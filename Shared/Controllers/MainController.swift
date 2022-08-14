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
    private let taskKey = "taskKey"
    
    func saveProjects() {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(projects), forKey: projectKey)
    }
    
    func loadProjects() {
        if let projectData = UserDefaults.standard.data(forKey: projectKey),
            let projectList = try? PropertyListDecoder().decode(Array<Project>.self, from: projectData) {
                projects = projectList
        }
    }
    
    func saveTasks() {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(tasks), forKey: taskKey)
    }
    
    func loadTasks() {
        if let taskData = UserDefaults.standard.data(forKey: taskKey),
           let taskList = try? PropertyListDecoder().decode(Array<Task>.self, from: taskData) {
            tasks = taskList
        }
    }
}
