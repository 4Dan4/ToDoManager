//
//  ContentView.swift
//  ToDoManager-iOS
//
//  Created by dan4 on 09.08.2022.
//

import SwiftUI
import CoreData

struct TaskListView: View {
    @ObservedObject private var storage = MainController()
    @State var title = ""
    @State var newTaskName: String = ""
    @State var isNewTaskCellShown: Bool = false
    @FocusState private var isFocusedNewTaskTextField: Bool
    @State private var selection: Task.ID?
    
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
                            storage.saveTasks()
                        }
                        isNewTaskCellShown = false
                        isFocusedNewTaskTextField = false
                    }
            }
        }
    }
    
    var body: some View {
        
        
        ZStack {
            List () {
                ForEach ($storage.tasks) { $item in
                    SelectionCell(item: $item, selectedItem: $selection)
                        .onTapGesture {
                            if let ndx = storage.tasks.firstIndex(where: { $0.id == selection}) {
                                storage.tasks[ndx].isDone = false
                        }
                        selection = item.id
                            item.isDone = true
                    }
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
            .listStyle(.plain)
//            .toolbar {EditButton()}
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
        .onAppear(perform: storage.loadTasks)
    }
    
    private func removeItems(at offset: IndexSet) {
        storage.tasks.remove(atOffsets: offset)
        storage.saveTasks()
    }
}

struct SelectionCell: View {

    @Binding var item: Task
    @Binding var selectedItem: Task.ID?

    var body: some View {
        HStack {
            Text(item.name)
            Spacer()
            if item.id == selectedItem {
                Image(systemName: "checkmark")
                    .foregroundColor(.accentColor)
            }
        }
    }
}
