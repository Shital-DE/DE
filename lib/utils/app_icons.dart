// Author : Shital Gayakwad
// Created Date : March 2023
// Description : ERPX_PPC -> App Icons

import 'package:flutter/material.dart';

class MyIconGenerator {
  static Icon getIcon(
      {required String name, required Color iconColor, double size = 30}) {
    switch (name) {
      case 'Production_common':
        return Icon(
          Icons.apps,
          color: iconColor,
        );
      case 'Production_package':
        return Icon(
          Icons.add_home_work,
          color: iconColor,
        );
      case 'Outsource_product':
        return Icon(
          Icons.arrow_upward,
          color: iconColor,
          size: size,
        );
      case 'Challan-PDF':
        return Icon(
          Icons.picture_as_pdf_sharp,
          color: iconColor,
          size: size,
        );

      case 'Capacity_plan':
        return Icon(
          Icons.production_quantity_limits_outlined,
          color: iconColor,
        );
      case 'Capacity plan':
        return Icon(
          Icons.calendar_month_sharp,
          color: iconColor,
          size: size,
        );
      case 'Product Route':
        return Icon(
          Icons.roundabout_left_outlined,
          color: iconColor,
          size: size,
        );
      case 'Upload product details':
        return Icon(
          Icons.upload_file_sharp,
          color: iconColor,
          size: size,
        );
      case 'Quality Inspection Status':
        return Icon(
          Icons.inventory_sharp,
          color: iconColor,
          size: size,
        );
      case 'Machine Status':
        return Icon(
          Icons.area_chart_outlined,
          color: iconColor,
          size: size,
        );
      case 'Outsource':
        return Icon(
          Icons.data_exploration_rounded,
          color: iconColor,
          size: size,
        );
      case 'Document':
        return Icon(
          Icons.document_scanner_sharp,
          color: iconColor,
        );
      case 'Registration':
        return Icon(
          Icons.edit_note_sharp,
          color: iconColor,
        );
      case 'Efficiency':
        return Icon(
          Icons.bar_chart_rounded,
          color: iconColor,
        );
      case 'Product_Route':
        return Icon(
          Icons.roundabout_right,
          color: iconColor,
        );
      case 'QC_Dashboard':
        return Icon(
          Icons.checklist_rtl_sharp,
          color: iconColor,
        );
      case 'back':
        return Icon(
          Icons.arrow_back_ios_new_sharp,
          color: iconColor,
        );
      case 'tablet':
        return const Icon(
          Icons.tablet_android,
          // color: iconColor,
        );
      case 'machine':
        return const Icon(
          Icons.precision_manufacturing,
          // color: iconColor,
        );
      case 'employee':
        return const Icon(
          Icons.person,
          // color: iconColor,
        );
      case 'delete':
        return Icon(
          Icons.delete,
          color: iconColor,
        );
      case 'add':
        return Icon(
          Icons.add,
          color: iconColor,
        );
      case 'dashboard':
        return const Icon(
          Icons.dashboard,
          // color: iconColor,
        );
      case 'status':
        return const Icon(
          Icons.work_history,
          // color: iconColor,
        );
      case 'Cutting':
        return Icon(
          Icons.cut_sharp,
          color: iconColor,
        );
      case 'Production':
        return Icon(
          Icons.precision_manufacturing,
          color: iconColor,
        );
      case 'PPC':
        return Icon(
          Icons.next_plan,
          color: iconColor,
        );
      case 'Packing Dashboard':
        return Icon(
          Icons.add_card,
          color: iconColor,
        );

      case 'QC Dashboard':
        return Icon(
          Icons.add_task_sharp,
          color: iconColor,
        );

      case 'Operator  Dashboard':
        return Icon(
          Icons.precision_manufacturing,
          color: iconColor,
        );
      case 'User':
        return Icon(
          Icons.account_box_rounded,
          color: iconColor,
        );
      case 'Register folder':
        return Icon(
          Icons.folder,
          color: iconColor,
          size: 40,
        );
      case 'Employee registration':
        return Icon(
          Icons.person_add_alt_sharp,
          color: iconColor,
        );
      case 'Employee Registration':
        return Icon(
          Icons.person_add_alt_sharp,
          color: iconColor,
        );
      case 'Assign login credentials':
        return Icon(
          Icons.security,
          color: iconColor,
          size: 40,
        );
      case 'Register role':
        return Icon(
          Icons.person_pin,
          color: iconColor,
          size: 40,
        );
      case 'Assign user role':
        return Icon(
          Icons.edit_note_sharp,
          color: iconColor,
          size: 40,
        );
      case 'Register program':
        return Icon(
          Icons.note_add,
          color: iconColor,
          size: 40,
        );
      case 'Add program to folder':
        return Icon(
          Icons.create_new_folder,
          color: iconColor,
          size: 40,
        );
      case 'Assign program to role':
        return Icon(
          Icons.snippet_folder_rounded,
          color: iconColor,
          size: 40,
        );
      case 'Dashboard':
        return Icon(
          Icons.dashboard,
          color: iconColor,
        );
      case 'Machine Registration':
        return Icon(
          Icons.precision_manufacturing,
          color: iconColor,
        );
      case 'Tablet Registration':
        return Icon(
          Icons.tablet_mac_rounded,
          color: iconColor,
        );
      case 'Subcontractor Registration':
        return Icon(
          Icons.person,
          color: iconColor,
        );
      case 'CP Execution':
        return Icon(
          Icons.assignment_turned_in,
          color: iconColor,
        );
      case 'New CP':
        return Icon(
          Icons.assignment,
          color: iconColor,
        );
      case 'Update CP':
        return Icon(
          Icons.assignment_add,
          color: iconColor,
        );
      case 'PO Date Change':
        return Icon(
          Icons.calendar_month,
          color: iconColor,
        );
      case 'Workcentre Shift':
        return Icon(
          Icons.access_time,
          color: iconColor,
        );
      case 'Personal Information':
        return Icon(
          Icons.person,
          color: iconColor,
        );
      case 'Employee Address':
        return Icon(
          Icons.home,
          color: iconColor,
        );
      case 'Employee Documents':
        return Icon(
          Icons.edit_document,
          color: iconColor,
        );
      case 'Employment Information':
        return Icon(
          Icons.person_add,
          color: iconColor,
        );

      case 'Run time Master manual':
        return Icon(
          Icons.access_time,
          color: iconColor,
        );

      case 'Production related registration':
        return Icon(
          Icons.app_registration,
          color: iconColor,
        );

      case 'Upload programs':
        return Icon(
          Icons.cloud_upload,
          color: iconColor,
        );
      case 'Unverified programs':
        return Icon(
          Icons.pending_actions,
          color: iconColor,
        );
      case 'Verified programs':
        return Icon(
          Icons.check_circle,
          color: iconColor,
        );
      case 'Program converter':
        return Icon(
          Icons.conveyor_belt,
          color: iconColor,
        );

      case 'Subcontractor-Process':
        return Icon(
          Icons.edit_note,
          color: iconColor,
          size: size,
        );
      case 'Inward':
        return Icon(
          Icons.arrow_downward,
          color: iconColor,
          size: size,
        );
      case 'Calibration':
        return Icon(
          Icons.build_rounded,
          color: iconColor,
          size: size,
        );
      case 'Instruments Registration':
        return Icon(
          Icons.library_add,
          color: iconColor,
          size: size,
        );
      case 'Schedule Calibration':
        return Icon(
          Icons.history,
          color: iconColor,
          size: size,
        );
      case 'Instrument Type Registration':
        return Icon(
          Icons.device_hub,
          color: iconColor,
          size: size,
        );
      case 'Stock':
        return Icon(
          Icons.trending_up_outlined,
          color: iconColor,
          size: size,
        );
      case 'Calibration Status':
        return Icon(
          Icons.timeline,
          color: iconColor,
          size: size,
        );
      case 'Order Instrument':
        return Icon(
          Icons.mail,
          color: iconColor,
          size: size,
        );
      case 'All Orders':
        return Icon(
          Icons.mark_email_read_outlined,
          color: iconColor,
          size: size,
        );
      case 'Outward instruments':
        return Icon(
          Icons.build_circle_outlined,
          color: iconColor,
          size: size,
        );
      case 'Inward instruments':
        return Icon(
          Icons.shopping_cart,
          color: iconColor,
          size: size,
        );
      case 'Outsource workorders':
        return Icon(
          Icons.work_history,
          color: iconColor,
          size: size,
        );
      case 'Instruments Log':
        return Icon(
          Icons.history_toggle_off_outlined,
          color: iconColor,
          size: size,
        );
      case 'Quality':
        return Icon(
          Icons.paste_rounded,
          color: iconColor,
          size: size,
        );
      case 'Overtime':
        return Icon(
          Icons.timer,
          color: iconColor,
          size: size,
        );

      case 'Employee Overtime':
        return Icon(
          Icons.timer,
          color: iconColor,
          size: size,
        );

      case 'Account':
        return Icon(
          Icons.attach_money,
          color: iconColor,
          size: size,
        );
      case 'New Production Product':
        return Icon(
          Icons.new_releases,
          color: iconColor,
          size: size,
        );
      case 'Common Reports':
        return Icon(
          Icons.note_add,
          color: iconColor,
          size: size,
        );
      case 'Bulk Mails':
        return Icon(
          Icons.mail,
          color: iconColor,
          size: size,
        );
      case 'Program access management':
        return Icon(
          Icons.account_tree,
          color: iconColor,
          size: size,
        );
      case 'Mail':
        return Icon(
          Icons.mail,
          color: iconColor,
          size: size,
        );
      case 'Documents':
        return Icon(
          Icons.folder,
          color: iconColor,
          size: size,
        );
      case 'User modules':
        return Icon(
          Icons.person,
          color: iconColor,
          size: size,
        );
      case 'Update employee details':
        return Icon(
          Icons.person,
          color: iconColor,
          size: size,
        );

      case 'Product dashboard':
        return Icon(
          Icons.gradient_sharp,
          color: iconColor,
          size: size,
        );

      case 'Product registration':
        return Icon(
          Icons.add_to_photos_rounded,
          color: iconColor,
          size: size,
        );

      case 'Product structure':
        return Icon(
          Icons.account_tree,
          color: iconColor,
          size: size,
        );

      case 'Sales orders':
        return Icon(
          Icons.receipt_long_outlined,
          color: iconColor,
          size: size,
        );

      case 'Product inventory':
        return Icon(
          Icons.inventory_2,
          color: iconColor,
          size: size,
        );
      default:
        return const Icon(Icons.error_outline);
    }
  }
}
