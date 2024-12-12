// Author : Shital Gayakwad
// Created Date : 22 Feb 2023
// Description : ERPX_PPC -> App api Url's

class AppUrl {
  //Base URL
//   static var baseUrl = 'https://192.168.0.183:8081'; // Rohini IP
  static var baseUrl = 'https://192.168.0.75:8081'; // Shital IP

  // static var baseUrl = 'https://192.168.0.91:8081'; // Nilesh sir IP
  // static var baseUrl = 'https://erpx.datta-india.co.in:8081'; // Cloud address
  static var indURI = 'http://192.168.0.55:3213';
  static var autobitsurl = 'http://103.173.51.130:4040/api/datasets/json';

  //User Login Url
  static var loginUrl = '$baseUrl/user/login/userdata'; //User Login
  static var userLoginLog =
      '$baseUrl/user/login/user-log-registration'; // User log registration
  static var logoutUrl = '$baseUrl/user/login/log-out'; // Log out

  //Dashboard URL's
  static var userModuleUrl =
      '$baseUrl/user/authorization/folders'; //User Module
  static var programs = '$baseUrl/user/authorization/programs';
  static var assignedMachine =
      '$baseUrl/workcentre/workstation/machine-name'; //Machine Assign
  static var knowMachineAutomaticOrManual =
      '$baseUrl/workcentre/machine-auto/manual-automatic';

  // admindashboard
  static var getworkstationlist =
      '$baseUrl/dashboard/admin-dashboard/get-workstation-list';
  static var getAutomaticworkcentreList =
      '$baseUrl/dashboard/admin-dashboard/get-automaticWorkcentreList';
  static var getworkstationTotalCurrentTagid =
      '$baseUrl/dashboard/admin-dashboard/workstation-TotalCurrent-Tagid';
  static var industry4workstationtagID =
      '$baseUrl/dashboard/admin-dashboard/industry4-workstation-tags';
  static var machineMonthlyEnergyconsumption =
      '$baseUrl/dashboard/admin-dashboard/machine_monthwise_energyconsuption';

  //Registration
  //Tablet Registration URL's
  static var workcentre = '$baseUrl/workcentre/wc/all-wc-list';
  static var workstationByWorkcentreId =
      '$baseUrl/workcentre/selected-ws/ws-by-wc_id';
  static var checkTabIsRegisteredOrNot =
      '$baseUrl/workcentre/workstation/assigned-or-not';
  static var allwcwslistWithAndroidId =
      '$baseUrl/workcentre/workstation/assigned-tablets';
  static var registerTab = '$baseUrl/workcentre/workstation/register-tab';
  static var deleteTab = '$baseUrl/workcentre/workstation/delete-tab';

  //Machine URL's
  static var isinhouseWorkcentres =
      '$baseUrl/workcentre/wc/is-in-house'; // Is in house workcentre list
  static var shiftPattern =
      '$baseUrl/common/data/shift-pattern'; // Shift pattern list
  static var company = '$baseUrl/common/data/company-name'; // Company list
  static var registerWorkcentre =
      '$baseUrl/workcentre/wc/register-wc'; // register workcentre
  static var registerWorkstation =
      '$baseUrl/workcentre/selected-ws/register-ws'; // Register workstation
  static var isInCapacityPlanWorkcentres =
      '$baseUrl/workcentre/wc/is-in-capacity-plan'; // Is in capacity plan workcentres
  static var deletedFalseWc =
      '$baseUrl/workcentre/wc/deleted-false-wc'; // Deleted false workcentre list

  // Subcontractor registration
  static var subcontractorlist =
      '$baseUrl/supervisor/subcontractor/contractor-data'; // Subcontractor list
  static var city = '$baseUrl/supervisor/subcontractor/city'; // City list
  static var validateSubcontractor =
      '$baseUrl/supervisor/subcontractor/validate-subcontractor-registration'; // validate subcontractor is already registered or not
  static var registerSubcontractor =
      '$baseUrl/supervisor/subcontractor/register-subcontractor';
  static var calibrationContractors =
      '$baseUrl/supervisor/subcontractor/calibration-contractors'; // Calibration contractors

  //Employee registration
  static var state = '$baseUrl/user/employee_registration/state'; //state
  static var employeetype =
      '$baseUrl/user/employee_registration/employee-type'; //Employee type
  static var department =
      '$baseUrl/user/employee_registration/employee-department'; //Employee department
  static var designation =
      '$baseUrl/user/employee_registration/employee-designation'; //Employee Designation
  static var employeeId =
      '$baseUrl/user/employee_registration/employee-id'; // Employee id
  static var registerEmployee =
      '$baseUrl/user/employee_registration/register-employee'; //Register employee
  static var registerEmpDocs =
      '$baseUrl/user/employee_registration/register-documents-ids'; // Employee documents reference to hr_employee //emp-doc-register
  static var createUserCredentials =
      '$baseUrl/user/employee_registration/create-user-credentials';

  // Update employee details
  static var allEmployeeDetailsUrl =
      '$baseUrl/user/update-employee-details/employee-list'; // All employee data
  static var updateEmployeeUrl =
      '$baseUrl/user/update-employee-details/update-employee-details'; // Update employee data

  // Register documents
  static var panRegister =
      '$baseUrl/documents/emp/register-pan'; // pan card register
  static var aadharRegister =
      '$baseUrl/documents/emp/register-aadhar'; // Aadhar card register
  static var employeeProfileRegister =
      '$baseUrl/documents/emp/register-employee-profile'; // Employee profile register
  static var updateEmployeeProfile =
      '$baseUrl/documents/emp/update-employee-profile'; // Update employee profile
  static var viewAadharUrl = '$baseUrl/documents/emp/aadhar'; // View adhar card
  static var updateAadharcard =
      '$baseUrl/documents/emp/update-aadharcard'; // Update aadhar card
  static var viewPanUrl = '$baseUrl/documents/emp/pan'; // View pan card
  static var updatePancard =
      '$baseUrl/documents/emp/update-pancard'; // Update pan card

  // User required details registration
  static var empFullName =
      '$baseUrl/user/user-pgm-assign/employee-fullname'; // Employee full name
  static var createEmpCredentials =
      '$baseUrl/user/user-pgm-assign/create-user-credentials'; // user credentials registration
  static var employeeRole =
      '$baseUrl/user/user-pgm-assign/employee-role'; //Employee role
  static var registerEmpRole =
      '$baseUrl/user/user-pgm-assign/register-emp-role'; // register employee role
  static var user = '$baseUrl/user/user-pgm-assign/user'; // all users list
  static var assignUserRole =
      '$baseUrl/user/user-pgm-assign/assign-user-role'; //assign employee role
  static var registerProgram =
      '$baseUrl/user/user-pgm-assign/register-program'; //Program registration
  static var allPrograms =
      '$baseUrl/user/user-pgm-assign/all-programs'; //all programs list
  static var allFolders =
      '$baseUrl/user/user-pgm-assign/all-folders'; //all folders list
  static var registerFolders =
      '$baseUrl/user/user-pgm-assign/register-folder'; //register folder
  static var programsInFolder =
      '$baseUrl/user/user-pgm-assign/programs-in-folder'; //Programs in folders
  static var addProgramsInFolder =
      '$baseUrl/user/user-pgm-assign/add-programs-in-folder'; //Add programs in folder
  static var programsAssignedToRole =
      '$baseUrl/user/user-pgm-assign/programs-assigned-to-role'; //Programs assigned to role
  static var assignProgramsToRole =
      '$baseUrl/user/user-pgm-assign/assign-programs-to-role'; //Assign programs to role
  static var validateUsername =
      '$baseUrl/user/user-pgm-assign/validate-user'; //Validate user
  static var validateRole =
      '$baseUrl/user/user-pgm-assign/validate-role'; //Validate role
  static var validateIfRoleAlreadyAssignedToUser =
      '$baseUrl/user/user-pgm-assign/validate-assigned-role-to-user'; //Validate role already assigned to user
  static var validateProgramRegistration =
      '$baseUrl/user/user-pgm-assign/validate-program-registration'; //Validate program registration
  static var validateFolder =
      '$baseUrl/user/user-pgm-assign/validate-folder-registration'; //Validate folder
  static var programsNotInFolder =
      '$baseUrl/user/user-pgm-assign/programs-not-in-folder'; //Programs which are not in folder
  static var deleteRoleUrl =
      '$baseUrl/user/user-pgm-assign/delete-role'; // Delete role
  static var deleteProgramUrl =
      '$baseUrl/user/user-pgm-assign/delete-program'; // Delete program
  static var deleteFolderUrl =
      '$baseUrl/user/user-pgm-assign/delete-folder'; // Delete folder
  static var deleteProgramsInFolderUrl =
      '$baseUrl/user/user-pgm-assign/delete-programs-in-folder'; // Delete programs in folder

  // Program access management
  static var programAccessManagementData =
      '$baseUrl/user/user-pgm-assign/program-access-management-data'; // Program access management
  static var deleteUserFromRole =
      '$baseUrl/user/user-pgm-assign/delete-user-from-role'; // Delete user from role
  static var deleteProgramAssignedToTheRole =
      '$baseUrl/user/user-pgm-assign/delete-program-assigned-to-the-role'; // Delete program which is assigned to the role

  //Quality Inspection
  static var startInspection =
      '$baseUrl/quality/inspection/start-inspection'; // For start inspection
  static var inspectionId =
      '$baseUrl/quality/inspection/inspection-id'; // For check inspection is already started or not
  static var inspectionTime =
      '$baseUrl/quality/inspection/get-start_inspection_time'; //For showing user start inspection time
  static var qualityRejectedReasons =
      '$baseUrl/quality/inspection/rejected-reasons'; //Product rejected reasons while quality inspection
  static var endInspection =
      '$baseUrl/quality/inspection/end-inspection'; //For end inspection
  static var shortQuantityUrl =
      '$baseUrl/quality/inspection/short-quantity'; //Quality short quantity
  static var finalEndInspection =
      '$baseUrl/quality/inspection/final-end-inspection'; //Final end
  static var changeEndProductionFlag =
      '$baseUrl/quality/inspection/change-end-inspection-flag'; //change end production flag
  static var inspectionStatusCheck =
      '$baseUrl/quality/inspection/job-inspection-status-check'; //inspection status check
  static var inspectionStatus =
      '$baseUrl/quality/inspection/inspection-status'; //inspection status

  // Quality calibration
  static var measuringInstruments =
      '$baseUrl/quality/instruments/measuring-instruments'; // All measuring instruments
  static var instrumentTypeData =
      '$baseUrl/quality/instrument-type/data'; // All instrument type data
  static var registerInstrumentType =
      '$baseUrl/quality/instrument-type/register'; // Register instrument type
  static var deleteInstrumentType =
      '$baseUrl/quality/instrument-type/delete'; // Delete instrument type
  static var registerInstruments =
      '$baseUrl/quality/instruments/register'; // Register instruments
  static var getAllInstruments =
      '$baseUrl/quality/instruments/get-all-instruments'; // Get all instruments
  static var generateCardNumber =
      '$baseUrl/quality/calibration/generate-card-number'; // Generate card number
  static var frequency = '$baseUrl/quality/calibration/frequency'; // Frequency
  static var purchaseOrder =
      '$baseUrl/quality/calibration/purchase-order'; // Purchase order
  static var instrumentScheduleRegistration =
      '$baseUrl/quality/calibration/instrument-schedule-registration'; // Instrument schedule registration
  static var registerCertificates =
      '$baseUrl/documents/doc/instrument-calibration-certificates'; // Instruments calibration certificates
  static var certificateReference =
      '$baseUrl/quality/calibration/certificate-reference'; // Keep mongo db id refence to postgre sql
  static var currentDay =
      '$baseUrl/quality/calibration/currentday-status'; // Current day records
  static var getCertificates =
      '$baseUrl/documents/doc/get-certificates'; // Get certificates
  static var calibrationStatus =
      '$baseUrl/quality/calibration/calibration-status'; // Calibration status
  static var emailAddresses =
      '$baseUrl/quality/calibration/email-addresses'; // All email address
  static var sendInstrumentOrder =
      '$baseUrl/quality/calibration/send-instrument-order'; // Order instrument
  static var measuringrangeList =
      '$baseUrl/quality/calibration/measuring-range-list'; // Measuring range list
  static var oneProduct =
      '$baseUrl/quality/calibration/one-instrument-from-product-table'; // One isntrument data from product table
  static var allInstrumentOrders =
      '$baseUrl/quality/calibration/all-instrument-orders'; // All instrument orders

  static var calibrationHistoryRegistration =
      '$baseUrl/quality/calibration/calibration-history-registration'; // Calibration instrument registration
  static var sendInstrumentForCalibration =
      '$baseUrl/quality/calibration/send-instrument-for-calibration'; // Send Instrument for calibration
  static var outwardInstruments =
      '$baseUrl/quality/calibration/outward-instruments'; // Outward instruments for calibration
  static var challanWorkorder =
      '$baseUrl/quality/calibration/instrument-outsource-workorder'; // Generate challan
  static var challanReference =
      '$baseUrl/quality/calibration/challan-reference-to-instruments'; // Gave challan regerence to outward instruments
  static var inwardInstruments =
      '$baseUrl/quality/calibration/inward-instruments'; // Inward instruments for calibration
  static var inwardSpacificInstrument =
      '$baseUrl/quality/calibration/inward-spacific-instrument'; // Inward spacific instruments
  static var allOutsourcedWorkorders =
      '$baseUrl/quality/calibration/instruments-outsource-all-workorders'; // Instruments outsource workorders
  static var oneChallanData =
      '$baseUrl/quality/calibration/one-challan-data'; // One challan data
  static var allCardNumbers =
      '$baseUrl/quality/calibration/spacific-instrument-card-numbers'; // All card numbers
  static var searchedInstrument =
      '$baseUrl/quality/calibration/searched-instruments-data'; // Searched
  static var oneInstrumentHistory =
      '$baseUrl/quality/calibration/one-instrument-calibration-history'; // One instrument calibration history
  static var rejectInstrument =
      '$baseUrl/quality/calibration/reject-instrument'; // Reject instrument
  static var addRejectedInstrumentToHistory =
      '$baseUrl/quality/calibration/add-rejected-instrument-to-history'; // Add rejected instrument to history
  static var instrumentRejectionReasons =
      '$baseUrl/quality/calibration/instrument-rejection-reasons'; // Instrument rejection reasons
  static var rejectedInstrumentsdata =
      '$baseUrl/quality/calibration/rejected-instruments-data-list'; // Rejected instruments data list
  static var registerInstrumentOrders =
      '$baseUrl/quality/calibration/register-instrument-orders'; // Instrument orders
  static var getOneOrder =
      '$baseUrl/quality/calibration/one-instrument-order'; // One order data
  static var registerManufacturer =
      '$baseUrl/quality/instrument-type/register-manufacturer'; // Register manufacturer
  static var manufacturerData =
      '$baseUrl/quality/instrument-type/manufacturer-data'; // Manufacturer data
  static var deleteManufacturer =
      '$baseUrl/quality/instrument-type/delete-manufacturer'; // Delete instrument type
  static var storedInstrumentsData =
      '$baseUrl/quality/calibration/stored-instruments'; // Stored instruments
  static var cancelCalibration =
      '$baseUrl/quality/calibration/cancel-calibration'; // Cancel calibration
  static var restoreStoredInstrument =
      '$baseUrl/quality/calibration/restore-stored-instruments'; // Restore stored instrument

  // Packing and stock
  static var registerStock =
      '$baseUrl/supervisor/stock/register-stock'; // Stock registration
  static var availableStock =
      '$baseUrl/supervisor/stock/available-stock'; // Available stock
  static var decreaseStock =
      '$baseUrl/supervisor/stock/decrease-stock'; // Decrease stock

  // Database current time api (now())
  static var currentDatabaseTime = '$baseUrl/common/data/current-database-time';

  //Documents Urls
  static var pdfDetailsUrl =
      '$baseUrl/documents/pdf/pdf-data'; // For pdf details
  static var modelDetailsUrl =
      '$baseUrl/documents/model/model-data'; // For 3D models details
  static var documentsData =
      '$baseUrl/documents/doc/documents-data'; //Mongodb documents data
  static var mergedDocData =
      '$baseUrl/documents/doc/pdf-model-data'; // PDF and 3D models data combined
  static var empProfilePhoto =
      '$baseUrl/documents/emp/profile'; //Employee profile photo

  static var productDataMaster =
      '$baseUrl/product/all-products/productMasterData'; //Get product related data from master version etc

  // Product route, process route and product resource management
  static var productRoute =
      '$baseUrl/product/product-route/route-data'; // product route
  static var productRevision =
      '$baseUrl/product/product-route/product-revision'; // product revision
  static var createProductRoute =
      '$baseUrl/product/product-route/create-product-route'; // Create product route
  static var productBillOfMaterialId =
      '$baseUrl/product/product-route/product-bill-of-material-id'; // Product bill of material id
  static var registerProcessroute =
      '$baseUrl/product/product-route/create-process-route'; // Register process route
  static var processRoute =
      '$baseUrl/product/product-route/process-route'; // Process route
  static var updateProductRoute =
      '$baseUrl/product/product-route/update-product-route'; // Update product route
  static var deleteProductRoute =
      '$baseUrl/product/product-route/delete-product-route'; // Delete product route
  static var updateProductProcessRoute =
      '$baseUrl/product/product-route/update-process-route'; // Update product process route
  static var deleteProductProcessRoute =
      '$baseUrl/product/product-route/delete-process-route'; // Delete product process route
  static var productionInstruction =
      '$baseUrl/product/product-route/production-instructions'; // Production instructions
  static var uploadMachinePrograms =
      '$baseUrl/documents/doc/upload-programs'; // Upload machine programs

  static var productioninstructionDocuments =
      '$baseUrl/product/product-route/production-instruction-documents'; // Production instructions with documents
  static var deleteMachinePrograms =
      '$baseUrl/documents/doc/delete-programs'; // Delete Machine programs

  // Verify machine programs
  static var unVerifiedPrograms =
      '$baseUrl/documents/doc/program-list-for-verification'; // Machine programs list for verification
  static var verifyPrograms =
      '$baseUrl/documents/doc/verify-machine-programs'; //Verify machine programs
  static var verifiedPrograms =
      '$baseUrl/documents/doc/verified-machine-programs'; // Verified machine programs
  static var newProductionProduct =
      '$baseUrl/documents/doc/new-production-product-list'; // new production product from table
  static var deleteNewproductionproduct =
      '$baseUrl/documents/doc/deleteNewproductionproducttt'; // delect new production product from table

  // Product route and process route new version
  static var registerProductProcessRoute =
      '$baseUrl/product/product-route/register-product-process-route'; // Register product route and process route at the same time
  static var productProcessRouteData =
      '$baseUrl/product/product-route/product-and-process-route-data'; // Get product and process route data to show to user
  static var deleteProductRocessRoute =
      '$baseUrl/product/product-route/delete-product-and-process-route'; // Delete product and process route
  static var updateProductAndProcessRoute =
      '$baseUrl/product/product-route/update-product-and-process-route'; // Update product and process route
  static var processes = '$baseUrl/common/data/processes'; // Product processes
  static var filledProductAndProcessRoute =
      '$baseUrl/product/product-route/filled-product-route'; // Filled product and process route

  // Product machine route
  static var productMachineRouteInsert =
      '$baseUrl/product/product-route-via-machine/product-machine-route'; // Product route via machine insert api

  //Machine Status
  static var recent100Records =
      '$baseUrl/workcentre/machine-status/recent-100-records'; // recent 100 records
  static var workcentrestatus =
      '$baseUrl/workcentre/machine-status/workcentre'; // Perticular workcentre status
  static var workstationStatus =
      '$baseUrl/workcentre/machine-status/workstation'; //Perticular workstation status
  static var workcentrePeriodic =
      '$baseUrl/workcentre/machine-status/workcentre-periodic'; //Workcentre periodic data
  static var workstationPeriodic =
      '$baseUrl/workcentre/machine-status/workstation-periodic'; //Workstation periodic data
  static var selectedMonthWorkcentreStatus =
      '$baseUrl/workcentre/machine-status/workcentre-selected-month-status'; //Selected month workcentre status
  static var selectedMonthWorkstationStatus =
      '$baseUrl/workcentre/machine-status/workstation-selected-month-status'; //Selected month workstation status
  static var workcentrewiseEmployeeList =
      '$baseUrl/workcentre/machine-status/workcentre-employee'; //Workcentrewise employee list
  static var workcentreStatusByEmployee =
      '$baseUrl/workcentre/machine-status/workcentre-status-by-employee'; //Workcentre status by employee
  static var workstationwiseEmployeeList =
      '$baseUrl/workcentre/machine-status/workstation-employee'; //Workstation employee list
  static var workstationStatusByEmployee =
      '$baseUrl/workcentre/machine-status/workstation-status-by-employee'; //Workstation status by employee

  //Product
  static var allProduct =
      '$baseUrl/product/all-products/get-all-products'; //All product list
  static var registerProduct =
      '$baseUrl/product/all-products/register-instruments'; // Register quality department instruments
  static var instrumentReturnId =
      '$baseUrl/product/all-products/instrument-return-id'; // Instrument registration return id

  // Cutting
  static var startCUtting =
      '$baseUrl/operator/cutting/start-cutting'; //Start cutting
  static var cuttingStatus =
      '$baseUrl/operator/cutting/cutting-status'; // Cutting Status
  static var cuttingLiveStatus =
      '$baseUrl/operator/cutting/cutting-data'; // Cutting live status
  static var cuttingEnd = '$baseUrl/operator/cutting/end-cutting'; //End cutting
  static var finishCUtting =
      '$baseUrl/operator/cutting/finish-cutting'; // Finish cutting
  static var cuttingQuantity =
      '$baseUrl/operator/cutting/cutting-quantity'; //Cutting quantity

  // Operator screen
  static var startsetting =
      '$baseUrl/operator/operator-screen/start-setting-insert';
  static var ompstartsetting =
      '$baseUrl/operator/operator-screen/ompstartsetting';
  static var ompupdatestartproductionrecord =
      '$baseUrl/operator/operator-screen/update-start-production';
  static var getpreviousproductiontime =
      '$baseUrl/operator/operator-screen/get-previous-production-time';
  static var ompendProcess = '$baseUrl/operator/operator-screen/ompendProcess';
  static var endProcess = '$baseUrl/operator/operator-screen/endProcess';
  static var ompfinalEndProduction =
      '$baseUrl/operator/operator-screen/ompfinal-production-end';
  static var updatestartproductionrecord =
      '$baseUrl/operator/operator-screen/update-start-production';
  static var finalEndProduction =
      '$baseUrl/operator/operator-screen/final-production-end';
  static var workstationstatusid =
      '$baseUrl/operator/operator-screen/workstationstatusid';
  static var getProductBOMid =
      '$baseUrl/operator/operator-screen/get-product-BOM-id';
  static var getLastProductRouteDetails =
      '$baseUrl/operator/operator-screen/get-last-product-route-details';
  static var productMachineRoute =
      '$baseUrl/operator/operator-screen/create-product-machine-route';
  static var machineProductRouteDiffSeqNo =
      '$baseUrl/operator/operator-screen/product-machine-route-diff-seq';
  static var machineProductRouteDiffrevision =
      '$baseUrl/operator/operator-screen/product-machine-route-diff-revison';
  static var machineloginstatus =
      '$baseUrl/operator/operator-screen/machine-login-status';
  static var machinelogout = '$baseUrl/operator/operator-screen/machine-logout';
  static var toollist = '$baseUrl/operator/operator-screen/toollist';
  static var operatorRejectedReasons =
      '$baseUrl/operator/operator-screen/getoperatorrejresons';
  static var scanbarcodedata =
      '$baseUrl/operator/operator-screen/scanbarcodefunction';
  static var pendingproductlist =
      '$baseUrl/operator/operator-screen/pendingproductlist';
  static var productlistfromcapacityplan =
      '$baseUrl/operator/operator-screen/productlistfromcapacityplan';
  static var requestid = '$baseUrl/operator/operator-screen/requestid';

  static var productionjobStatusCheck =
      '$baseUrl/operator/operator-screen/productionjobStatus'; //inspection status check
  static var cpmessageStatusCheck =
      '$baseUrl/operator/operator-screen/cpmessageStatuscheck';
  static var prmessageStatusCheck =
      '$baseUrl/operator/operator-screen/prmessageStatuscheck';
  static var availablePR = '$baseUrl/operator/operator-screen/availablePR';
  static var cpmessageinsert =
      '$baseUrl/operator/operator-screen/cpmessageinsert';
  static var prmessageinsert =
      '$baseUrl/operator/operator-screen/prmessageinsert';
  static var getmachineuserdata =
      '$baseUrl/operator/operator-screen/getMachineuUerData';
  static var getInstructiondata =
      '$baseUrl/operator/operator-screen/getInstructiondata';
  static var inserttoollist =
      '$baseUrl/operator/operator-screen/inserttoollist';
  static var tabletloginloginsert =
      '$baseUrl/operator/operator-screen/tabletlogininsert';

  static var getstatusoffirstscanproductdetails =
      '$baseUrl/operator/operator-screen/getstatusoffirstscanproductdetails';
  static var insertfistscanproductCadlab =
      '$baseUrl/operator/operator-screen/insertfistscanproductCadlab';
  static var operatorworkstatusall =
      '$baseUrl/operator/operator-screen/operatorworkstatusall';

//Wathare API call
  static var jobStartAPI = '$indURI/v1/cloud/job-start';
  static var getdataAPI = '$indURI/v1/cloud/get-data';
  static var jobStopAPI = '$indURI/v1/cloud/job-stop'; //getMachineuUerData
  getprogramlist({required String machinename}) {
    return '$indURI/api/programs?machineId=$machinename';
  }

  //Program upload and downlode
  static var machineProgramListFromERP =
      '$baseUrl/operator/operator-screen/machineProgramListFromERP';
  static var mdocidfolder = '$baseUrl/documents/doc/mdocid-folder-data';
  static var machineprogramlist =
      '$baseUrl/operator/operator-screen/machineprogramlist';
  static var productprocessseq =
      '$baseUrl/operator/operator-screen/productprocessseq';
  static var programData =
      '$baseUrl/documents/doc/program-data'; //Mongodb documents data

  //Capacity plan
  static var runtimeRouteList =
      '$baseUrl/ppc/capacityPlan/runtime_route_list'; // Run time routr list

  ///employee overtime
  static var insertemployeeovertimedata =
      '$baseUrl/supervisor/emp/insert-overtime-data';
  static var insertchildemployeeovertimedata =
      '$baseUrl/supervisor/emp/insert-childovertime-data';
  static var employeeovertimedata =
      '$baseUrl/supervisor/emp/employee-overtime-data';
  static var detailsemployeeovertimedata =
      '$baseUrl/supervisor/emp/details-employee-overtime-data';
  static var updateemployeeovertimedata =
      '$baseUrl/supervisor/emp/update-overtime-data';
  static var polist = '$baseUrl/supervisor/emp/po-list';
  static var productlistfrompoid =
      '$baseUrl/supervisor/emp/productlist-from-soid';

  /// send bulk mail
  static var sendbulkmailurl =
      '$baseUrl/common/data/send-bulk-mail'; // Shift pattern list

  // Product assets management
  // Product registration
  static var uomUrl =
      '$baseUrl/common/data/unit-of-measurement-data'; // Unit of measurement data list
  static var productTypeurl =
      '$baseUrl/common/data/product-type-data'; //Product type data list

  // Product structure
  static var productData =
      '$baseUrl/product/all-products/product-list-for-fill-assembly-structure'; // Product list
  static var registerProductStructure =
      '$baseUrl/product/product-structure/register-product-structure'; // Register product structure
  static var productStructureTreeRepresentationUrl =
      '$baseUrl/product/product-structure/product-structure-tree-representation'; // Product structure tree reprentation
  static var updateProductDetails =
      '$baseUrl/product/product-structure/update-product-details'; // Update product details
  // static var registerChildProducts =
  //     '$baseUrl/product/product-structure/register-child-products'; // Register child products
  static var deleteProductFromProductStructure =
      '$baseUrl/product/product-structure/delete-product-from-product-structure'; // Delete product from product structure

  // Sales orders
  static var assemblyAllSalesOrders =
      '$baseUrl/orders/sales-orders/assembly-all-orders-data'; // All orders
  static var generateComponentRequirementUrl =
      '$baseUrl/orders/sales-orders/generate-assembly-component-requirement'; // Generate assembly component requirement
  static var discardComponentRequirementUrl =
      '$baseUrl/orders/sales-orders/discard-assembly-component-requirement'; // Discard assembly component requirement
  static var generatedComponentRequirementUrl =
      '$baseUrl/orders/sales-orders/selected-assemblies-component-requirements'; // Generated assembly copmponent requirements
  static var currentSalesordersForIssueStock =
      '$baseUrl/orders/sales-orders/current-sales-orders-for-issue'; // Current sales orders for issue Stock

  // Product inventory management
  static var registerProductStock =
      '$baseUrl/product/product-inventory-management/manage-product-inventory'; // Register product stock
  static var currentProductStock =
      '$baseUrl/product/product-inventory-management/product-current-stock'; // Current stock
  static var selectedProductIssuedStock =
      '$baseUrl/product/product-inventory-management/issued-stock'; // Issued stock
}
