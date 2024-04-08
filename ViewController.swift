import UIKit
import SnapKit

class ViewController: UIViewController {

    var tasks = [ToDoListTask]() {
        didSet {
            tableView.reloadData()
        }
    }
    let manager = CoreDataManager.shared
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ToDoCell.self, forCellReuseIdentifier: ToDoCell.cellIdentifier)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    lazy var textField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "insert task"
        textfield.borderStyle = .roundedRect
        return textfield
    }()
    
    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
        return picker
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("add task", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(addTask), for: .touchUpInside)
        return button
    }()
    
    lazy var compleatedTasksButton: UIButton = {
        let button = UIButton()
        button.setTitle("check", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(showCompletedTasks), for: .touchUpInside)

        return button
    }()
    
    @objc func addTask() {
        manager.createTask(name: textField.text!, deadline: datePicker.date)
        textField.text = ""
        getTasks()
    }
    
    
    private func getTasks() {
        self.tasks = manager.getTasks()
        print(tasks)
    }
    private func getCompletedTasks() {
        self.tasks = manager.getTasks().filter { task in
            return task.isDone
        }
        print(tasks)
    }
    @objc func showCompletedTasks() {
        getCompletedTasks()
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        getTasks()
    }
    
    private func setUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(button)
        view.addSubview(textField)
        view.addSubview(datePicker)
        view.addSubview(compleatedTasksButton)
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        textField.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(200)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        datePicker.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(textField.snp.bottom).offset(8)
        }
        
        button.snp.makeConstraints { make in
            make.leading.equalTo(datePicker.snp.trailing).offset(8)
            make.centerY.equalTo(datePicker)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(16)
            make.top.equalTo(datePicker.snp.bottom)
        }
        compleatedTasksButton.snp.makeConstraints { make in
            make.left.equalTo(button.snp.right).offset(16)
            make.top.equalTo(textField.snp.bottom).offset(8)
        }
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ToDoCell.cellIdentifier, for: indexPath) as? ToDoCell else { return UITableViewCell() }
        cell.configure(tasks[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            self?.deleteTask(at: indexPath)
            completionHandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    private func deleteTask(at indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        manager.deleteTask(task: task)
        getTasks()
    }
    
}

extension ViewController: TodoCellDelegate {
    func checkTapped(_ task: ToDoListTask?) {
        manager.updateTask(task: task!)
        getTasks()
    }
    
    
}
