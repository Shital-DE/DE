// Author : Shital Gayakwad
// Description : ERPX_PPC -> App routes

import 'package:flutter/material.dart';
import 'route_data.dart';
import 'route_names.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    Map<String, dynamic>? args = settings.arguments as Map<String, dynamic>?;
    switch (settings.name) {
      case RouteName.login:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                RouteData.getRouteData(context, RouteName.login, {}));

      case RouteName.dashboard:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                RouteData.getRouteData(context, RouteName.dashboard, {}));

      case RouteName.splash:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                RouteData.getRouteData(context, RouteName.splash, {}));

      //Documents
      case RouteName.documents:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                RouteData.getRouteData(context, RouteName.documents, {}));

      //Production
      case RouteName.barcodeScan:
        return MaterialPageRoute(
            builder: (BuildContext context) => RouteData.getRouteData(
                context, RouteName.barcodeScan, args!)); // barcode scan

      case RouteName.production:
        return MaterialPageRoute(
            builder: (BuildContext context) => RouteData.getRouteData(
                context, RouteName.production, args!)); // production dashboard

      case RouteName.productionAutomatic:
        return MaterialPageRoute(
            builder: (BuildContext context) => RouteData.getRouteData(
                context, RouteName.productionAutomatic, args!));

      case RouteName.operatorAutoProduction:
        return MaterialPageRoute(
            builder: (BuildContext context) => RouteData.getRouteData(context,
                RouteName.operatorAutoProduction, args!)); //Operator automatic

      case RouteName.operatorManualProduction:
        return MaterialPageRoute(
            builder: (BuildContext context) => RouteData.getRouteData(context,
                RouteName.operatorManualProduction, args!)); // Operator manual

      case RouteName.productionManual:
        return MaterialPageRoute(
            builder: (BuildContext context) => RouteData.getRouteData(
                context, RouteName.productionManual, args!)); // Operator manual

      case RouteName.pendingProduction:
        return MaterialPageRoute(
            builder: (BuildContext context) => RouteData.getRouteData(context,
                RouteName.pendingProduction, args!)); // Operator manual

      case RouteName.machineProgramSequance:
        return MaterialPageRoute(
            builder: (BuildContext context) => RouteData.getRouteData(
                context, RouteName.machineProgramSequance, args!));
      // Cutting
      case RouteName.cuttingScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => RouteData.getRouteData(context,
                RouteName.cuttingScreen, args!)); // Cutting production screen

      case RouteName.cuttingProductionProcessScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => RouteData.getRouteData(
                context,
                RouteName.cuttingProductionProcessScreen,
                args!)); // Cutting process screen

      case RouteName.overtime:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                RouteData.getRouteData(context, RouteName.overtime, {}));

      // Quality
      case RouteName.qualityScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => RouteData.getRouteData(context,
                RouteName.qualityScreen, args!)); // Quality production screen

      case RouteName.qualityProductionProcessScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => RouteData.getRouteData(
                context,
                RouteName.qualityProductionProcessScreen,
                args!)); // Quality production process screen

      case RouteName.calibration: // Calibration screen
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                RouteData.getRouteData(context, RouteName.calibration, {}));

      case RouteName.instrumentRegistration: // Instrument registration
        return MaterialPageRoute(
            builder: (BuildContext context) => RouteData.getRouteData(
                context, RouteName.instrumentRegistration, {}));

      case RouteName.instrumentTypeRegistration: // Instrument registration
        return MaterialPageRoute(
            builder: (BuildContext context) => RouteData.getRouteData(
                context, RouteName.instrumentTypeRegistration, {}));

      case RouteName
            .calibrationScheduleRegistration: // Calibration schedule registration
        return MaterialPageRoute(
            builder: (BuildContext context) => RouteData.getRouteData(
                context, RouteName.calibrationScheduleRegistration, {}));

      case RouteName.calibrationStatus: // Calibration status
        return MaterialPageRoute(
            builder: (BuildContext context) => RouteData.getRouteData(
                context, RouteName.calibrationStatus, {}));

      case RouteName.orderInstrument: // Order Instrument
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                RouteData.getRouteData(context, RouteName.orderInstrument, {}));

      case RouteName.allInstrumentOrders: // Instrument orders
        return MaterialPageRoute(
            builder: (BuildContext context) => RouteData.getRouteData(
                context, RouteName.allInstrumentOrders, {}));

      case RouteName.outwardInstruments: // Instrument orders
        return MaterialPageRoute(
            builder: (BuildContext context) => RouteData.getRouteData(
                context, RouteName.outwardInstruments, args!));

      case RouteName.inwardInstruments: // Instrument orders
        return MaterialPageRoute(
            builder: (BuildContext context) => RouteData.getRouteData(
                context, RouteName.inwardInstruments, {}));

      case RouteName.pdf: // PDF view
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                RouteData.getRouteData(context, RouteName.pdf, args!));

      case RouteName.viewpdf: // PDF view
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                RouteData.getRouteData(context, RouteName.viewpdf, args!));

      case RouteName
            .instrumentOutsourceWorkorder: // Instrument outsource workorders
        return MaterialPageRoute(
            builder: (BuildContext context) => RouteData.getRouteData(
                context, RouteName.instrumentOutsourceWorkorder, args!));

      case RouteName.calibrationHistory: // Instrument calibration history
        return MaterialPageRoute(
            builder: (BuildContext context) => RouteData.getRouteData(
                context, RouteName.calibrationHistory, args!));

      case RouteName.instrumentStore: // Instrument store
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                RouteData.getRouteData(context, RouteName.instrumentStore, {}));

      case RouteName.rejectedInstruments: // Instrument calibration history
        return MaterialPageRoute(
            builder: (BuildContext context) => RouteData.getRouteData(
                context, RouteName.rejectedInstruments, {}));

      // Packing
      case RouteName.packingProductionScreen: // Packing production screen
        return MaterialPageRoute(
            builder: (BuildContext context) => RouteData.getRouteData(
                context, RouteName.packingProductionScreen, args!));

      case RouteName.packingProcessesScreen: // Packing process screen
        return MaterialPageRoute(
            builder: (BuildContext context) => RouteData.getRouteData(
                context, RouteName.packingProcessesScreen, args!));

      // Stock
      case RouteName.stock:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                RouteData.getRouteData(context, RouteName.stock, {}));

      //Registration
      case RouteName.registration:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                RouteData.getRouteData(context, RouteName.registration, args!));

      case RouteName.employeeRegistration:
        return MaterialPageRoute(
            builder: (BuildContext context) => RouteData.getRouteData(context,
                RouteName.employeeRegistration, {})); // Employee registration

      case RouteName.machineRegistration:
        return MaterialPageRoute(
            builder: (BuildContext context) => RouteData.getRouteData(context,
                RouteName.machineRegistration, {})); // Machine Registration

      case RouteName.tabletRegistration:
        return MaterialPageRoute(
            builder: (BuildContext context) => RouteData.getRouteData(context,
                RouteName.tabletRegistration, {})); // Tablet Registration

      case RouteName.subcontractorRegistration:
        return MaterialPageRoute(
            builder: (BuildContext context) => RouteData.getRouteData(
                context, RouteName.subcontractorRegistration, {}));

      case RouteName.programsAssignedToRoles: // Programs are assigned to roles
        return MaterialPageRoute(
            builder: (BuildContext context) => RouteData.getRouteData(
                context, RouteName.programsAssignedToRoles, {}));

      case RouteName.updateEmployeeDetails: // Update employee details
        return MaterialPageRoute(
            builder: (BuildContext context) => RouteData.getRouteData(
                context, RouteName.updateEmployeeDetails, {}));

      //PPC
      case RouteName.machinestatus:
        return MaterialPageRoute(
            builder: (BuildContext context) => RouteData.getRouteData(
                context, RouteName.machinestatus, {})); //Machine Status

      case RouteName.uploadproductdetails:
        return MaterialPageRoute(
            builder: (BuildContext context) => RouteData.getRouteData(context,
                RouteName.uploadproductdetails, {})); // Upload product details

      case RouteName.verifyMachinePrograms:
        return MaterialPageRoute(
            builder: (BuildContext context) => RouteData.getRouteData(
                context,
                RouteName.verifyMachinePrograms,
                {})); // Verify machine programs

      case RouteName.verifiedMachinePrograms:
        return MaterialPageRoute(
            builder: (BuildContext context) => RouteData.getRouteData(
                context,
                RouteName.verifiedMachinePrograms,
                {})); // Verified machine programs

      case RouteName.programsconverter:
        return MaterialPageRoute(
            builder: (BuildContext context) => RouteData.getRouteData(
                context, RouteName.programsconverter, {}));

      case RouteName.newproductionproduct:
        return MaterialPageRoute(
            builder: (BuildContext context) => RouteData.getRouteData(
                context, RouteName.newproductionproduct, {}));

      case RouteName.productProcessRoute:
        return MaterialPageRoute(
            builder: (BuildContext context) => RouteData.getRouteData(
                context,
                RouteName.productProcessRoute,
                {})); // Product and process route

      //Capacity plan
      case RouteName.cpDragAndDrop:
        return MaterialPageRoute(
            builder: (BuildContext context) => RouteData.getRouteData(
                context, RouteName.cpDragAndDrop, {})); // Drag and Drop

      case RouteName.capacityPlan:
        return MaterialPageRoute(
            builder: (BuildContext context) => RouteData.getRouteData(
                context, RouteName.capacityPlan, {})); // Capacity dashboard

      case RouteName.newCpPlan:
        return MaterialPageRoute(
            builder: (BuildContext context) => RouteData.getRouteData(
                context, RouteName.newCpPlan, {})); // New capacity plan

      case RouteName.cpBarChart:
        return MaterialPageRoute(
            builder: (BuildContext context) => RouteData.getRouteData(
                context, RouteName.cpBarChart, {})); // CP Bar Chart

      case RouteName.outsourceDashboard:
        return MaterialPageRoute(
            builder: (BuildContext context) => RouteData.getRouteData(
                context, RouteName.outsourceDashboard, {})); //PO Date Change

      case RouteName.outsource:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                RouteData.getRouteData(context, RouteName.outsource, {}));

      case RouteName.machinedashboard:
        return MaterialPageRoute(
            builder: (BuildContext context) => RouteData.getRouteData(
                context, RouteName.machinedashboard, args!));

      case RouteName.admindashboard:
        return MaterialPageRoute(
            builder: (BuildContext context) => RouteData.getRouteData(
                context, RouteName.admindashboard, args!));

      case RouteName.dashboardUtility:
        return MaterialPageRoute(
            builder: (BuildContext context) => RouteData.getRouteData(
                context, RouteName.dashboardUtility, args ?? {}));

      //Common mail mailmodule
      case RouteName.mailmodule:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                RouteData.getRouteData(context, RouteName.mailmodule, {}));

      // Product assets management
      case RouteName.productAssetsManagementScreen: // Dashboard
        return MaterialPageRoute(
            builder: (BuildContext context) => RouteData.getRouteData(
                context, RouteName.productAssetsManagementScreen, {}));

      case RouteName.productRegistration: // Product registration
        return MaterialPageRoute(
            builder: (BuildContext context) => RouteData.getRouteData(
                context, RouteName.productRegistration, {}));

      case RouteName.productStructure: // Product structure
        return MaterialPageRoute(
            builder: (BuildContext context) => RouteData.getRouteData(
                context, RouteName.productStructure, {}));

      case RouteName
            .productInventoryManagementScreen: // Product inventory management screen
        return MaterialPageRoute(
            builder: (BuildContext context) => RouteData.getRouteData(
                context, RouteName.productInventoryManagementScreen, {}));

      // Sales orders
      case RouteName.assemblySalesOrders:
        return MaterialPageRoute(
            builder: (BuildContext context) => RouteData.getRouteData(
                context, RouteName.assemblySalesOrders, {}));

      // Assembly component requirement
      case RouteName.assemblyComponentRequirementsScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => RouteData.getRouteData(
                context, RouteName.assemblyComponentRequirementsScreen, args!));

      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(
              child: Text('No route defined'),
            ),
          );
        });
    }
  }
}
