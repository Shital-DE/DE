// Author : Shital Gayakwad
// Created Date : 16 Nov 2023
// Description : Calibration model
// Modification : 11 June 2025 by Shital Gayakwad.

// Measuring instruments
class MeasuringInstruments {
  String? id;
  String? code;
  String? producttypeId;
  String? description;

  MeasuringInstruments(
      {this.id, this.code, this.producttypeId, this.description});

  MeasuringInstruments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    producttypeId = json['producttype_id'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['producttype_id'] = producttypeId;
    data['description'] = description;
    return data;
  }
}

// Instruments type data
class InstrumentsTypeData {
  String? id;
  String? description;
  String? code;

  InstrumentsTypeData({this.id, this.description, this.code});

  InstrumentsTypeData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['description'] = description;
    data['code'] = code;
    return data;
  }
}

// All Instruments Data
class AllInstrumentsData {
  String? instrumentname;
  String? instrumenttype;
  String? manufacturer;
  String? description;
  String? subcategory;
  String? id;
  String? instrumenttypeId;
  String? productId;

  AllInstrumentsData(
      {this.instrumentname,
      this.instrumenttype,
      this.manufacturer,
      this.description,
      this.subcategory,
      this.id,
      this.instrumenttypeId,
      this.productId});

  AllInstrumentsData.fromJson(Map<String, dynamic> json) {
    instrumentname = json['instrumentname'];
    instrumenttype = json['instrumenttype'];
    manufacturer = json['manufacturer'];
    description = json['description'];
    subcategory = json['subcategory'];
    id = json['id'];
    instrumenttypeId = json['instrumenttype_id'];
    productId = json['product_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['instrumentname'] = instrumentname;
    data['instrumenttype'] = instrumenttype;
    data['manufacturer'] = manufacturer;
    data['description'] = description;
    data['subcategory'] = subcategory;
    data['id'] = id;
    data['instrumenttype_id'] = instrumenttypeId;
    data['product_id'] = productId;
    return data;
  }
}

// Frequency
class Frequency {
  String? id;
  String? frequency;

  Frequency({this.id, this.frequency});

  Frequency.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    frequency = json['frequency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['frequency'] = frequency;
    return data;
  }
}

// Instruments purchase order
class InstrumentsPurchaseOrder {
  String? purchaseorder;
  String? id;

  InstrumentsPurchaseOrder({this.purchaseorder, this.id});

  InstrumentsPurchaseOrder.fromJson(Map<String, dynamic> json) {
    purchaseorder = json['purchaseorder'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['purchaseorder'] = purchaseorder;
    data['id'] = id;
    return data;
  }
}

// Current day instruments schedule registration
class CurrentDayInstrumentsRegistered {
  String? instrumentname;
  String? instrumenttype;
  String? cardnumber;
  String? measuringrange;
  String? startdate;
  String? duedate;
  String? frequency;
  int? purchaseorder;
  String? barcodeinformation;
  String? id;
  String? certificateMdocid;

  CurrentDayInstrumentsRegistered(
      {this.instrumentname,
      this.instrumenttype,
      this.cardnumber,
      this.measuringrange,
      this.startdate,
      this.duedate,
      this.frequency,
      this.purchaseorder,
      this.barcodeinformation,
      this.id,
      this.certificateMdocid});

  CurrentDayInstrumentsRegistered.fromJson(Map<String, dynamic> json) {
    instrumentname = json['instrumentname'];
    instrumenttype = json['instrumenttype'];
    cardnumber = json['cardnumber'];
    measuringrange = json['measuringrange'];
    startdate = json['startdate'];
    duedate = json['duedate'];
    frequency = json['frequency'];
    purchaseorder = json['purchaseorder'];
    barcodeinformation = json['barcodeinformation'];
    id = json['id'];
    certificateMdocid = json['certificate_mdocid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['instrumentname'] = instrumentname;
    data['instrumenttype'] = instrumenttype;
    data['cardnumber'] = cardnumber;
    data['measuringrange'] = measuringrange;
    data['startdate'] = startdate;
    data['duedate'] = duedate;
    data['frequency'] = frequency;
    data['purchaseorder'] = purchaseorder;
    data['barcodeinformation'] = barcodeinformation;
    data['id'] = id;
    data['certificate_mdocid'] = certificateMdocid;
    return data;
  }
}

// Calibration status
class CalibrationStatusModel {
  String? instrumentname;
  String? instrumenttype;
  String? cardnumber;
  String? measuringrange;
  String? startdate;
  String? duedate;
  String? frequency;
  int? purchaseorder;
  String? barcodeinformation;
  String? id;
  String? certificateMdocid;
  String? remainingTimeUntilDue;
  int? remainingTimeCategory;
  String? frequencyid;
  String? instrumentId;

  CalibrationStatusModel(
      {this.instrumentname,
      this.instrumenttype,
      this.cardnumber,
      this.measuringrange,
      this.startdate,
      this.duedate,
      this.frequency,
      this.purchaseorder,
      this.barcodeinformation,
      this.id,
      this.certificateMdocid,
      this.remainingTimeUntilDue,
      this.remainingTimeCategory,
      this.frequencyid,
      this.instrumentId});

  CalibrationStatusModel.fromJson(Map<String, dynamic> json) {
    instrumentname = json['instrumentname'];
    instrumenttype = json['instrumenttype'];
    cardnumber = json['cardnumber'];
    measuringrange = json['measuringrange'];
    startdate = json['startdate'];
    duedate = json['duedate'];
    frequency = json['frequency'];
    purchaseorder = json['purchaseorder'];
    barcodeinformation = json['barcodeinformation'];
    id = json['id'];
    certificateMdocid = json['certificate_mdocid'];
    remainingTimeUntilDue = json['remaining_time_until_due'];
    remainingTimeCategory = json['remaining_time_category'];
    frequencyid = json['frequencyid'];
    instrumentId = json['instrument_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['instrumentname'] = instrumentname;
    data['instrumenttype'] = instrumenttype;
    data['cardnumber'] = cardnumber;
    data['measuringrange'] = measuringrange;
    data['startdate'] = startdate;
    data['duedate'] = duedate;
    data['frequency'] = frequency;
    data['purchaseorder'] = purchaseorder;
    data['barcodeinformation'] = barcodeinformation;
    data['id'] = id;
    data['certificate_mdocid'] = certificateMdocid;
    data['remaining_time_until_due'] = remainingTimeUntilDue;
    data['remaining_time_category'] = remainingTimeCategory;
    data['frequencyid'] = frequencyid;
    data['instrument_id'] = instrumentId;
    return data;
  }
}

// Mail Addresses
class MailAddress {
  String? emailaddress;

  MailAddress({this.emailaddress});

  MailAddress.fromJson(Map<String, dynamic> json) {
    emailaddress = json['emailaddress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['emailaddress'] = emailaddress;
    return data;
  }
}

// Instrument measuring ranges
class InstrumentMeasuringRanges {
  String? measuringrange;

  InstrumentMeasuringRanges({this.measuringrange});

  InstrumentMeasuringRanges.fromJson(Map<String, dynamic> json) {
    measuringrange = json['measuringrange'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['measuringrange'] = measuringrange;
    return data;
  }
}

// One product
class OneProduct {
  String? code;
  String? description;

  OneProduct({this.code, this.description});

  OneProduct.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['description'] = description;
    return data;
  }
}

// All instrument orders
class AllInstrumentOrdersModel {
  String? id;
  String? fromrecipient;
  String? torecipient;
  String? formattedDate;
  String? customDateFormat;
  String? subject;
  String? mailcontent;

  AllInstrumentOrdersModel(
      {this.id,
      this.fromrecipient,
      this.torecipient,
      this.formattedDate,
      this.customDateFormat,
      this.subject,
      this.mailcontent});

  AllInstrumentOrdersModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fromrecipient = json['fromrecipient'];
    torecipient = json['torecipient'];
    formattedDate = json['formatted_date'];
    customDateFormat = json['custom_date_format'];
    subject = json['subject'];
    mailcontent = json['mailcontent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['fromrecipient'] = fromrecipient;
    data['torecipient'] = torecipient;
    data['formatted_date'] = formattedDate;
    data['custom_date_format'] = customDateFormat;
    data['subject'] = subject;
    data['mailcontent'] = mailcontent;
    return data;
  }
}

class MailContentElements {
  String? product,
      productDescription,
      drawingNumber,
      instrumentDescription,
      measuringRange,
      quantity,
      rejectedInstrumentId,
      rejectedInstrument,
      instrumentId;

  MailContentElements(
      {this.product,
      this.productDescription,
      this.drawingNumber,
      this.instrumentDescription,
      this.measuringRange,
      this.quantity,
      this.rejectedInstrumentId,
      this.rejectedInstrument,
      this.instrumentId});

  Map<String, dynamic> toJson() {
    return {
      'product': product,
      'productDescription': productDescription,
      'drawingNumber': drawingNumber,
      'instrumentDescription': instrumentDescription,
      'measuringRange': measuringRange,
      'quantity': quantity,
      'rejectedInstrumentId': rejectedInstrumentId,
      'rejectedInstrument': rejectedInstrument,
      'instrumentId': instrumentId
    };
  }
}

// Calibration reminder model
class CalibrationReminderModel {
  String? instrumentname;
  String? instrumenttype;
  String? cardnumber;
  String? measuringrange;
  String? startdate;
  String? duedate;
  String? id;

  CalibrationReminderModel(
      {this.instrumentname,
      this.instrumenttype,
      this.cardnumber,
      this.measuringrange,
      this.startdate,
      this.duedate,
      this.id});

  CalibrationReminderModel.fromJson(Map<String, dynamic> json) {
    instrumentname = json['instrumentname'];
    instrumenttype = json['instrumenttype'];
    cardnumber = json['cardnumber'];
    measuringrange = json['measuringrange'];
    startdate = json['startdate'];
    duedate = json['duedate'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['instrumentname'] = instrumentname;
    data['instrumenttype'] = instrumenttype;
    data['cardnumber'] = cardnumber;
    data['measuringrange'] = measuringrange;
    data['startdate'] = startdate;
    data['duedate'] = duedate;
    data['id'] = id;
    return data;
  }
}

// Outsourced instruments model
class OutsourcedInstrumentsModel {
  String? instrumentname;
  String? instrumenttype;
  String? cardnumber;
  String? measuringrange;
  String? employeeName;
  String? instrumentcalibrationscheduleId;
  String? id;
  String? startdate;
  String? duedate;
  String? frequency;
  String? certificateId;

  OutsourcedInstrumentsModel(
      {this.instrumentname,
      this.instrumenttype,
      this.cardnumber,
      this.measuringrange,
      this.employeeName,
      this.instrumentcalibrationscheduleId,
      this.id,
      this.startdate,
      this.duedate,
      this.frequency,
      this.certificateId});

  OutsourcedInstrumentsModel.fromJson(Map<String, dynamic> json) {
    instrumentname = json['instrumentname'];
    instrumenttype = json['instrumenttype'];
    cardnumber = json['cardnumber'];
    measuringrange = json['measuringrange'];
    employeeName = json['employee_name'];
    instrumentcalibrationscheduleId = json['instrumentcalibrationschedule_id'];
    id = json['id'];
    startdate = json['startdate'];
    duedate = json['duedate'];
    frequency = json['frequency'];
    certificateId = json['certificate_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['instrumentname'] = instrumentname;
    data['instrumenttype'] = instrumenttype;
    data['cardnumber'] = cardnumber;
    data['measuringrange'] = measuringrange;
    data['employee_name'] = employeeName;
    data['instrumentcalibrationschedule_id'] = instrumentcalibrationscheduleId;
    data['id'] = id;
    data['startdate'] = startdate;
    data['duedate'] = duedate;
    data['frequency'] = frequency;
    data['certificate_id'] = certificateId;
    return data;
  }
}

// Inward instruments model
class InwardInstrumentsModel {
  String? historyId, instrumentScheduleId, startdate, duedate, frequency;
  InwardInstrumentsModel(
      {this.historyId,
      this.instrumentScheduleId,
      this.startdate,
      this.duedate,
      this.frequency});
  InwardInstrumentsModel.fromJson(Map<String, dynamic> json) {
    historyId = json['historyId'];
    instrumentScheduleId = json['instrumentScheduleId'];
    startdate = json['startdate'];
    duedate = json['duedate'];
    frequency = json['frequency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['historyId'] = historyId;
    data['instrumentScheduleId'] = instrumentScheduleId;
    data['startdate'] = startdate;
    data['duedate'] = duedate;
    data['frequency'] = frequency;
    return data;
  }
}

// Send and collect instruments for calibration
class OutsorceWorkordersModel {
  int? challanno;
  String? outsourceDate;
  String? contractor;
  String? address1;
  String? outsourcedby;
  String? outsourceworkorderId;

  OutsorceWorkordersModel(
      {this.challanno,
      this.outsourceDate,
      this.contractor,
      this.address1,
      this.outsourcedby,
      this.outsourceworkorderId});

  OutsorceWorkordersModel.fromJson(Map<String, dynamic> json) {
    challanno = json['challanno'];
    outsourceDate = json['outsource_date'];
    contractor = json['contractor'];
    address1 = json['address1'];
    outsourcedby = json['outsourcedby'];
    outsourceworkorderId = json['outsourceworkorder_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['challanno'] = challanno;
    data['outsource_date'] = outsourceDate;
    data['contractor'] = contractor;
    data['address1'] = address1;
    data['outsourcedby'] = outsourcedby;
    data['outsourceworkorder_id'] = outsourceworkorderId;
    return data;
  }
}

// All instruments card numbers
class InstrumentsCardModel {
  String? id;
  String? instrumentId;
  String? cardnumber;

  InstrumentsCardModel({this.id, this.instrumentId, this.cardnumber});

  InstrumentsCardModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    instrumentId = json['instrument_id'];
    cardnumber = json['cardnumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['instrument_id'] = instrumentId;
    data['cardnumber'] = cardnumber;
    return data;
  }
}

// Instrument rejection reasons model
class InstrumentRejectionReasons {
  String? id;
  String? reason;

  InstrumentRejectionReasons({this.id, this.reason});

  InstrumentRejectionReasons.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['reason'] = reason;
    return data;
  }
}

// Rejected instruments data model for order new instrument under rejection
class RejectedInstrumentsNewOrderDataModel {
  String? instrumentId;
  String? instrumentscheduleId;
  String? instrumentname;
  String? cardnumber;
  String? measuringrange;
  String? description;
  String? product;
  String? productdescription;

  RejectedInstrumentsNewOrderDataModel(
      {this.instrumentId,
      this.instrumentscheduleId,
      this.instrumentname,
      this.cardnumber,
      this.measuringrange,
      this.description,
      this.product,
      this.productdescription});

  RejectedInstrumentsNewOrderDataModel.fromJson(Map<String, dynamic> json) {
    instrumentId = json['instrument_id'];
    instrumentscheduleId = json['instrumentschedule_id'];
    instrumentname = json['instrumentname'];
    cardnumber = json['cardnumber'];
    measuringrange = json['measuringrange'];
    description = json['description'];
    product = json['product'];
    productdescription = json['productdescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['instrument_id'] = instrumentId;
    data['instrumentschedule_id'] = instrumentscheduleId;
    data['instrumentname'] = instrumentname;
    data['cardnumber'] = cardnumber;
    data['measuringrange'] = measuringrange;
    data['description'] = description;
    data['product'] = product;
    data['productdescription'] = productdescription;
    return data;
  }
}

// Calibration history model
class CalibrationHistoryModel {
  String? instrumentname;
  String? instrumenttype;
  String? cardnumber;
  String? measuringrange;
  String? startdate;
  String? duedate;
  String? frequency;
  int? outwardchallanNo;
  String? outsourcedBy;
  String? contractor;
  String? remark;
  String? rejectedby;
  String? manufacturer;
  String? storagelocation;
  String? purchaseorder;
  String? barcodeinformation;
  String? scheduletableId;
  String? certificateMdocid;
  String? rejectionreason;
  String? updatedon;
  String? historytableId;

  CalibrationHistoryModel(
      {this.instrumentname,
      this.instrumenttype,
      this.cardnumber,
      this.measuringrange,
      this.startdate,
      this.duedate,
      this.frequency,
      this.outwardchallanNo,
      this.outsourcedBy,
      this.contractor,
      this.remark,
      this.rejectedby,
      this.manufacturer,
      this.storagelocation,
      this.purchaseorder,
      this.barcodeinformation,
      this.scheduletableId,
      this.certificateMdocid,
      this.rejectionreason,
      this.updatedon,
      this.historytableId});

  CalibrationHistoryModel.fromJson(Map<String, dynamic> json) {
    instrumentname = json['instrumentname'];
    instrumenttype = json['instrumenttype'];
    cardnumber = json['cardnumber'];
    measuringrange = json['measuringrange'];
    startdate = json['startdate'];
    duedate = json['duedate'];
    frequency = json['frequency'];
    outwardchallanNo = json['outwardchallan_no'];
    outsourcedBy = json['outsourced_by'];
    contractor = json['contractor'];
    remark = json['remark'];
    rejectedby = json['rejectedby'];
    manufacturer = json['manufacturer'];
    storagelocation = json['storagelocation'];
    purchaseorder = json['purchaseorder'];
    barcodeinformation = json['barcodeinformation'];
    scheduletableId = json['scheduletable_id'];
    certificateMdocid = json['certificate_mdocid'];
    rejectionreason = json['rejectionreason'];
    updatedon = json['updatedon'];
    historytableId = json['historytable_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['instrumentname'] = instrumentname;
    data['instrumenttype'] = instrumenttype;
    data['cardnumber'] = cardnumber;
    data['measuringrange'] = measuringrange;
    data['startdate'] = startdate;
    data['duedate'] = duedate;
    data['frequency'] = frequency;
    data['outwardchallan_no'] = outwardchallanNo;
    data['outsourced_by'] = outsourcedBy;
    data['contractor'] = contractor;
    data['remark'] = remark;
    data['rejectedby'] = rejectedby;
    data['manufacturer'] = manufacturer;
    data['storagelocation'] = storagelocation;
    data['purchaseorder'] = purchaseorder;
    data['barcodeinformation'] = barcodeinformation;
    data['scheduletable_id'] = scheduletableId;
    data['certificate_mdocid'] = certificateMdocid;
    data['rejectionreason'] = rejectionreason;
    data['updatedon'] = updatedon;
    data['historytable_id'] = historytableId;
    return data;
  }
}

// One instrument order
class OneInstrumentOrder {
  String? drawingNumber;
  String? instrumentDescription;
  String? product;
  String? productDescription;
  String? measuringrange;
  int? quantity;
  String? againstRejection;
  String? id;
  String? instrumentId;
  String? mailId;
  String? rejectedinstrumentId;

  OneInstrumentOrder(
      {this.drawingNumber,
      this.instrumentDescription,
      this.product,
      this.productDescription,
      this.measuringrange,
      this.quantity,
      this.againstRejection,
      this.id,
      this.instrumentId,
      this.mailId,
      this.rejectedinstrumentId});

  OneInstrumentOrder.fromJson(Map<String, dynamic> json) {
    drawingNumber = json['drawing_number'];
    instrumentDescription = json['instrument_description'];
    product = json['product'];
    productDescription = json['product_description'];
    measuringrange = json['measuringrange'];
    quantity = json['quantity'];
    againstRejection = json['against_rejection'];
    id = json['id'];
    instrumentId = json['instrument_id'];
    mailId = json['mail_id'];
    rejectedinstrumentId = json['rejectedinstrument_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['drawing_number'] = drawingNumber;
    data['instrument_description'] = instrumentDescription;
    data['product'] = product;
    data['product_description'] = productDescription;
    data['measuringrange'] = measuringrange;
    data['quantity'] = quantity;
    data['against_rejection'] = againstRejection;
    data['id'] = id;
    data['instrument_id'] = instrumentId;
    data['mail_id'] = mailId;
    data['rejectedinstrument_id'] = rejectedinstrumentId;
    return data;
  }
}

// Manufacturer data
class ManufacturerData {
  String? id;
  String? manufacturer;

  ManufacturerData({this.id, this.manufacturer});

  ManufacturerData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    manufacturer = json['manufacturer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['manufacturer'] = manufacturer;
    return data;
  }
}

// Stored instruments data
class StoredInstrumentsModel {
  String? instrumentname;
  String? instrumenttype;
  String? cardnumber;
  String? measuringrange;
  String? startdate;
  String? duedate;
  String? manufacturer;
  String? storagelocation;
  String? storedby;
  String? storedon;
  String? id;
  String? instrumentcalibrationscheduleId;
  String? certificateMdocid;

  StoredInstrumentsModel(
      {this.instrumentname,
      this.instrumenttype,
      this.cardnumber,
      this.measuringrange,
      this.startdate,
      this.duedate,
      this.manufacturer,
      this.storagelocation,
      this.storedby,
      this.storedon,
      this.id,
      this.instrumentcalibrationscheduleId,
      this.certificateMdocid});

  StoredInstrumentsModel.fromJson(Map<String, dynamic> json) {
    instrumentname = json['instrumentname'];
    instrumenttype = json['instrumenttype'];
    cardnumber = json['cardnumber'];
    measuringrange = json['measuringrange'];
    startdate = json['startdate'];
    duedate = json['duedate'];
    manufacturer = json['manufacturer'];
    storagelocation = json['storagelocation'];
    storedby = json['storedby'];
    storedon = json['storedon'];
    id = json['id'];
    instrumentcalibrationscheduleId = json['instrumentcalibrationschedule_id'];
    certificateMdocid = json['certificate_mdocid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['instrumentname'] = instrumentname;
    data['instrumenttype'] = instrumenttype;
    data['cardnumber'] = cardnumber;
    data['measuringrange'] = measuringrange;
    data['startdate'] = startdate;
    data['duedate'] = duedate;
    data['manufacturer'] = manufacturer;
    data['storagelocation'] = storagelocation;
    data['storedby'] = storedby;
    data['storedon'] = storedon;
    data['id'] = id;
    data['instrumentcalibrationschedule_id'] = instrumentcalibrationscheduleId;
    data['certificate_mdocid'] = certificateMdocid;
    return data;
  }
}

// Rejected instruments model
class RejectedInstrumentsModel {
  String? instrumentname;
  String? cardnumber;
  String? measuringrange;
  String? rejectedDate;
  String? rejectedby;
  String? rejectionReason;
  String? historyId;
  String? instrumentcalibrationscheduleId;
  String? instrumentId;
  String? certificateId;
  String? remark;

  RejectedInstrumentsModel(
      {this.instrumentname,
      this.cardnumber,
      this.measuringrange,
      this.rejectedDate,
      this.rejectedby,
      this.rejectionReason,
      this.historyId,
      this.instrumentcalibrationscheduleId,
      this.instrumentId,
      this.certificateId,
      this.remark});

  RejectedInstrumentsModel.fromJson(Map<String, dynamic> json) {
    instrumentname = json['instrumentname'];
    cardnumber = json['cardnumber'];
    measuringrange = json['measuringrange'];
    rejectedDate = json['rejected_date'];
    rejectedby = json['rejectedby'];
    rejectionReason = json['rejection_reason'];
    historyId = json['history_id'];
    instrumentcalibrationscheduleId = json['instrumentcalibrationschedule_id'];
    instrumentId = json['instrument_id'];
    certificateId = json['certificate_id'];
    remark = json['remark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['instrumentname'] = instrumentname;
    data['cardnumber'] = cardnumber;
    data['measuringrange'] = measuringrange;
    data['rejected_date'] = rejectedDate;
    data['rejectedby'] = rejectedby;
    data['rejection_reason'] = rejectionReason;
    data['history_id'] = historyId;
    data['instrumentcalibrationschedule_id'] = instrumentcalibrationscheduleId;
    data['instrument_id'] = instrumentId;
    data['certificate_id'] = certificateId;
    data['remark'] = remark;
    return data;
  }
}

class AvailableInstrumentsModel {
  String? instrumentname;
  String? cardnumber;
  String? measuringrange;
  String? instrumenttype;
  String? startdate;
  String? duedate;
  String? frequency;
  String? certificateMdocid;
  String? instrumentscheduleId;
  String? instrumentId;

  AvailableInstrumentsModel(
      {this.instrumentname,
      this.cardnumber,
      this.measuringrange,
      this.instrumenttype,
      this.startdate,
      this.duedate,
      this.frequency,
      this.certificateMdocid,
      this.instrumentscheduleId,
      this.instrumentId});

  AvailableInstrumentsModel.fromJson(Map<String, dynamic> json) {
    instrumentname = json['instrumentname'];
    cardnumber = json['cardnumber'];
    measuringrange = json['measuringrange'];
    instrumenttype = json['instrumenttype'];
    startdate = json['startdate'];
    duedate = json['duedate'];
    frequency = json['frequency'];
    certificateMdocid = json['certificate_mdocid'];
    instrumentscheduleId = json['instrumentschedule_id'];
    instrumentId = json['instrument_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['instrumentname'] = instrumentname;
    data['cardnumber'] = cardnumber;
    data['measuringrange'] = measuringrange;
    data['instrumenttype'] = instrumenttype;
    data['startdate'] = startdate;
    data['duedate'] = duedate;
    data['frequency'] = frequency;
    data['certificate_mdocid'] = certificateMdocid;
    data['instrumentschedule_id'] = instrumentscheduleId;
    data['instrument_id'] = instrumentId;
    return data;
  }
}

class ReclaimOutsourcedInstrumentsModel {
  String? instrumentname;
  String? instrumenttype;
  String? cardnumber;
  String? measuringrange;
  String? startdate;
  String? duedate;
  String? frequency;
  String? instrumentcalibrationscheduleId;
  String? instrumentId;
  String? frequencyId;
  String? certificateMdocid;

  ReclaimOutsourcedInstrumentsModel(
      {this.instrumentname,
      this.instrumenttype,
      this.cardnumber,
      this.measuringrange,
      this.startdate,
      this.duedate,
      this.frequency,
      this.instrumentcalibrationscheduleId,
      this.instrumentId,
      this.frequencyId,
      this.certificateMdocid});

  ReclaimOutsourcedInstrumentsModel.fromJson(Map<String, dynamic> json) {
    instrumentname = json['instrumentname'];
    instrumenttype = json['instrumenttype'];
    cardnumber = json['cardnumber'];
    measuringrange = json['measuringrange'];
    startdate = json['startdate'];
    duedate = json['duedate'];
    frequency = json['frequency'];
    instrumentcalibrationscheduleId = json['instrumentcalibrationschedule_id'];
    instrumentId = json['instrument_id'];
    frequencyId = json['frequency_id'];
    certificateMdocid = json['certificate_mdocid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['instrumentname'] = instrumentname;
    data['instrumenttype'] = instrumenttype;
    data['cardnumber'] = cardnumber;
    data['measuringrange'] = measuringrange;
    data['startdate'] = startdate;
    data['duedate'] = duedate;
    data['frequency'] = frequency;
    data['instrumentcalibrationschedule_id'] = instrumentcalibrationscheduleId;
    data['instrument_id'] = instrumentId;
    data['frequency_id'] = frequencyId;
    data['certificate_mdocid'] = certificateMdocid;
    return data;
  }
}

// Instrument outsource history by contractor model
class InstrumentOutsourceHistoryBySubcontractorModel {
  String? vendorname;
  int? outwardchallanNo;
  List<String>? instrumentname;
  List<String>? instrumenttype;
  List<String>? cardnumber;
  List<String>? measuringrange;
  List<String>? startdate;
  List<String>? duedate;
  List<String>? outsourcedBy;
  List<String>? historyId;
  String? subcontractorId;
  List<String>? updatedon;
  List<String>? createdby;
  List<String>? instrumentcalibrationscheduleId;
  List<String>? certificateId;
  List<String>? outsourceworkorderId;
  List<String>? frequency;
  List<String>? remark;

  InstrumentOutsourceHistoryBySubcontractorModel(
      {this.vendorname,
      this.outwardchallanNo,
      this.instrumentname,
      this.instrumenttype,
      this.cardnumber,
      this.measuringrange,
      this.startdate,
      this.duedate,
      this.outsourcedBy,
      this.historyId,
      this.subcontractorId,
      this.updatedon,
      this.createdby,
      this.instrumentcalibrationscheduleId,
      this.certificateId,
      this.outsourceworkorderId,
      this.frequency,
      this.remark});

  InstrumentOutsourceHistoryBySubcontractorModel.fromJson(
      Map<String, dynamic> json) {
    vendorname = json['vendorname'];
    outwardchallanNo = json['outwardchallan_no'];
    instrumentname = json['instrumentname'].cast<String>();
    instrumenttype = json['instrumenttype'].cast<String>();
    cardnumber = json['cardnumber'].cast<String>();
    measuringrange = json['measuringrange'].cast<String>();
    startdate = json['startdate'].cast<String>();
    duedate = json['duedate'].cast<String>();
    outsourcedBy = json['outsourced_by'].cast<String>();
    historyId = json['history_id'].cast<String>();
    subcontractorId = json['subcontractor_id'];
    updatedon = json['updatedon'].cast<String>();
    createdby = json['createdby'].cast<String>();
    instrumentcalibrationscheduleId =
        json['instrumentcalibrationschedule_id'].cast<String>();
    certificateId = json['certificate_id'].cast<String>();
    outsourceworkorderId = json['outsourceworkorder_id'].cast<String>();
    frequency = json['frequency'].cast<String>();
    remark = json['remark'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['vendorname'] = vendorname;
    data['outwardchallan_no'] = outwardchallanNo;
    data['instrumentname'] = instrumentname;
    data['instrumenttype'] = instrumenttype;
    data['cardnumber'] = cardnumber;
    data['measuringrange'] = measuringrange;
    data['startdate'] = startdate;
    data['duedate'] = duedate;
    data['outsourced_by'] = outsourcedBy;
    data['history_id'] = historyId;
    data['subcontractor_id'] = subcontractorId;
    data['updatedon'] = updatedon;
    data['createdby'] = createdby;
    data['instrumentcalibrationschedule_id'] = instrumentcalibrationscheduleId;
    data['certificate_id'] = certificateId;
    data['outsourceworkorder_id'] = outsourceworkorderId;
    data['frequency'] = frequency;
    data['remark'] = remark;
    return data;
  }
}
