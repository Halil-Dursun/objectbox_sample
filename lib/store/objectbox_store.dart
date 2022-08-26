
import 'package:task_manager/model/task_item_model.dart';
import 'package:task_manager/model/task_model.dart';
import 'package:task_manager/objectbox.g.dart';

class ObjectboxStore{
  late final Store _store;
  late final Box<TaskModel> _taskBox;
  late final Box<TaskItemModel> _taskItemBox;

  Box<TaskModel> get taskBox => _taskBox;

  ObjectboxStore._init(this._store){
    _taskBox = Box<TaskModel>(_store);
    _taskItemBox = Box<TaskItemModel>(_store);
  }
  static Future<ObjectboxStore> init() async{
    final store = await openStore();
    return ObjectboxStore._init(store);
  }

  int insertTask(TaskModel task) => _taskBox.put(task);
  bool deleteTask(int id) => _taskBox.remove(id);
  Stream<List<TaskModel>> getTasks() => _taskBox.query().watch(triggerImmediately: true).map((query)=> query.find());

  int insertTaskItem(TaskItemModel taskItem) => _taskItemBox.put(taskItem);
  bool deleteTaskItem(int id) => _taskItemBox.remove(id);
}