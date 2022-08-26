

import 'package:objectbox/objectbox.dart';
import 'package:task_manager/model/task_model.dart';

@Entity()
class TaskItemModel {
  int id = 0;
  String itemName;
  String itemDescription;
  @Property(type: PropertyType.date)
  DateTime itemDateTime;
  
  final taskModel = ToOne<TaskModel>();

  TaskItemModel({
    required this.itemName,
    required this.itemDescription,
    required this.itemDateTime,
  });
}
