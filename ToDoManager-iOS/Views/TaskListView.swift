//
//  ContentView.swift
//  ToDoManager-iOS
//
//  Created by dan4 on 09.08.2022.
//

import SwiftUI
import CoreData

struct TaskListView: View {
    @StateObject private var storage = MainController()
    @State var title = ""
    @State var newTaskName: String = ""
    @State var isNewTaskCellShown: Bool = false
    @FocusState private var isFocusedNewTaskTextField: Bool
    
    fileprivate func cancelButton() -> some View {
        return Button(
            action: {
                newTaskName = ""
                isNewTaskCellShown = false
                isFocusedNewTaskTextField = false
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
    
    private func newTaskButton() -> some View {
        return Button(
            action: {
                isNewTaskCellShown = true
                isFocusedNewTaskTextField = true
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
    
    private func addNewTaskView() -> some View {
        return VStack {
            HStack {
                TextField("Enter name", text: $newTaskName)
                    .focused($isFocusedNewTaskTextField)
                    .onSubmit {
                        if (!newTaskName.isEmpty) {
                            storage.tasks.append(Task(name: newTaskName))
                            newTaskName = ""
                        }
                        isNewTaskCellShown = false
                        isFocusedNewTaskTextField = false
                    }
            }
        }
    }
    
    var body: some View {
        ZStack {
            List {
                ForEach (storage.tasks) { task in
                    Text(task.name)
                }
                .onDelete(perform: removeItems)
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                if isNewTaskCellShown {
                    addNewTaskView()
                        .listRowBackground(Color.clear)
                }
            }
            .navigationTitle(title)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    if !isNewTaskCellShown {
                        newTaskButton()
                    } else {
                        cancelButton()
                    }
                }
                .padding()
            }
        }
    }
    
    private func removeItems(at offset: IndexSet) {
        storage.tasks.remove(atOffsets: offset)
    }
}
