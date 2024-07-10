// GENERATED CODE - DO NOT MODIFY BY HAND

part of craft_dynamic;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StandingOrder _$StandingOrderFromJson(Map<String, dynamic> json) =>
    StandingOrder(
      amount: (json['Amount'] as num?)?.toDouble(),
      standingOrderID: json['SOID'] as String?,
      effectiveDate: json['EffectiveDate'] as String?,
      frequencyID: json['FrequencyID'] as String?,
      lastExecutionDate: json['LastExecutionDate'] as String?,
      createdBy: json['CreatedBy'] as String?,
      requestData: json['RequestData'] as String?,
    );

Map<String, dynamic> _$StandingOrderToJson(StandingOrder instance) =>
    <String, dynamic>{
      'Amount': instance.amount,
      'SOID': instance.standingOrderID,
      'EffectiveDate': instance.effectiveDate,
      'FrequencyID': instance.frequencyID,
      'LastExecutionDate': instance.lastExecutionDate,
      'CreatedBy': instance.createdBy,
      'RequestData': instance.requestData,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MenuBorderAdapter extends TypeAdapter<MenuBorder> {
  @override
  final int typeId = 16;

  @override
  MenuBorder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MenuBorder(
      radius: fields[0] as double?,
      color: fields[1] as String?,
      width: fields[2] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, MenuBorder obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.radius)
      ..writeByte(1)
      ..write(obj.color)
      ..writeByte(2)
      ..write(obj.width);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MenuBorderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MenuPropertiesAdapter extends TypeAdapter<MenuProperties> {
  @override
  final int typeId = 17;

  @override
  MenuProperties read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MenuProperties(
        iconSize: fields[0] as double?,
        padding: fields[1] as double?,
        elevation: fields[2] as double?,
        backgroundColor: fields[3] as String?,
        spaceBetween: fields[4] as String?,
        alignment: fields[5] as String?,
        axisDirection: fields[6] as String?,
        textSize: fields[7] as double?,
        fontWeight: fields[8] as String?);
  }

  @override
  void write(BinaryWriter writer, MenuProperties obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.iconSize)
      ..writeByte(1)
      ..write(obj.padding)
      ..writeByte(2)
      ..write(obj.elevation)
      ..writeByte(3)
      ..write(obj.backgroundColor)
      ..writeByte(4)
      ..write(obj.spaceBetween)
      ..writeByte(5)
      ..write(obj.alignment)
      ..writeByte(6)
      ..write(obj.axisDirection)
      ..writeByte(7)
      ..write(obj.textSize)
      ..writeByte(8)
      ..write(obj.fontWeight);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MenuPropertiesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BlockSpacingAdapter extends TypeAdapter<BlockSpacing> {
  @override
  final int typeId = 18;

  @override
  BlockSpacing read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BlockSpacing(
      crossAxis: fields[0] as double?,
      mainAxis: fields[1] as double?,
      axisCount: fields[2] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, BlockSpacing obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.crossAxis)
      ..writeByte(1)
      ..write(obj.mainAxis)
      ..writeByte(2)
      ..write(obj.axisCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BlockSpacingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ModuleItemAdapter extends TypeAdapter<ModuleItem> {
  @override
  final int typeId = 1;

  @override
  ModuleItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModuleItem(
        parentModule: fields[1] as String,
        moduleUrl: fields[4] as String?,
        moduleId: fields[0] as String,
        moduleName: fields[2] as String,
        moduleCategory: fields[3] as String?,
        merchantID: fields[6] as String?,
        isMainMenu: fields[7] as bool?,
        isDisabled: fields[8] as bool?,
        isHidden: fields[9] as bool?,
        moduleUrl2: fields[5] as String?,
        displayOrder: fields[10] as double?,
        blockAspectRatio: fields[11] as double?,
        isDBCall: fields[12] as bool?,
        header: fields[13] as String?,
        menuBorder: fields[14] as MenuBorder?,
        menuProperties: fields[15] as MenuProperties?,
        blockSpacing: fields[16] as BlockSpacing?,
        moduleDescription: fields[17] as String?,
        isBankCall: fields[18] as bool?);
  }

  @override
  void write(BinaryWriter writer, ModuleItem obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.moduleId)
      ..writeByte(1)
      ..write(obj.parentModule)
      ..writeByte(2)
      ..write(obj.moduleName)
      ..writeByte(3)
      ..write(obj.moduleCategory)
      ..writeByte(4)
      ..write(obj.moduleUrl)
      ..writeByte(5)
      ..write(obj.moduleUrl2)
      ..writeByte(6)
      ..write(obj.merchantID)
      ..writeByte(7)
      ..write(obj.isMainMenu)
      ..writeByte(8)
      ..write(obj.isDisabled)
      ..writeByte(9)
      ..write(obj.isHidden)
      ..writeByte(10)
      ..write(obj.displayOrder)
      ..writeByte(11)
      ..write(obj.blockAspectRatio)
      ..writeByte(12)
      ..write(obj.isDBCall)
      ..writeByte(13)
      ..write(obj.header)
      ..writeByte(14)
      ..write(obj.menuBorder)
      ..writeByte(15)
      ..write(obj.menuProperties)
      ..writeByte(16)
      ..write(obj.blockSpacing)
      ..writeByte(17)
      ..write(obj.moduleDescription)
      ..writeByte(18)
      ..write(obj.isBankCall);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModuleItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FormItemAdapter extends TypeAdapter<FormItem> {
  @override
  final int typeId = 2;

  @override
  FormItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FormItem(
        controlType: fields[1] as String?,
        controlText: fields[2] as String?,
        moduleId: fields[3] as String?,
        linkedToControl: fields[7] as String?,
        controlId: fields[4] as String?,
        containerID: fields[5] as String?,
        actionId: fields[6] as String?,
        formSequence: fields[8] as int?,
        serviceParamId: fields[9] as String?,
        displayOrder: fields[10] as double?,
        controlFormat: fields[11] as String?,
        dataSourceId: fields[12] as String?,
        controlValue: fields[13] as String?,
        isMandatory: fields[14] as bool?,
        isEncrypted: fields[15] as bool?,
        minValue: fields[16] as String?,
        maxValue: fields[17] as String?,
        hidden: fields[18] as bool?,
        linkedToRowID: fields[19] as String?,
        isEnabled: fields[20] as bool?,
        rowID: fields[21] as int?,
        verticalPadding: fields[22] as double?,
        formID: fields[23] as String?,
        route: fields[24] as String?,
        merchantID: fields[25] as String?,
        hasInitialValue: fields[26] as bool?,
        countries: fields[27] as List<String>?,
        leadingDigits: fields[28] as List<String>?,
        maxLength: fields[29] as int?,
        maxLines: fields[30] as int?,
        isTransactional: fields[31] as bool?)
      ..no = fields[0] as int?;
  }

  @override
  void write(BinaryWriter writer, FormItem obj) {
    writer
      ..writeByte(32)
      ..writeByte(0)
      ..write(obj.no)
      ..writeByte(1)
      ..write(obj.controlType)
      ..writeByte(2)
      ..write(obj.controlText)
      ..writeByte(3)
      ..write(obj.moduleId)
      ..writeByte(4)
      ..write(obj.controlId)
      ..writeByte(5)
      ..write(obj.containerID)
      ..writeByte(6)
      ..write(obj.actionId)
      ..writeByte(7)
      ..write(obj.linkedToControl)
      ..writeByte(8)
      ..write(obj.formSequence)
      ..writeByte(9)
      ..write(obj.serviceParamId)
      ..writeByte(10)
      ..write(obj.displayOrder)
      ..writeByte(11)
      ..write(obj.controlFormat)
      ..writeByte(12)
      ..write(obj.dataSourceId)
      ..writeByte(13)
      ..write(obj.controlValue)
      ..writeByte(14)
      ..write(obj.isMandatory)
      ..writeByte(15)
      ..write(obj.isEncrypted)
      ..writeByte(16)
      ..write(obj.minValue)
      ..writeByte(17)
      ..write(obj.maxValue)
      ..writeByte(18)
      ..write(obj.hidden)
      ..writeByte(19)
      ..write(obj.linkedToRowID)
      ..writeByte(20)
      ..write(obj.isEnabled)
      ..writeByte(21)
      ..write(obj.rowID)
      ..writeByte(22)
      ..write(obj.verticalPadding)
      ..writeByte(23)
      ..write(obj.formID)
      ..writeByte(24)
      ..write(obj.route)
      ..writeByte(25)
      ..write(obj.merchantID)
      ..writeByte(26)
      ..write(obj.hasInitialValue)
      ..writeByte(27)
      ..write(obj.countries)
      ..writeByte(28)
      ..write(obj.leadingDigits)
      ..writeByte(29)
      ..write(obj.maxLength)
      ..writeByte(30)
      ..write(obj.maxLines)
      ..writeByte(31)
      ..write(obj.isTransactional);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FormItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ActionItemAdapter extends TypeAdapter<ActionItem> {
  @override
  final int typeId = 3;

  @override
  ActionItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ActionItem(
      moduleID: fields[1] as String,
      actionType: fields[2] as String,
      webHeader: fields[3] as String,
      controlID: fields[4] as String?,
      displayFormID: fields[5] as String?,
      confirmationModuleID: fields[6] as String?,
      merchantID: fields[7] as String?,
    )..no = fields[0] as int?;
  }

  @override
  void write(BinaryWriter writer, ActionItem obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.no)
      ..writeByte(1)
      ..write(obj.moduleID)
      ..writeByte(2)
      ..write(obj.actionType)
      ..writeByte(3)
      ..write(obj.webHeader)
      ..writeByte(4)
      ..write(obj.controlID)
      ..writeByte(5)
      ..write(obj.displayFormID)
      ..writeByte(6)
      ..write(obj.confirmationModuleID)
      ..writeByte(7)
      ..write(obj.merchantID);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActionItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserCodeAdapter extends TypeAdapter<UserCode> {
  @override
  final int typeId = 4;

  @override
  UserCode read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserCode(
      id: fields[1] as String,
      subCodeId: fields[2] as String,
      description: fields[3] as String?,
      relationId: fields[4] as String?,
      extraField: fields[5] as String?,
      displayOrder: fields[6] as int?,
      isDefault: fields[7] as bool?,
      extraFieldName: fields[8] as String?,
    )..no = fields[0] as int?;
  }

  @override
  void write(BinaryWriter writer, UserCode obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.no)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.subCodeId)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.relationId)
      ..writeByte(5)
      ..write(obj.extraField)
      ..writeByte(6)
      ..write(obj.displayOrder)
      ..writeByte(7)
      ..write(obj.isDefault)
      ..writeByte(8)
      ..write(obj.extraFieldName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserCodeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OnlineAccountProductAdapter extends TypeAdapter<OnlineAccountProduct> {
  @override
  final int typeId = 5;

  @override
  OnlineAccountProduct read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OnlineAccountProduct(
      id: fields[2] as String?,
      description: fields[3] as String?,
      relationId: fields[4] as String?,
      url: fields[5] as String?,
    )..no = fields[0] as int?;
  }

  @override
  void write(BinaryWriter writer, OnlineAccountProduct obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.no)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.relationId)
      ..writeByte(5)
      ..write(obj.url);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OnlineAccountProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BankBranchAdapter extends TypeAdapter<BankBranch> {
  @override
  final int typeId = 6;

  @override
  BankBranch read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BankBranch(
      description: fields[1] as String?,
      relationId: fields[2] as String?,
    )..no = fields[0] as int?;
  }

  @override
  void write(BinaryWriter writer, BankBranch obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.no)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.relationId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BankBranchAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ImageDataAdapter extends TypeAdapter<ImageData> {
  @override
  final int typeId = 7;

  @override
  ImageData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ImageData(
      no: fields[0] as int?,
      imageUrl: fields[1] as String?,
      imageInfoUrl: fields[2] as String?,
      imageCategory: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ImageData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.no)
      ..writeByte(1)
      ..write(obj.imageUrl)
      ..writeByte(2)
      ..write(obj.imageInfoUrl)
      ..writeByte(3)
      ..write(obj.imageCategory);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImageDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AtmLocationAdapter extends TypeAdapter<AtmLocation> {
  @override
  final int typeId = 8;

  @override
  AtmLocation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AtmLocation(
      longitude: fields[1] as double,
      latitude: fields[2] as double,
      location: fields[3] as String,
    )..no = fields[0] as int?;
  }

  @override
  void write(BinaryWriter writer, AtmLocation obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.no)
      ..writeByte(1)
      ..write(obj.longitude)
      ..writeByte(2)
      ..write(obj.latitude)
      ..writeByte(3)
      ..write(obj.location);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AtmLocationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BranchLocationAdapter extends TypeAdapter<BranchLocation> {
  @override
  final int typeId = 9;

  @override
  BranchLocation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BranchLocation(
      longitude: fields[1] as double,
      latitude: fields[2] as double,
      location: fields[3] as String,
    )..no = fields[0] as int?;
  }

  @override
  void write(BinaryWriter writer, BranchLocation obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.no)
      ..writeByte(1)
      ..write(obj.longitude)
      ..writeByte(2)
      ..write(obj.latitude)
      ..writeByte(3)
      ..write(obj.location);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BranchLocationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BankAccountAdapter extends TypeAdapter<BankAccount> {
  @override
  final int typeId = 10;

  @override
  BankAccount read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BankAccount(
        bankAccountId: fields[1] as String,
        aliasName: fields[2] as String,
        currencyID: fields[3] as String,
        accountType: fields[4] as String,
        groupAccount: fields[5] as bool,
        defaultAccount: fields[6] as bool,
        isTransactional: fields[7] as bool?,
        isDisabled: fields[8] as bool?,
        branchID: fields[9] as String?,
        productID: fields[10] as String?)
      ..no = fields[0] as int?;
  }

  @override
  void write(BinaryWriter writer, BankAccount obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.no)
      ..writeByte(1)
      ..write(obj.bankAccountId)
      ..writeByte(2)
      ..write(obj.aliasName)
      ..writeByte(3)
      ..write(obj.currencyID)
      ..writeByte(4)
      ..write(obj.accountType)
      ..writeByte(5)
      ..write(obj.groupAccount)
      ..writeByte(6)
      ..write(obj.defaultAccount)
      ..writeByte(7)
      ..write(obj.isTransactional)
      ..writeByte(8)
      ..write(obj.isDisabled)
      ..writeByte(9)
      ..write(obj.branchID)
      ..writeByte(10)
      ..write(obj.productID);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BankAccountAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FrequentAccessedModuleAdapter
    extends TypeAdapter<FrequentAccessedModule> {
  @override
  final int typeId = 11;

  @override
  FrequentAccessedModule read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FrequentAccessedModule(
      parentModule: fields[1] as String,
      moduleID: fields[2] as String,
      moduleName: fields[3] as String,
      moduleCategory: fields[4] as String,
      moduleUrl: fields[5] as String,
      merchantID: fields[8] as String?,
      badgeColor: fields[6] as String?,
      badgeText: fields[7] as String?,
      displayOrder: fields[9] as double?,
      containerID: fields[10] as String?,
      lastAccessed: fields[11] as String?,
    )..no = fields[0] as int?;
  }

  @override
  void write(BinaryWriter writer, FrequentAccessedModule obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.no)
      ..writeByte(1)
      ..write(obj.parentModule)
      ..writeByte(2)
      ..write(obj.moduleID)
      ..writeByte(3)
      ..write(obj.moduleName)
      ..writeByte(4)
      ..write(obj.moduleCategory)
      ..writeByte(5)
      ..write(obj.moduleUrl)
      ..writeByte(6)
      ..write(obj.badgeColor)
      ..writeByte(7)
      ..write(obj.badgeText)
      ..writeByte(8)
      ..write(obj.merchantID)
      ..writeByte(9)
      ..write(obj.displayOrder)
      ..writeByte(10)
      ..write(obj.containerID)
      ..writeByte(11)
      ..write(obj.lastAccessed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FrequentAccessedModuleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BeneficiaryAdapter extends TypeAdapter<Beneficiary> {
  @override
  final int typeId = 12;

  @override
  Beneficiary read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Beneficiary(
      merchantID: fields[2] as String,
      merchantName: fields[3] as String,
      accountID: fields[4] as String,
      accountAlias: fields[5] as String,
      rowId: fields[1] as int,
      bankID: fields[6] as String?,
      branchID: fields[7] as String?,
    )..no = fields[0] as int?;
  }

  @override
  void write(BinaryWriter writer, Beneficiary obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.no)
      ..writeByte(1)
      ..write(obj.rowId)
      ..writeByte(2)
      ..write(obj.merchantID)
      ..writeByte(3)
      ..write(obj.merchantName)
      ..writeByte(4)
      ..write(obj.accountID)
      ..writeByte(5)
      ..write(obj.accountAlias)
      ..writeByte(6)
      ..write(obj.bankID)
      ..writeByte(7)
      ..write(obj.branchID);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BeneficiaryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ModuleToHideAdapter extends TypeAdapter<ModuleToHide> {
  @override
  final int typeId = 13;

  @override
  ModuleToHide read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModuleToHide(
      moduleId: fields[1] as String,
    )..no = fields[0] as int?;
  }

  @override
  void write(BinaryWriter writer, ModuleToHide obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.no)
      ..writeByte(1)
      ..write(obj.moduleId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModuleToHideAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ModuleToDisableAdapter extends TypeAdapter<ModuleToDisable> {
  @override
  final int typeId = 14;

  @override
  ModuleToDisable read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModuleToDisable(
      moduleID: fields[1] as String,
      merchantID: fields[2] as String?,
      displayMessage: fields[3] as String?,
    )..no = fields[0] as int?;
  }

  @override
  void write(BinaryWriter writer, ModuleToDisable obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.no)
      ..writeByte(1)
      ..write(obj.moduleID)
      ..writeByte(2)
      ..write(obj.merchantID)
      ..writeByte(3)
      ..write(obj.displayMessage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModuleToDisableAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PendingTrxDisplayAdapter extends TypeAdapter<PendingTrxDisplay> {
  @override
  final int typeId = 15;

  @override
  PendingTrxDisplay read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PendingTrxDisplay(
      name: fields[1] as String,
      comments: fields[2] as String,
      transactionType: fields[3] as String,
      sendTo: fields[4] as String,
      amount: fields[5] as double,
      pendingUniqueID: fields[6] as String,
    )..no = fields[0] as int?;
  }

  @override
  void write(BinaryWriter writer, PendingTrxDisplay obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.no)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.comments)
      ..writeByte(3)
      ..write(obj.transactionType)
      ..writeByte(4)
      ..write(obj.sendTo)
      ..writeByte(5)
      ..write(obj.amount)
      ..writeByte(6)
      ..write(obj.pendingUniqueID);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PendingTrxDisplayAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FaqAdapter extends TypeAdapter<Faq> {
  @override
  final int typeId = 19;

  @override
  Faq read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Faq(
        code: fields[0] as int?,
        subject: fields[1] as String?,
        keywords: fields[2] as String?,
        message: fields[3] as String?);
  }

  @override
  void write(BinaryWriter writer, Faq obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.code)
      ..writeByte(1)
      ..write(obj.subject)
      ..writeByte(2)
      ..write(obj.keywords)
      ..writeByte(3)
      ..write(obj.message);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FaqAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// class NotificationAdapter extends TypeAdapter<AppNotification> {
//   @override
//   final int typeId = 20;

//   @override
//   AppNotification read(BinaryReader reader) {
//     final numOfFields = reader.readByte();
//     final fields = <int, dynamic>{
//       for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
//     };
//     return AppNotification(
//       title: fields[0] as String?,
//       message: fields[1] as String?,
//       imageUrl: fields[2] as String?,
//     );
//   }

//   @override
//   void write(BinaryWriter writer, AppNotification obj) {
//     writer
//       ..writeByte(3)
//       ..writeByte(0)
//       ..write(obj.title)
//       ..writeByte(1)
//       ..write(obj.message)
//       ..writeByte(2)
//       ..write(obj.imageUrl);
//   }

//   @override
//   int get hashCode => typeId.hashCode;

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is NotificationAdapter &&
//           runtimeType == other.runtimeType &&
//           typeId == other.typeId;
// }
