//
//  MainPage.swift
//  ToDoManager-iOS
//
//  Created by Daniil Akifev on 09.08.2022.
//

import SwiftUI

struct MainPage: View {
    @StateObject private var storage = MainController()
    @State private var newProjectName = ""
    @State private var isNewProjectCellShown = false
    @FocusState private var isFocusedNewProjectTextField: Bool
    
    private func cancelButton() -> some View {
        return Button(
            action: {
                newProjectName = ""
                isNewProjectCellShown = false
                isFocusedNewProjectTextField = false
            },
            label: {
                Text("Cancel")
                    .font(.system(.title3))
                    .foregroundColor(Color.white)
            }
        )
        .frame(width: 110, height: 40)
        .background(Color.blue)
        .cornerRadius(38.5)
        .shadow(color: Color.black.opacity(0.3),
                radius: 3,
                x: 3,
                y: 3
        )
    }
    
    private func newProjectButton() -> some View {
        return Button(
            action: {
                isNewProjectCellShown = true
                isFocusedNewProjectTextField = true
            },
            label: {
                Image(systemName: "plus")
                    .foregroundColor(.white)
            }
        )
        .frame(width: 40, height: 40)
        .background(Color.blue)
        .cornerRadius(38.5)
        .shadow(color: Color.black.opacity(0.3),
                radius: 3,
                x: 3,
                y: 3
        )
    }
    
    private func addNewProjectView() -> some View {
        return VStack {
            HStack {
                TextField("Enter name", text: $newProjectName)
                    .focused($isFocusedNewProjectTextField)
                    .onSubmit {
                        if (!newProjectName.isEmpty) {
                            storage.projects.append(Project(name: newProjectName))
                            newProjectName = ""
                            storage.saveProjects()
                        }
                        isNewProjectCellShown = false
                        isFocusedNewProjectTextField = false
                    }
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach ($storage.projects) { $project in
                        NavigationLink("\(project.name)", destination: TaskListView(title: "\(project.name)"))
                    }
                    .onDelete(perform: deleteProject)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    if isNewProjectCellShown {
                        addNewProjectView()
                            .listRowBackground(Color.clear)
                    }
                }
                .navigationTitle("Projects")
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        if !isNewProjectCellShown {
                            newProjectButton()
                        } else {
                            cancelButton()
                        }
                    }
                    .padding()
                }
            }
        }.onAppear(perform: storage.loadProjects)
    }
    
    private func deleteProject(at offset: IndexSet) {
        storage.projects.remove(atOffsets: offset)
        storage.saveProjects()
    }
}

struct MainPage_Previews: PreviewProvider {
    static var previews: some View {
        MainPage().previewInterfaceOrientation(.portrait)
    }
}
