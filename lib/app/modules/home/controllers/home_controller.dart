import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../firebase_constants.dart';
import '../../../models/employee_model.dart';
import '../../../utils/snackbars.dart';

class HomeController extends GetxController {
  RxList employeeList = <Employee>[].obs;

  var nameC = TextEditingController();
  var roleC = TextEditingController();
  var imageUrlC = TextEditingController();

  Future<void> fetchAllEmployees() async {
    try {
      QuerySnapshot snapshot = await firestore.collection('employees').get();
      employeeList.clear();
      for (var employee in snapshot.docs) {
        employeeList.add(Employee(
            id: employee.id,
            name: employee['name'],
            role: employee['role'],
            imageUrl: employee['image_url']));
      }
      update();
    } on FirebaseException catch (error) {
      messageWithError(error);
    } catch (_) {
      unexpectedError();
    }
  }

  Future<void> editEmployee(String id) async {
    try {
      await firestore.collection('employees').doc(id).update({
        'name': nameC.text,
        'role': roleC.text,
        'image_url': imageUrlC.text
      });
      await fetchAllEmployees();
      Get.back();
    } on FirebaseException catch (error) {
      messageWithError(error);
    } catch (_) {
      unexpectedError();
    }
  }

  Future<void> addEmployee() async {
    try {
      await firestore.collection('employees').add({
        'name': nameC.text,
        'role': roleC.text,
        'image_url': imageUrlC.text
      });
      clearTextControllers();
      await fetchAllEmployees();
      Get.back();
    } on FirebaseException catch (error) {
      messageWithError(error);
    } catch (_) {
      unexpectedError();
    }
  }

  Future<void> deleteEmployee(String id) async {
    Get.defaultDialog(
      radius: 8,
      title: 'Warning',
      middleText: 'Do you want to delete?',
      actions: [
        ElevatedButton(
          onPressed: () async {
            Get.back();
            await firestore.collection('employees').doc(id).delete();
            await fetchAllEmployees();
          },
          child: const Text('Yes'),
        ),
        ElevatedButton(
          onPressed: () => Get.back(),
          child: const Text('No'),
        ),
      ],
    );
  }

  clearTextControllers() {
    nameC.clear();
    roleC.clear();
    imageUrlC.clear();
  }

  @override
  void onInit() {
    fetchAllEmployees();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
