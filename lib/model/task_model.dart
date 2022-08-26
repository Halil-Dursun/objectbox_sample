import "package:objectbox/objectbox.dart";
import 'package:task_manager/model/task_item_model.dart';

@Entity()
class TaskModel {
  int id = 0;
  String description;
  @Property(type: PropertyType.date)
  DateTime taskDate;

  @Backlink()
  final taskItems = ToMany<TaskItemModel>();

  TaskModel({
    required this.description,
    required this.taskDate,
  });
}
