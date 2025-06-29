//
//  TodoStore.swift
//  SwiftUITutorial010
//
//  Created by Mason Sun on 2024/12/18.
//

import Foundation

// 持久化
// 用户做了某些操作之后, 下次打开 App 时依然存在
// 1. 这个操作一般会交给后台 (backend), 然后用户做了某些需要持久化的操作之后, 你直接调用后台的 API 就好了
//    打开 App 时需要先调用 API 拿到用户之前的数据, 才可以看到之前的操作
// 网络游戏: 在游戏中所有的操作都是会存到后台的, 没有网我们就没办法玩游戏 (因为拿不到数据)
//
//
// 2. 在手机的硬盘中存储数据 (或者存到 iCloud)
// 单机游戏: 每次数据都放到硬盘上 (iOS 沙盒)
// 沙盒 vs iCould
// 沙盒: 用户下载 App 后, iPhone 会给 app 一个小盒子 (你可以将数据存里面)
//      删除 App 后, 这个盒子也就不见了 (就像单机游戏一样)
// iCould: 用户下载 App 后, 存储的数据会被转移到 iCloud 上 (也就是相当于有个小服务器, 类似于网络游戏了)
//         即便用户删除了 App, 依然可以通过从 iCloud 中获取数据
//         还有个好处, 我们的 Mac/iPad/iPhone 可以都一起访问这个服务器
// CoreData Apple 推出的一个框架, 一个关系型数据库
//
// UserDefault: 使用起来很方便, 但不适合存复杂的数据结构 (效率不是很高, 同时有存储上线, 如果你存的的数据太大, 会导致存储实效)
//              Bool: 用户是否看过新手引导, 用户是否开启了 darkMode 等等 (用户偏好设置等)
//
// 如何用 FileManger 去存取数据 (也是操作沙盒中的文件来实现数据存储的)
// 想存一个视频/图片/文件等
//




// CoreData:
// ObservableObject (17 之前) 和 @Observale (17 之后)
// 17 之前: 我们需要手动创建表(数据库中的 Table), 在表中去对维护字段, 同时 Model 是遵守了 ObservableObject
// 17 之后: SwiftData, 底层也是使用的 CoreData 同时用 @Observale
//

/*
@Observable // swift macro
class TodoStore {
    // 变更这个数组的时候, 并没有做持久化的操作
    var todos: [Todo] = [] {
        // 每次数组中的数据发生变化的时候, 我们的 didSet 都会触发
        didSet {
            // 自动存档的操作
            saveTodos()
        }
    }
    
    init() {
//        todos = [
//            .init(emoji: "⌨️", title: "写代码", dueDate: .now, isDone: false),
//            .init(emoji: "📚", title: "读书", dueDate: .now, isDone: false),
//            .init(emoji: "🏊‍♀️", title: "去游泳", dueDate: .now, isDone: false),
//        ]
        // 用户打开 App 的时候, 去获取 todos (从沙盒中读取数据)
        loadTodos()
    }
    
    // 将 todos 保存到沙盒中
    func saveTodos() {
        // 1. todos, 2. key: 沙盒中 todos 的名字
        // 将 todos 变为可存储的数据, Data (数据), Bool, String, [Int], [String]
        // 把 todos 变成 Data
        do {
            let todoData = try JSONEncoder().encode(todos)
            // 使用 FileManger 创建一个文件
//            UserDefaults.standard.set(todoData, forKey: "Todos")
//            let url1 = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            let url = URL.documentsDirectory.appending(path: "Todos")
            print("\(url)")
            try todoData.write(to: url)
        } catch {
            print(error)
        }
    }
    
    // 从沙盒中取 todos
    func loadTodos() {
        // 从沙盒文件中获取 todoData
        let url = URL.documentsDirectory.appending(path: "Todos")
        do {
            let todoData = try Data(contentsOf: url)
            let todos = try JSONDecoder().decode([Todo].self, from: todoData)
            self.todos = todos
        } catch {
            print(error)
        }
    }
    
    func clearAllData() {
        // 清空数组中的数据
//        todos.removeAll()
        let url = URL.documentsDirectory.appending(path: "Todos")
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print(error)
        }
    }
    
    func add(todo: Todo) {
        todos.append(todo)
    }
    
    func update(todo: Todo) {
        // 找到已存在的 todo 的 index
        guard let index = todos.firstIndex(where: { $0.id == todo.id }) else {
            return
        }
        todos[index] = todo
    }
    
    func delete(todo: Todo) {
        // 找到已存在的 todo 的 index
        guard let index = todos.firstIndex(where: { $0.id == todo.id }) else {
            return
        }
        todos.remove(at: index)
    }
    
    func moveTodos(fromOffsets: IndexSet, toOffset: Int) {
        todos.move(
            fromOffsets: fromOffsets,
            toOffset: toOffset
        )
    }
    
    // 找到 store 中的某条 todo, 然后把 isDone 设置成 true
    // 如果是 true 的话就改为 false
    func toggleTodoDone(id: UUID) {
        let index = todos.firstIndex(where: {
            // 通过某个值去找到 todos 中的这条数据的 index
            $0.id == id
        })
        // 如果找到 todo 的话
        if let index {
            var todo = todos[index]
            // 切换 isDone: 如果是 ture 改为 false, 否则改为 ture
            todo.isDone.toggle()
            todos[index] = todo
        }
    }
}
*/


/*
 xxxxx
 xxxx
 x
 xxx
 */
