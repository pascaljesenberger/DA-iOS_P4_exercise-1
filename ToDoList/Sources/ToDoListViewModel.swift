import SwiftUI

final class ToDoListViewModel: ObservableObject {
    // MARK: - Private properties
    private let repository: ToDoListRepositoryType
    private var allToDoItems: [ToDoItem] = [] // Store all items unfiltered

    // MARK: - Init
    init(repository: ToDoListRepositoryType) {
        self.repository = repository
        self.allToDoItems = repository.loadToDoItems()
        self.toDoItems = allToDoItems
    }

    // MARK: - Outputs
    @Published var toDoItems: [ToDoItem] = [] {
        didSet {
            repository.saveToDoItems(toDoItems)
        }
    }

    // MARK: - Inputs
    func add(item: ToDoItem) {
        allToDoItems.append(item)
        toDoItems.append(item)
    }

    func toggleTodoItemCompletion(_ item: ToDoItem) {
        if let index = allToDoItems.firstIndex(where: { $0.id == item.id }) {
            allToDoItems[index].isDone.toggle()
            applyFilter(at: 0) // Reapply current filter
        }
    }

    func removeTodoItem(_ item: ToDoItem) {
        allToDoItems.removeAll { $0.id == item.id }
        toDoItems.removeAll { $0.id == item.id }
    }

    func applyFilter(at index: Int) {
        switch index {
        case 0: // All ToDoitems
            toDoItems = allToDoItems
        case 1: // Done ToDoitems
            toDoItems = allToDoItems.filter { $0.isDone }
        case 2: // Not done ToDoitems
            toDoItems = allToDoItems.filter { !$0.isDone }
        default:
            break
        }
    }
}
