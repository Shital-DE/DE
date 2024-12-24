// Author : Shital Gayakwad
// Description : ERPX_PPC -> App routes data

import 'package:de/bloc/sales_order/sales_order_bloc.dart';
import 'package:de/view/screens/product_assets_management/pam_dashboard.dart';
import 'package:de/view/screens/product_assets_management/product_registration.dart';
import 'package:de/view/screens/product_assets_management/product_structure.dart';
import 'package:de/view/screens/production/cutting/cutting_processes_screen.dart';
import 'package:de/view/screens/production/packing/packing_processes_screen.dart';
import 'package:de/view/screens/production/quality/quality_processes_screen.dart';
import 'package:de/view/screens/user/update_employee_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/admindashboard/admindashboard_bloc.dart';
import '../bloc/appbar/appbar_bloc.dart';
import '../bloc/common_mail/mails/common_mails_bloc.dart';
import '../bloc/dashboard/dashboard_bloc.dart';
import '../bloc/documents/documents_bloc.dart';
import '../bloc/product_dashboard/product_dashboard_bloc.dart';
import '../bloc/user/login/login_bloc.dart';
import '../bloc/machinewisedashboard/machinewisedashboard_bloc.dart';
import '../bloc/ppc/Product_And_Process_Route/product_and_process_route_bloc.dart';
import '../bloc/ppc/calibration/calibration_bloc.dart';
import '../bloc/ppc/capacity_plan/bloc/capacity_bloc/capacity_plan_bloc.dart';
import '../bloc/ppc/capacity_plan/bloc/capacity_dashboard/bloc/capacity_dashboard_bloc.dart';
import '../bloc/ppc/capacity_plan/bloc/graph_bloc/graph_view_bloc.dart';
import '../bloc/ppc/capacity_plan/bloc/workstationshift_bloc/workstationshift_bloc.dart';
import '../bloc/ppc/employeeovertime/employeeovertime_bloc.dart';
import '../bloc/ppc/machine_program_conveter/program_converter_bloc.dart';
import '../bloc/ppc/machine_status/status_bloc.dart';
import '../bloc/ppc/outsource_inward/challanpdf_cubit/challanpdf_cubit.dart';
import '../bloc/ppc/outsource_inward/inward_bloc/inward_bloc.dart';
import '../bloc/ppc/outsource_inward/outsource_bloc/outsource_bloc.dart';
import '../bloc/ppc/outsource_inward/subcontractor_processcubit/cubit/subcontractor_process_cubit.dart';
import '../bloc/ppc/product_resource_management/product_resource_management_bloc.dart';
import '../bloc/production/cutting_bloc/cutting_bloc.dart';
import '../bloc/production/operator/bloc/barcodebloc/barcode_bloc.dart';
import '../bloc/production/operator/bloc/machine_program_sequance/machine_program_sequance_bloc.dart';
import '../bloc/production/operator/bloc/operator_auto_production/operatorautoproduction_bloc.dart';
import '../bloc/production/operator/bloc/operator_manual_production/operator_manual_production_bloc.dart';
import '../bloc/production/operator/bloc/pending_production/machine_pending_production_bloc.dart';
import '../bloc/production/operator/cubit/scan_cubit.dart';
import '../bloc/production/packing_bloc/packing_bloc.dart';
import '../bloc/production/production_bloc.dart';
import '../bloc/production/quality/quality_bloc.dart';
import '../bloc/user/employee_registration/employee_registration_bloc.dart';
import '../bloc/registration/machine_registration/machine_register_bloc.dart';
import '../bloc/registration/program_access_management/pam_bloc.dart';
import '../bloc/registration/registration_bloc.dart';
import '../bloc/registration/subcontractor_registration/subcontractor_bloc.dart';
import '../bloc/registration/tablet_registration/tablet_bloc.dart';
import '../bloc/user/update_employee_details/update_employee_details_bloc.dart';
import '../view/screens/common/documents.dart';
import '../view/screens/common/splash.dart';
import '../view/screens/common_mails/bulkmail.dart';
import '../view/screens/common_mails/common_mails_dashboard.dart';
import '../view/screens/dashboard/admin/admin_dashboard.dart';
import '../view/screens/dashboard/admin/dashboard_utilitis.dart';
import '../view/screens/dashboard/dashboard.dart';
import '../view/screens/dashboard/admin/machinewise_dashboard.dart';
import '../view/screens/ppc/calibration/all_intrument_orders.dart';
import '../view/screens/ppc/calibration/calibration_dashboard.dart';
import '../view/screens/ppc/calibration/calibration_history.dart';
import '../view/screens/ppc/calibration/calibration_scedule_registration.dart';
import '../view/screens/ppc/calibration/calibration_status.dart';
import '../view/screens/ppc/calibration/instrument_registration.dart';
import '../view/screens/ppc/calibration/instrument_store.dart';
import '../view/screens/ppc/calibration/instrumenttype_registration.dart';
import '../view/screens/ppc/calibration/order_instrument.dart';
import '../view/screens/ppc/calibration/outsource/instrument_outsource_workorders.dart';
import '../view/screens/ppc/calibration/outsource/inward_instruments.dart';
import '../view/screens/ppc/calibration/outsource/outward_instruments.dart';
import '../view/screens/ppc/calibration/rejected_instruments.dart';
import '../view/screens/ppc/capacity_plan/bar_chart.dart';
import '../view/screens/ppc/capacity_plan/capacity_dashboard.dart';
import '../view/screens/ppc/capacity_plan/capacity_plan.dart';
import '../view/screens/ppc/capacity_plan/drag_and_drop.dart';
import '../view/screens/ppc/employee/employee_overtime.dart';
import '../view/screens/ppc/machine_status.dart';
import '../view/screens/ppc/outsource/check_challanpdf.dart';
import '../view/screens/ppc/outsource/inward.dart';
import '../view/screens/ppc/outsource/outsource.dart';
import '../view/screens/ppc/outsource/outsource_dashboard.dart';
import '../view/screens/ppc/outsource/subcontractor_process.dart';
import '../view/screens/ppc/product/machine_program_converter.dart';
import '../view/screens/ppc/product/product_and_process_route.dart';
import '../view/screens/ppc/product/product_resource_management.dart';
import '../view/screens/ppc/product/verify_machine_programs.dart';
import '../view/screens/product_assets_management/product_inventory_management.dart';
import '../view/screens/production/cutting/cutting_screen.dart';
import '../view/screens/production/operator/barcode_scan.dart';
import '../view/screens/production/operator/machineprogramsequance.dart';
import '../view/screens/production/operator/operator_auto_production.dart';
import '../view/screens/production/operator/operator_manual_production.dart';
import '../view/screens/production/operator/pending_product_production.dart';
import '../view/screens/production/packing/packing_production_screen.dart';
import '../view/screens/production/packing/stock.dart';
import '../view/screens/production/production.dart';
import '../view/screens/production/quality/quality_production_screen.dart';
import '../view/screens/sales_orders/issue_stock.dart';
import '../view/screens/sales_orders/salesorders.dart';
import '../view/screens/user/employee_registration.dart';
import '../view/screens/registration/machine_registration.dart';
import '../view/screens/registration/program_access_management.dart';
import '../view/screens/registration/registration.dart';
import '../view/screens/registration/subcontractor_registration.dart';
import '../view/screens/registration/tablet_registration.dart';
import '../view/screens/user/user_login.dart';
import '../view/widgets/PDF/pdf.dart';
import 'route_names.dart';

class RouteData {
  static getRouteData(
      BuildContext context, String screenName, Map<String, dynamic> args) {
    switch (screenName) {
      case RouteName.login:
        return MultiBlocProvider(providers: [
          BlocProvider<LoginBloc>(
            create: (BuildContext context) => LoginBloc(context: context),
          ),
        ], child: const UserLogin());

      case RouteName.dashboard:
        return MultiBlocProvider(providers: [
          BlocProvider<AppBarBloc>(
            create: (BuildContext context) => AppBarBloc(),
          ),
          BlocProvider<DashboardBloc>(
            create: (BuildContext context) => DashboardBloc(),
          ),
          BlocProvider<PendingProductionBloc>(
              create: (BuildContext context) => PendingProductionBloc(context)),
          BlocProvider<CommonMailsBloc>(
            create: (BuildContext context) => CommonMailsBloc(context),
          ),
        ], child: const Dashboard());

      case RouteName.splash:
        return const Splash();

      //Documents
      case RouteName.documents:
        return MultiBlocProvider(providers: [
          BlocProvider<AppBarBloc>(
            create: (BuildContext context) => AppBarBloc(),
          ),
          BlocProvider<DashboardBloc>(
            create: (BuildContext context) => DashboardBloc(),
          ),
          BlocProvider<DocumentsBloc>(
              create: (BuildContext context) => DocumentsBloc())
        ], child: const AllDocuments());

      //Production
      case RouteName.barcodeScan: //Barcode scan
        return MultiBlocProvider(
            providers: [
              BlocProvider<AppBarBloc>(
                create: (BuildContext context) => AppBarBloc(),
              ),
              BlocProvider<ScanCubit>(
                create: (BuildContext context) => ScanCubit(),
              )
            ],
            child: BarcodeScan(
              arguments: args,
            ));

      case RouteName.production: // Production dashboard
        return MultiBlocProvider(
            providers: [
              BlocProvider<AppBarBloc>(
                create: (BuildContext context) => AppBarBloc(),
              ),
              BlocProvider<ProductionBloc>(
                create: (BuildContext context) => ProductionBloc(),
              )
            ],
            child: Production(
              arguments: args,
            ));

      case RouteName.overtime: // Operator overtime
        return MultiBlocProvider(providers: [
          BlocProvider<AppBarBloc>(
            create: (BuildContext context) => AppBarBloc(),
          ),
          BlocProvider<EOvertimeBLoc>(
            create: (BuildContext context) => EOvertimeBLoc(context),
          )
        ], child: EmployeeOverTime());

      // Cutting
      case RouteName.cuttingScreen: // Cutting production screen
        return MultiBlocProvider(
            providers: [
              BlocProvider<AppBarBloc>(
                create: (BuildContext context) => AppBarBloc(),
              ),
              BlocProvider<CuttingBloc>(
                  create: (BuildContext context) => CuttingBloc())
            ],
            child: CuttingScreen(
              arguments: args,
            ));

      case RouteName
            .cuttingProductionProcessScreen: // Cutting production processes screen
        return MultiBlocProvider(
            providers: [
              BlocProvider<AppBarBloc>(
                create: (BuildContext context) => AppBarBloc(),
              ),
              BlocProvider<CuttingBloc>(
                  create: (BuildContext context) => CuttingBloc())
            ],
            child: CuttingProcessesScreen(
              arguments: args,
            ));

      // Quality
      case RouteName.qualityScreen: // Quality production screen
        return MultiBlocProvider(providers: [
          BlocProvider<AppBarBloc>(
            create: (BuildContext context) => AppBarBloc(),
          ),
          BlocProvider<QualityBloc>(
            create: (BuildContext context) => QualityBloc(),
          ),
        ], child: QualityProductionScreen(arguments: args));

      case RouteName
            .qualityProductionProcessScreen: // Production process screen
        return MultiBlocProvider(providers: [
          BlocProvider<AppBarBloc>(
            create: (BuildContext context) => AppBarBloc(),
          ),
          BlocProvider<QualityBloc>(
            create: (BuildContext context) => QualityBloc(),
          ),
        ], child: QualityProductionProcessScreen(arguments: args));

      // Calibration
      case RouteName.calibration:
        return MultiBlocListener(listeners: [
          BlocProvider<AppBarBloc>(
            create: (BuildContext context) => AppBarBloc(),
          ),
          BlocProvider<CalibrationBloc>(
            create: (BuildContext context) => CalibrationBloc(),
          ),
        ], child: const CalibrationDashboard());

      case RouteName.instrumentRegistration: // Instrument registration
        return MultiBlocListener(listeners: [
          BlocProvider<CalibrationBloc>(
            create: (BuildContext context) => CalibrationBloc(),
          ),
        ], child: const InstrumentsRegistration());

      case RouteName.instrumentTypeRegistration: // Instrument registration
        return MultiBlocListener(listeners: [
          BlocProvider<CalibrationBloc>(
            create: (BuildContext context) => CalibrationBloc(),
          ),
        ], child: const InstrumentTypeRegistration());

      case RouteName
            .calibrationScheduleRegistration: // Calibration schedule registration
        return MultiBlocListener(listeners: [
          BlocProvider<CalibrationBloc>(
            create: (BuildContext context) => CalibrationBloc(),
          ),
        ], child: const CalibrationScheduleRegistration());

      case RouteName.calibrationStatus: // Calibration status
        return MultiBlocListener(listeners: [
          BlocProvider<CalibrationBloc>(
            create: (BuildContext context) => CalibrationBloc(),
          ),
        ], child: const CalibrationStatus());

      case RouteName.orderInstrument: // Order instruments
        return MultiBlocListener(listeners: [
          BlocProvider<CalibrationBloc>(
            create: (BuildContext context) => CalibrationBloc(),
          ),
        ], child: const OrderInstrument());

      case RouteName.allInstrumentOrders: // All instrument orders
        return MultiBlocListener(listeners: [
          BlocProvider<CalibrationBloc>(
            create: (BuildContext context) => CalibrationBloc(),
          ),
        ], child: const AllInstrumentOrders());

      case RouteName.outwardInstruments: // Outward instruments
        return MultiBlocListener(
            listeners: [
              BlocProvider<AppBarBloc>(
                create: (BuildContext context) => AppBarBloc(),
              ),
              BlocProvider<CalibrationBloc>(
                create: (BuildContext context) => CalibrationBloc(),
              ),
            ],
            child: OutwardInstruments(
              args: args,
            ));

      case RouteName.pdf: // Pdf view
        return PDFPreviewWidget(
          bytes: args['data'],
        );

      case RouteName.viewpdf: // Pdf view
        return MultiBlocListener(
            listeners: [
              BlocProvider<AppBarBloc>(
                create: (BuildContext context) => AppBarBloc(),
              ),
            ],
            child: CertificateView(
              bytes: args['data'],
            ));

      case RouteName.inwardInstruments: // Inward instruments
        return MultiBlocListener(listeners: [
          BlocProvider<AppBarBloc>(
            create: (BuildContext context) => AppBarBloc(),
          ),
          BlocProvider<CalibrationBloc>(
            create: (BuildContext context) => CalibrationBloc(),
          ),
        ], child: const InwardInstruments());

      case RouteName
            .instrumentOutsourceWorkorder: // Instruments outsource workorder
        return MultiBlocListener(listeners: [
          BlocProvider<AppBarBloc>(
            create: (BuildContext context) => AppBarBloc(),
          ),
          BlocProvider<CalibrationBloc>(
            create: (BuildContext context) => CalibrationBloc(),
          ),
        ], child: const InstrumentOutsourceWorkorders());

      case RouteName.calibrationHistory: // Instruments calibration history
        return MultiBlocListener(listeners: [
          BlocProvider<AppBarBloc>(
            create: (BuildContext context) => AppBarBloc(),
          ),
          BlocProvider<CalibrationBloc>(
            create: (BuildContext context) => CalibrationBloc(),
          ),
        ], child: const CalibrationHistory());

      case RouteName.instrumentStore: // Instruments store
        return MultiBlocListener(listeners: [
          BlocProvider<AppBarBloc>(
            create: (BuildContext context) => AppBarBloc(),
          ),
          BlocProvider<CalibrationBloc>(
            create: (BuildContext context) => CalibrationBloc(),
          ),
        ], child: const InstrumentStore());

      case RouteName.rejectedInstruments: // Rejected instruments
        return MultiBlocListener(listeners: [
          BlocProvider<AppBarBloc>(
            create: (BuildContext context) => AppBarBloc(),
          ),
          BlocProvider<CalibrationBloc>(
            create: (BuildContext context) => CalibrationBloc(),
          ),
        ], child: const RejectedInstrumentsPage());

      case RouteName.packingProductionScreen: // Paking production screen
        return MultiBlocProvider(providers: [
          BlocProvider<AppBarBloc>(
            create: (BuildContext context) => AppBarBloc(),
          ),
          BlocProvider<PackingBloc>(
            create: (BuildContext context) => PackingBloc(),
          ),
        ], child: PakingDashboard(arguments: args));

      case RouteName.packingProcessesScreen: // Paking process screen
        return MultiBlocProvider(providers: [
          BlocProvider<AppBarBloc>(
            create: (BuildContext context) => AppBarBloc(),
          ),
          BlocProvider<PackingBloc>(
            create: (BuildContext context) => PackingBloc(),
          ),
        ], child: PackingProcessesScreen(arguments: args));

      case RouteName.stock: // Stock
        return MultiBlocProvider(providers: [
          BlocProvider<AppBarBloc>(
            create: (BuildContext context) => AppBarBloc(),
          ),
          BlocProvider<DocumentsBloc>(
              create: (BuildContext context) => DocumentsBloc()),
          BlocProvider<PackingBloc>(
            create: (BuildContext context) => PackingBloc(),
          ),
        ], child: const Stock());

      case RouteName.operatorAutoProduction: // Operator automatic
        return MultiBlocProvider(
            providers: [
              BlocProvider<AppBarBloc>(
                create: (BuildContext context) => AppBarBloc(),
              ),
              BlocProvider<ScanCubit>(
                  create: (BuildContext context) => ScanCubit()),
              BlocProvider<OAPBloc>(
                  create: (BuildContext context) => OAPBloc(context)),
            ],
            child: OperatorAutoProduction(
              arguments: args,
            ));

      case RouteName.operatorManualProduction: // Operator automatic
        return MultiBlocProvider(
            providers: [
              BlocProvider<AppBarBloc>(
                create: (BuildContext context) => AppBarBloc(),
              ),
              BlocProvider<ScanCubit>(
                  create: (BuildContext context) => ScanCubit()),
              BlocProvider<OMPBloc>(
                  create: (BuildContext context) => OMPBloc(context)),
            ],
            child: OperatorManualProduction(
              arguments: args,
            ));

      case RouteName.pendingProduction: // Operator automatic
        return MultiBlocProvider(
            providers: [
              BlocProvider<AppBarBloc>(
                create: (BuildContext context) => AppBarBloc(),
              ),
              BlocProvider<ScanCubit>(
                  create: (BuildContext context) => ScanCubit()),
              BlocProvider<BarcodeBloc>(
                  create: (BuildContext context) =>
                      BarcodeBloc(context: context)),
              BlocProvider<PendingProductionBloc>(
                  create: (BuildContext context) =>
                      PendingProductionBloc(context)),
            ],
            child: PendingProduction(
              arguments: args,
            ));

      case RouteName.machineProgramSequance: // program sequance automatic
        return MultiBlocProvider(
            providers: [
              BlocProvider<AppBarBloc>(
                create: (BuildContext context) => AppBarBloc(),
              ),
              BlocProvider<ScanCubit>(
                  create: (BuildContext context) => ScanCubit()),
              BlocProvider<BarcodeBloc>(
                  create: (BuildContext context) =>
                      BarcodeBloc(context: context)),
              BlocProvider<MachineProgramSequanceBloc>(
                  create: (BuildContext context) =>
                      MachineProgramSequanceBloc(context)),
            ],
            child: MachinesequancePrograme(
              arguments: args,
            ));

      //Registration
      case RouteName.registration:
        return MultiBlocProvider(providers: [
          BlocProvider<AppBarBloc>(
            create: (BuildContext context) => AppBarBloc(),
          ),
          BlocProvider<DashboardBloc>(
            create: (BuildContext context) => DashboardBloc(),
          ),
          BlocProvider<RegistrationBloc>(
            create: (BuildContext context) => RegistrationBloc(),
          )
        ], child: Registration(arguments: args));

      case RouteName.employeeRegistration: //Employee registration
        return MultiBlocProvider(providers: [
          BlocProvider<AppBarBloc>(
            create: (BuildContext context) => AppBarBloc(),
          ),
          BlocProvider<EmployeeRegistrationBloc>(
            create: (BuildContext context) => EmployeeRegistrationBloc(),
          ),
          BlocProvider<EmpRegBloc>(
            create: (BuildContext context) => EmpRegBloc(),
          )
        ], child: const EmployeeRegistration());

      case RouteName.machineRegistration: // Machine registration
        return MultiBlocProvider(providers: [
          BlocProvider<AppBarBloc>(
            create: (BuildContext context) => AppBarBloc(),
          ),
          BlocProvider<MachineRegisterBloc>(
            create: (BuildContext context) => MachineRegisterBloc(context),
          ),
        ], child: const MachineRegistration());

      case RouteName.tabletRegistration: // Tablet registration
        return MultiBlocProvider(providers: [
          BlocProvider<AppBarBloc>(
            create: (BuildContext context) => AppBarBloc(),
          ),
          BlocProvider<TabletBloc>(
              create: (BuildContext context) => TabletBloc(context)),
        ], child: const TabletRegistration());

      case RouteName.subcontractorRegistration: // Subcontractor registration
        return MultiBlocProvider(providers: [
          BlocProvider<AppBarBloc>(
            create: (BuildContext context) => AppBarBloc(),
          ),
          BlocProvider<SubcontractorRegistrationBloc>(
            create: (BuildContext context) => SubcontractorRegistrationBloc(),
          ),
        ], child: const SubcontractorRegistration());

      case RouteName.programsAssignedToRoles: // Programs assigned to roles
        return MultiBlocProvider(providers: [
          BlocProvider<AppBarBloc>(
            create: (BuildContext context) => AppBarBloc(),
          ),
          BlocProvider<ProgramAccessManagementBloc>(
            create: (BuildContext context) => ProgramAccessManagementBloc(),
          ),
        ], child: const ProgramsAssignedToRoles());

      case RouteName.updateEmployeeDetails: // Programs assigned to roles
        return MultiBlocProvider(providers: [
          BlocProvider<AppBarBloc>(
            create: (BuildContext context) => AppBarBloc(),
          ),
          BlocProvider<UpdateEmployeeDetailsBloc>(
            create: (BuildContext context) => UpdateEmployeeDetailsBloc(),
          ),
        ], child: const UpdateEmployeeDetails());

      //PPC
      case RouteName.machinestatus: //Machine Status
        return MultiBlocProvider(providers: [
          BlocProvider<AppBarBloc>(
            create: (BuildContext context) => AppBarBloc(),
          ),
          BlocProvider<MachineStatusBloc>(
              create: (BuildContext context) => MachineStatusBloc())
        ], child: const MachineStatus());

      // Resource management system
      case RouteName.uploadproductdetails:
        return MultiBlocProvider(providers: [
          BlocProvider<AppBarBloc>(
            create: (BuildContext context) => AppBarBloc(),
          ),
          BlocProvider<DocumentsBloc>(
              create: (BuildContext context) => DocumentsBloc()),
          BlocProvider<ProductResourceManagementBloc>(
              create: (BuildContext context) =>
                  ProductResourceManagementBloc()),
        ], child: const ProductResourceManagement());

      // Verify machine programs
      case RouteName.verifyMachinePrograms:
        return MultiBlocProvider(providers: [
          BlocProvider<AppBarBloc>(
            create: (BuildContext context) => AppBarBloc(),
          ),
          BlocProvider<ProductResourceManagementBloc>(
              create: (BuildContext context) =>
                  ProductResourceManagementBloc()),
        ], child: const VerifyMachinePrograms());

      // Verified machine programs
      case RouteName.verifiedMachinePrograms:
        return MultiBlocProvider(providers: [
          BlocProvider<AppBarBloc>(
            create: (BuildContext context) => AppBarBloc(),
          ),
          BlocProvider<ProductResourceManagementBloc>(
              create: (BuildContext context) =>
                  ProductResourceManagementBloc()),
        ], child: const VerifiedMachinePrograms());

      case RouteName.programsconverter:
        return MultiBlocProvider(providers: [
          BlocProvider<AppBarBloc>(
            create: (BuildContext context) => AppBarBloc(),
          ),
          BlocProvider<ProgramConverterBLoc>(
              create: (BuildContext context) => ProgramConverterBLoc(context)),
        ], child: MachineProgramConverter());

      case RouteName.newproductionproduct:
        return MultiBlocProvider(providers: [
          BlocProvider<AppBarBloc>(
            create: (BuildContext context) => AppBarBloc(),
          ),
          BlocProvider<ProductResourceManagementBloc>(
              create: (BuildContext context) =>
                  ProductResourceManagementBloc()),
        ], child: const NewProductionProduct());

      // Product process route
      case RouteName.productProcessRoute:
        return MultiBlocProvider(providers: [
          BlocProvider<AppBarBloc>(
            create: (BuildContext context) => AppBarBloc(),
          ),
          BlocProvider<DocumentsBloc>(
              create: (BuildContext context) => DocumentsBloc()),
          BlocProvider<ProductAndProcessRouteBloc>(
            create: (context) => ProductAndProcessRouteBloc(),
          ),
          BlocProvider<DashboardBloc>(
            create: (BuildContext context) => DashboardBloc(),
          ),
          BlocProvider<ProductRouteBloc>(
            create: (BuildContext context) => ProductRouteBloc(),
          ),
        ], child: const ProductAndProcessRouteScreen());

      //Capacity plan
      case RouteName.cpDragAndDrop:
        return MultiBlocProvider(providers: [
          BlocProvider<AppBarBloc>(
            create: (BuildContext context) => AppBarBloc(),
          ),
          BlocProvider<GraphViewBloc>(
            create: (BuildContext context) => GraphViewBloc(),
          ),
        ], child: const DragAndDrop());

      case RouteName.capacityPlan: // Capacity plan dashboard
        return MultiBlocProvider(providers: [
          BlocProvider<AppBarBloc>(
            create: (BuildContext context) => AppBarBloc(),
          ),
          BlocProvider<CapacityDashboardBloc>(
              create: (BuildContext context) => CapacityDashboardBloc()),
        ], child: const CapacityDashboard());

      case RouteName.newCpPlan: //New Capacity Plan
        return MultiBlocProvider(providers: [
          BlocProvider<AppBarBloc>(
            create: (BuildContext context) => AppBarBloc(),
          ),
          BlocProvider<CapacityPlanBloc>(
            create: (BuildContext context) => CapacityPlanBloc(),
          ),
        ], child: const CapacityPlan());

      case RouteName.cpBarChart: //New Capacity Plan
        return MultiBlocProvider(providers: [
          BlocProvider<AppBarBloc>(
            create: (BuildContext context) => AppBarBloc(),
          ),
          BlocProvider<GraphViewBloc>(
            create: (BuildContext context) => GraphViewBloc(),
          ),
        ], child: const BarChartCapacityPlan());

      case RouteName.workcentreShift: //New Capacity Plan
        return MultiBlocProvider(providers: [
          BlocProvider<AppBarBloc>(
            create: (BuildContext context) => AppBarBloc(),
          ),
          BlocProvider<WorkstationShiftBloc>(
            create: (BuildContext context) => WorkstationShiftBloc(),
          ),
        ], child: const WorkcentreAvailableTime());

      case RouteName.outsourceDashboard: //Outsourcedashboard
        return MultiBlocProvider(providers: [
          BlocProvider<AppBarBloc>(
            create: (BuildContext context) => AppBarBloc(),
          ),
        ], child: const OutsourceDashboard());

      case RouteName.outsource: //New Outsource
        return MultiBlocProvider(
          providers: [
            BlocProvider<AppBarBloc>(
              create: (BuildContext context) => AppBarBloc(),
            ),
            BlocProvider<OutsourceBloc>(
              create: (BuildContext context) => OutsourceBloc(),
            ),
          ],
          child: const OutsourceScreen(),
        );

      case RouteName.inward: //Inward
        return MultiBlocProvider(providers: [
          BlocProvider<AppBarBloc>(
            create: (BuildContext context) => AppBarBloc(),
          ),
          BlocProvider<OutsourceBloc>(
            create: (BuildContext context) => OutsourceBloc(),
          ),
          BlocProvider<InwardBloc>(
            create: (BuildContext context) => InwardBloc(),
          ),
        ], child: const InwardProducts());

      case RouteName.subcontractorProcess: //Inward
        return MultiBlocProvider(providers: [
          BlocProvider<AppBarBloc>(
            create: (BuildContext context) => AppBarBloc(),
          ),
          BlocProvider<SubcontractorProcessCubit>(
            create: (BuildContext context) => SubcontractorProcessCubit(),
          ),
        ], child: const SubcontractorProcessCapability());

      case RouteName.challanPdf: //Inward
        return MultiBlocProvider(providers: [
          BlocProvider<AppBarBloc>(
            create: (BuildContext context) => AppBarBloc(),
          ),
          BlocProvider<OutsourceBloc>(
            create: (BuildContext context) => OutsourceBloc(),
          ),
          BlocProvider<ChallanpdfCubit>(
            create: (BuildContext context) => ChallanpdfCubit(),
          ),
        ], child: const CheckChallanPdf());

      case RouteName.machinedashboard:
        return MultiBlocProvider(
            providers: [
              BlocProvider<AppBarBloc>(
                create: (BuildContext context) => AppBarBloc(),
              ),
              BlocProvider<MachinewiseDashboardBloc>(
                create: (BuildContext context) =>
                    MachinewiseDashboardBloc(context),
              ),
            ],
            child: MachinewiseDashboard(
                workstationstatuslist: args['workstationstatuslist']));

      case RouteName.admindashboard:
        return MultiBlocProvider(
            providers: [
              BlocProvider<AppBarBloc>(
                create: (BuildContext context) => AppBarBloc(),
              ),
              BlocProvider<ADBBloc>(
                create: (BuildContext context) => ADBBloc(context),
              ),
              BlocProvider<ADBsecondBloc>(
                create: (BuildContext context) => ADBsecondBloc(context),
              ),
            ],
            child: Admindashboard(
              context: context,
              crossAxisCount: args['crossAxisCount'],
              childAspectRatio: args['childAspectRatio'],
              programsList: args['programsList'],
            ));

      case RouteName.dashboardUtility:
        return MultiBlocProvider(providers: [
          BlocProvider<AppBarBloc>(
            create: (BuildContext context) => AppBarBloc(),
          ),
          BlocProvider<ADBBloc>(
            create: (BuildContext context) => ADBBloc(context),
          ),
          BlocProvider<ADBsecondBloc>(
            create: (BuildContext context) => ADBsecondBloc(context),
          ),
        ], child: DashboardUtility(programsList: args['programsList'] ?? []));

      // common reports
      case RouteName.mailmodule:
        return MultiBlocProvider(providers: [
          BlocProvider<AppBarBloc>(
            create: (BuildContext context) => AppBarBloc(),
          ),
          BlocProvider<CommonMailsBloc>(
            create: (BuildContext context) => CommonMailsBloc(context),
          ),
        ], child: const BulkmailsModule());

      case RouteName.mailmoduledashbord:
        return MultiBlocProvider(providers: [
          BlocProvider<AppBarBloc>(
            create: (BuildContext context) => AppBarBloc(),
          ),
          BlocProvider<CommonMailsBloc>(
            create: (BuildContext context) => CommonMailsBloc(context),
          ),
        ], child: const CommonMails());

      // Product assets management
      case RouteName.productAssetsManagementScreen: // Dashboard
        return MultiBlocProvider(providers: [
          BlocProvider<AppBarBloc>(
            create: (BuildContext context) => AppBarBloc(),
          ),
          BlocProvider<ProductDashboardBloc>(
            create: (BuildContext context) => ProductDashboardBloc(),
          ),
        ], child: const PAMDashboard());

      case RouteName.productRegistration: // Product registration
        return MultiBlocProvider(
            providers: [
              BlocProvider<AppBarBloc>(
                create: (BuildContext context) => AppBarBloc(),
              ),
              BlocProvider<ProductDashboardBloc>(
                create: (BuildContext context) => ProductDashboardBloc(),
              ),
            ],
            child: ProductRegistration(
                unitOfMeasurementList: args['unitOfMeasurementList'],
                productTypeList: args['productTypeList']));

      case RouteName.productStructure: // Product structure
        return MultiBlocProvider(providers: [
          BlocProvider<AppBarBloc>(
            create: (BuildContext context) => AppBarBloc(),
          ),
          BlocProvider<ProductDashboardBloc>(
            create: (BuildContext context) => ProductDashboardBloc(),
          ),
        ], child: const ProductStructure());

      case RouteName
            .productInventoryManagementScreen: // Product inventory management screen
        return MultiBlocProvider(providers: [
          BlocProvider<AppBarBloc>(
            create: (BuildContext context) => AppBarBloc(),
          ),
          BlocProvider<ProductDashboardBloc>(
            create: (BuildContext context) => ProductDashboardBloc(),
          ),
        ], child: const ProductInventoryManagement());

      // Sales orders
      case RouteName.assemblySalesOrders:
        return MultiBlocProvider(providers: [
          BlocProvider<AppBarBloc>(
            create: (BuildContext context) => AppBarBloc(),
          ),
          BlocProvider<SalesOrderBloc>(
            create: (BuildContext context) => SalesOrderBloc(),
          ),
        ], child: const Salesorders());

      // Assembly component requirement
      case RouteName.assemblyComponentRequirementsScreen:
        return MultiBlocProvider(
            providers: [
              BlocProvider<AppBarBloc>(
                create: (BuildContext context) => AppBarBloc(),
              ),
              BlocProvider<SalesOrderBloc>(
                create: (BuildContext context) => SalesOrderBloc(),
              ),
            ],
            child: IssueStockForAssembly(
              selectedAssembliesDataList: args['selectedAssembliesDataList'],
            ));

      default:
        return const Text('No route found');
    }
  }
}
