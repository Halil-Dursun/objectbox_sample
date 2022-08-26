import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/controller/home_page_controller.dart';
import 'package:task_manager/main.dart';
import 'package:task_manager/model/task_item_model.dart';
import 'package:task_manager/model/task_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Stream<List<TaskModel>> streamTasks;

  @override
  void initState() {
    super.initState();
    streamTasks = objectBox.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    HomePageController controller = Get.put(HomePageController());
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                      title: Obx(
                        () => Container(
                          width: Get.width,
                          height: Get.height * .2,
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(
                                  DateFormat('d MMM yyyy EEEE','tr_TR').format(controller.selectedDate.value as DateTime),textAlign: TextAlign.center,style: TextStyle(color: Colors.blueGrey,fontSize: 25,fontStyle: FontStyle.italic)
                                ),
                                subtitle: TextButton(
                                    onPressed: () async {
                                      controller.selectedDate.value = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime(2023),
                                      );
                                    },
                                    child: const Text("Tarih Seç")),
                              ),
                            ],
                          ),
                        ),
                      ),
                      content: Container(
                        margin: const EdgeInsets.all(5),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * .3,
                        child: Column(
                          children: [
                            TextField(
                              controller: controller.descriptionController,
                              decoration: const InputDecoration(
                                label: Text("Açıklama"),
                                border: OutlineInputBorder(),
                                fillColor: Colors.red,
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(onPressed: (){
                                controller.saveTask();
                                Navigator.of(context).pop();
                              },
                               style: ElevatedButton.styleFrom(primary: Colors.white,shape: const RoundedRectangleBorder(side: BorderSide(width: .5))),
                               child: Text("Kaydet",style: Theme.of(context).textTheme.headline5?.copyWith(color: Colors.black),),),
                            ),
                          ],
                        ),
                      ),
                    );
                });
          },
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "Tasks",
            style: Theme.of(context)
                .textTheme
                .headline4
                ?.copyWith(color: Colors.black),
          ),
        ),
        body: StreamBuilder(
            stream: streamTasks,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                final tasks = snapshot.data;
                if (tasks != null && tasks.isNotEmpty) {
                  return ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return Dismissible(
                          key: UniqueKey(),
                          background: Container(
                            padding: const EdgeInsets.only(right: 10),
                            alignment: Alignment.centerRight,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.red),
                            child: const Text("Sil",
                                style: TextStyle(color: Colors.white)),
                          ),
                          direction: DismissDirection.endToStart,
                          onDismissed: (_) {
                            objectBox.deleteTask(task.id);
                          },
                          child: InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) => Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.6,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    TaskItemModel model =
                                                        TaskItemModel(
                                                            itemName: "a",
                                                            itemDescription:
                                                                "itemDescription",
                                                            itemDateTime:
                                                                DateTime.now());
                                                    task.taskItems.add(model);
                                                    objectBox.taskBox.put(task);
                                                  },
                                                  child: const Text(
                                                    "Task Item Ekle",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                                Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: IconButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      icon: const Icon(
                                                          Icons.close)),
                                                ),
                                              ],
                                            ),
                                            Expanded(
                                              child: ListView.builder(
                                                itemCount:
                                                    task.taskItems.length,
                                                itemBuilder: (context, index) {
                                                  return ListTile(
                                                    title: Text(task
                                                        .taskItems[index]
                                                        .itemName),
                                                    subtitle: Text(task
                                                        .taskItems[index]
                                                        .itemDescription),
                                                  );
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      ));
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: ListTile(
                                title: Text(
                                  task.taskDate.toIso8601String(),
                                  style: const TextStyle(color: Colors.black),
                                ),
                                subtitle: Text(
                                  task.description,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                } else {
                  return const Center(
                    child: Text(
                      "Henüz bir görev eklemediniz",
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }
              }
            }),
      ),
    );
  }
}
