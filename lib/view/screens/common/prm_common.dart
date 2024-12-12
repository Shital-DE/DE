// Author : Shital Gayakwad
// Created date : 14 Oct 2023
// Description : Product resource managements common widgets
// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;
import '../../../bloc/ppc/product_resource_management/product_resource_management_bloc.dart';
import '../../../bloc/ppc/product_resource_management/product_resource_management_event.dart';
import '../../../services/repository/common/documents_repository.dart';
import '../../../services/repository/product/product_repository.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/common/quickfix_widget.dart';
import 'documents.dart';

class ProgramsVerificationCommon {
  Future<void> viewMachineProgramsFromDatabase(
      {required String token,
      required String mdocId,
      required String remark,
      required String product,
      required BuildContext context}) async {
    if (mdocId != 'null') {
      final docData = await DocumentsRepository().documents(token, mdocId);
      if (docData != null) {
        String filePath = remark.replaceAll(r'\', '/');
        String fileName = path.basename(filePath);
        String fileExtension = path.extension(remark);
        final String dirpath =
            (await path_provider.getApplicationSupportDirectory()).path;
        final String vertualfilename = '$dirpath/$fileName.$fileExtension';
        final File file = File(vertualfilename);
        final data = base64.decode(docData);
        await file.writeAsBytes(data, flush: true);
        String content = await file.readAsString();
        if (Platform.isAndroid) {
          QuickFixUi().readTextFile(
              context: context, content: content, filename: fileName);
        } else {
          Documents().models(
              docData, product, remark, fileExtension.replaceAll('.', ''));
        }
      }
    } else {
      QuickFixUi.errorMessage('Program not found.', context);
    }
  }

  IconButton deleteProgramButton(
      {required BuildContext context,
      required String token,
      required String pdProductFolderTableId,
      required String mdocId,
      required ProductResourceManagementBloc blocProvider,
      required int index}) {
    return IconButton(
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                content: const SizedBox(
                  height: 20,
                  child: Center(
                    child: Text(
                      'Do you want to delete it?',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                actions: [
                  ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                            Theme.of(context).colorScheme.error),
                      ),
                      onPressed: () async {
                        String response = await ProductRepository()
                            .deleteProgramFiles(token: token, payload: {
                          'postgresql_id': pdProductFolderTableId,
                          'mongodb_id': mdocId
                        });
                        if (response == 'Deleted successfully') {
                          Navigator.of(context).pop();
                          if (index == 0) {
                            blocProvider.add(VerifyMachineProgramEvent());
                          } else {
                            blocProvider.add(VerifiedMachineProgramEvent());
                          }
                          QuickFixUi.successMessage(
                              'Program deleted.', context);
                        }
                      },
                      child: const Text(
                        'Yes',
                        style: TextStyle(
                            color: AppColors.whiteTheme,
                            fontWeight: FontWeight.bold),
                      )),
                  ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                            AppColors.greenTheme),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'No',
                        style: TextStyle(
                            color: AppColors.whiteTheme,
                            fontWeight: FontWeight.bold),
                      ))
                ],
              );
            },
          );
        },
        icon: Icon(
          Icons.delete,
          color: Theme.of(context).colorScheme.error,
          size: 22,
        ));
  }
}
