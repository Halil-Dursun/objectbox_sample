import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/main.dart';
import 'package:task_manager/model/task_model.dart';

class HomePageController extends GetxController{
 Rx<DateTime?> selectedDate= DateTime.now().obs;
 TextEditingController descriptionController = TextEditingController();

 Future<void> saveTask() async{
  objectBox.insertTask(TaskModel(description: descriptionController.text, taskDate: (selectedDate.value as DateTime)));
  Get.snackbar("Kayıt Başarılı.", "Ekleme başarılı.",backgroundColor: Colors.green);
 }
}