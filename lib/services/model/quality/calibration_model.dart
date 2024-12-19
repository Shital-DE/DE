// Author : Shital Gayakwad
// Created Date : 16 Nov 2023
// Description : Calibration model

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
      this.frequencyid});

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
  String? purchaseorder;
  String? barcodeinformation;
  String? scheduletableId;
  String? certificateMdocid;
  String? rejectionreason;
  String? rejectiondate;
  String? rejectedby;
  String? manufacturer;
  String? storagelocation;
  String? historytableId;

  CalibrationHistoryModel(
      {this.instrumentname,
      this.instrumenttype,
      this.cardnumber,
      this.measuringrange,
      this.startdate,
      this.duedate,
      this.frequency,
      this.purchaseorder,
      this.barcodeinformation,
      this.scheduletableId,
      this.certificateMdocid,
      this.rejectionreason,
      this.rejectiondate,
      this.rejectedby,
      this.manufacturer,
      this.storagelocation,
      this.historytableId});

  CalibrationHistoryModel.fromJson(Map<String, dynamic> json) {
    instrumentname = json['instrumentname'];
    instrumenttype = json['instrumenttype'];
    cardnumber = json['cardnumber'];
    measuringrange = json['measuringrange'];
    startdate = json['startdate'];
    duedate = json['duedate'];
    frequency = json['frequency'];
    purchaseorder = json['purchaseorder'];
    barcodeinformation = json['barcodeinformation'];
    scheduletableId = json['scheduletable_id'];
    certificateMdocid = json['certificate_mdocid'];
    rejectionreason = json['rejectionreason'];
    rejectiondate = json['rejectiondate'];
    rejectedby = json['rejectedby'];
    manufacturer = json['manufacturer'];
    storagelocation = json['storagelocation'];
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
    data['purchaseorder'] = purchaseorder;
    data['barcodeinformation'] = barcodeinformation;
    data['scheduletable_id'] = scheduletableId;
    data['certificate_mdocid'] = certificateMdocid;
    data['rejectionreason'] = rejectionreason;
    data['rejectiondate'] = rejectiondate;
    data['rejectedby'] = rejectedby;
    data['manufacturer'] = manufacturer;
    data['storagelocation'] = storagelocation;
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
      this.certificateId});

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
    return data;
  }
}
