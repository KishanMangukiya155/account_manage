import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controller/account_controller.dart';
import '../Controller/transaction_controller.dart';
import 'Transection.dart';

class Dashboard extends StatelessWidget {
  TextEditingController ac_nameController = TextEditingController();

  var controller = Get.put(account_controller());
  transaction_controller tc = Get.put(transaction_controller());

  Widget build(BuildContext context) {
    controller.GetDatabase()
        .then((value) => tc.GetTotaldb())
        .then((value) => controller.GetData())
        .then((value) => tc.SelectQuary());
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard"), actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
      ]),
      body: Obx(() {
        return ListOfAccount();
      }),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            AddAccountDialog();
          },
          child: const Icon(Icons.add)),
    );
  }

  Widget ListOfAccount() {
    return ListView.builder(
      itemCount: controller.DataList.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Get.to(Transection(index));
          },
          child: Card(
            child: Container(
              margin: EdgeInsets.all(10),
              height: 150,
              width: Get.width * 0.9,
              child: Column(children: [
                Row(
                  children: [
                    Text(
                      "${controller.DataList[index]['acname']}",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    IconButton(
                        onPressed: () {
                          ac_nameController.text =
                              controller.DataList[index]['acname'];
                          UpdateDialog(index);
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Color(0xff010a21),
                        )),
                    IconButton(
                        onPressed: () {
                          controller.DeleteData(
                                  index: controller.DataList[index]['id'])
                              .then((value) => tc.DeleteTable(index: index)
                                  .then((value) => controller.GetData().then(
                                      (value) => tc.DeleteAmount(
                                          tc.amount[index]['id']))))
                              .then((value) => tc.SelectQuary());
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Color(0xff010a21),
                        ))
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Credit(↑)",
                                style: TextStyle(fontSize: 18),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Obx(() => Text(
                                    "₹ ${tc.amount[index]['credit']}",
                                    style: TextStyle(fontSize: 15),
                                  ))
                            ],
                          ),
                        ),
                      )),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Debit(↓)",
                                style: TextStyle(fontSize: 18),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Obx(() => Text(
                                    "₹ ${tc.amount[index]['debit']}",
                                    style: TextStyle(fontSize: 15),
                                  ))
                            ],
                          ),
                        ),
                      )),
                      Expanded(
                          child: Container(
                        decoration: BoxDecoration(
                            color: Color(0xff000f35),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Balance",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Obx(() => Text(
                                  "₹ ${tc.amount[index]['balance']}",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white),
                                ))
                          ],
                        ),
                      ))
                    ],
                  ),
                )
              ]),
            ),
          ),
        );
      },
    );
  }

  Future AddAccountDialog() {
    return Get.defaultDialog(
        barrierDismissible: false,
        title: "",
        titleStyle: TextStyle(fontSize: 0),
        onConfirm: () {
          controller.Datainsert(name: ac_nameController.text).then((value) =>
              controller.GetData()
                  .then((value) => tc.GetTotaldb())
                  .then((value) => tc.InsertAmountData())
                  .then((value) => tc.SelectQuary()));
          ac_nameController.clear();
          Get.back();
        },
        textConfirm: "ADD",
        confirmTextColor: Colors.white,
        onCancel: () {
          ac_nameController.clear();
        },
        content: Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: 50,
              width: 300,
              decoration: BoxDecoration(
                  color: Color(0xff010a21),
                  borderRadius: BorderRadius.circular(10)),
              child: const Text("Add New Account",
                  style: TextStyle(fontSize: 25, color: Colors.white)),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 280,
              child: TextField(
                controller: ac_nameController,
                decoration: const InputDecoration(
                  labelText: "Account name",
                ),
              ),
            ),
          ],
        ));
  }

  Future UpdateDialog(int index) {
    return Get.defaultDialog(
        barrierDismissible: false,
        title: "",
        titleStyle: TextStyle(fontSize: 0),
        onConfirm: () {
          controller.UpdateData(
              updateName: '${ac_nameController.text}',
              index: controller.DataList[index]['id']);
          ac_nameController.clear();
          Get.back();
        },
        textConfirm: "SAVE",
        confirmTextColor: Colors.white,
        onCancel: () {
          ac_nameController.clear();
        },
        content: Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: 50,
              width: 300,
              decoration: BoxDecoration(
                  color: Color(0xff010a21),
                  borderRadius: BorderRadius.circular(10)),
              child: const Text("Update Account",
                  style: TextStyle(fontSize: 25, color: Colors.white)),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 280,
              child: TextField(
                controller: ac_nameController,
                decoration: const InputDecoration(labelText: "Account name"),
              ),
            ),
          ],
        ));
  }
}
