class TicketResponseModel {
  String? msg;
  List<Data>? data;

  TicketResponseModel({this.msg, this.data});

  TicketResponseModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  String? bookingId;
  String? period;
  String? invoiceId;
  String? propId;
  String? buildingId;
  String? buildingName;
  String? buildingSuperviser;
  String? finSuperviser;
  String? buildingCaretaker;
  String? category;
  String? priority;
  String? description;
  String? propName;
  String? mobileNumber;
  String? unitNumber;
  String? userName;
  String? tokenId;
  String? ticketId;
  String? registerId;
  String? status;
  String? reopenFlag;
  String? date;
  String? assignTo;
  String? assignValue;
  String? coordBy;
  String? cordValue;
  String? labourcost;
  String? materialcost;
  String? petrolcost;
  String? adminPaid;
  String? sleepStatus;
  String? sleepTime;
  String? resolvedBy;
  String? closedBy;
  String? closeDate;
  String? team;
  String? duration;
  String? bookingDuration;
  String? source;
  String? assignToday;
  String? activeDays;
  String? snooze;
  String? handsup;
  String? ticketPoint;
  List<String>? images;

  Data(
      {this.id,
        this.bookingId,
        this.period,
        this.invoiceId,
        this.propId,
        this.buildingId,
        this.buildingName,
        this.buildingSuperviser,
        this.finSuperviser,
        this.buildingCaretaker,
        this.category,
        this.priority,
        this.description,
        this.propName,
        this.mobileNumber,
        this.unitNumber,
        this.userName,
        this.tokenId,
        this.ticketId,
        this.registerId,
        this.status,
        this.reopenFlag,
        this.date,
        this.assignTo,
        this.assignValue,
        this.coordBy,
        this.cordValue,
        this.labourcost,
        this.materialcost,
        this.petrolcost,
        this.adminPaid,
        this.sleepStatus,
        this.sleepTime,
        this.resolvedBy,
        this.closedBy,
        this.closeDate,
        this.team,
        this.duration,
        this.bookingDuration,
        this.source,
        this.assignToday,
        this.activeDays,
        this.snooze,
        this.handsup,
        this.ticketPoint,
        this.images});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingId = json['booking_id'];
    period = json['period'];
    invoiceId = json['invoice_id'];
    propId = json['prop_id'];
    buildingId = json['building_id'];
    buildingName = json['building_name'];
    buildingSuperviser = json['building_superviser'];
    finSuperviser = json['fin_superviser'];
    buildingCaretaker = json['building_caretaker'];
    category = json['Category'];
    priority = json['priority'];
    description = json['description'];
    propName = json['prop_name'];
    mobileNumber = json['mobile_number'];
    unitNumber = json['unit_number'];
    userName = json['user_name'];
    tokenId = json['token_id'];
    ticketId = json['ticket_id'];
    registerId = json['register_id'];
    status = json['status'];
    reopenFlag = json['reopen_flag'];
    date = json['date'];
    assignTo = json['assign_to'];
    assignValue = json['assign_value'];
    coordBy = json['coord_by'];
    cordValue = json['cord_value'];
    labourcost = json['labourcost'];
    materialcost = json['materialcost'];
    petrolcost = json['petrolcost'];
    adminPaid = json['admin_paid'];
    sleepStatus = json['sleep_status'];
    sleepTime = json['sleep_time'];
    resolvedBy = json['resolved_by'];
    closedBy = json['closed_by'];
    closeDate = json['close_date'];
    team = json['team'];
    duration = json['duration'];
    bookingDuration = json['booking_duration'];
    source = json['source'];
    assignToday = json['assign_today'];
    activeDays = json['active_days'];
    snooze = json['snooze'];
    handsup = json['handsup'];
    ticketPoint = json['ticket_point'];
    images = json['images'] != null ?json['images'].cast<String>():[];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['booking_id'] = this.bookingId;
    data['period'] = this.period;
    data['invoice_id'] = this.invoiceId;
    data['prop_id'] = this.propId;
    data['building_id'] = this.buildingId;
    data['building_name'] = this.buildingName;
    data['building_superviser'] = this.buildingSuperviser;
    data['fin_superviser'] = this.finSuperviser;
    data['building_caretaker'] = this.buildingCaretaker;
    data['Category'] = this.category;
    data['priority'] = this.priority;
    data['description'] = this.description;
    data['prop_name'] = this.propName;
    data['mobile_number'] = this.mobileNumber;
    data['unit_number'] = this.unitNumber;
    data['user_name'] = this.userName;
    data['token_id'] = this.tokenId;
    data['ticket_id'] = this.ticketId;
    data['register_id'] = this.registerId;
    data['status'] = this.status;
    data['reopen_flag'] = this.reopenFlag;
    data['date'] = this.date;
    data['assign_to'] = this.assignTo;
    data['assign_value'] = this.assignValue;
    data['coord_by'] = this.coordBy;
    data['cord_value'] = this.cordValue;
    data['labourcost'] = this.labourcost;
    data['materialcost'] = this.materialcost;
    data['petrolcost'] = this.petrolcost;
    data['admin_paid'] = this.adminPaid;
    data['sleep_status'] = this.sleepStatus;
    data['sleep_time'] = this.sleepTime;
    data['resolved_by'] = this.resolvedBy;
    data['closed_by'] = this.closedBy;
    data['close_date'] = this.closeDate;
    data['team'] = this.team;
    data['duration'] = this.duration;
    data['booking_duration'] = this.bookingDuration;
    data['source'] = this.source;
    data['assign_today'] = this.assignToday;
    data['active_days'] = this.activeDays;
    data['snooze'] = this.snooze;
    data['handsup'] = this.handsup;
    data['ticket_point'] = this.ticketPoint;
    data['images'] = this.images;
    return data;
  }
}