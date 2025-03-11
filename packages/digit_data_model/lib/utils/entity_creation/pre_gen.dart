import 'package:collection/collection.dart';

import 'models.dart';

class PreGen {
  dynamic run(dynamic vars) {
    try {
      final variables = vars;

      ConfigModelMapper.ensureInitialized();
      AttributeModelMapper.ensureInitialized();
      EnumValuesMapper.ensureInitialized();
      TableReferenceModelMapper.ensureInitialized();

      ConfigModel model = ConfigModelMapper.fromMap(variables);

      model = model.copyWith.attributes.addAll(
        [
          const AttributeModel(
            name: 'auditCreatedBy',
            type: 'String',
            includeForQuery: false,
            includeForEntity: false,
            includeForTable: true,
            isPk: true,
            nullable: true,
          ),
          const AttributeModel(
            name: 'nonRecoverableError',
            type: 'bool',
            includeForQuery: false,
            includeForEntity: true,
            includeForTable: true,
            nullable: true,
            defaultValue: 'false',
          ),
          const AttributeModel(
            name: 'auditCreatedTime',
            type: 'int',
            includeForQuery: false,
            includeForEntity: false,
            includeForTable: true,
            nullable: true,
          ),
          const AttributeModel(
            name: 'clientCreatedTime',
            type: 'int',
            includeForQuery: false,
            includeForEntity: false,
            includeForTable: true,
            nullable: true,
          ),
          const AttributeModel(
            name: 'clientModifiedBy',
            type: 'String',
            includeForQuery: false,
            includeForEntity: false,
            includeForTable: true,
            nullable: true,
          ),
          const AttributeModel(
            name: 'clientCreatedBy',
            type: 'String',
            includeForQuery: false,
            includeForEntity: false,
            includeForTable: true,
            nullable: true,
          ),
          const AttributeModel(
            name: 'clientModifiedTime',
            type: 'int',
            includeForQuery: false,
            includeForEntity: false,
            includeForTable: true,
            nullable: true,
          ),
          const AttributeModel(
            name: 'auditModifiedBy',
            type: 'String',
            includeForQuery: false,
            includeForEntity: false,
            includeForTable: true,
            nullable: true,
          ),
          const AttributeModel(
            name: 'auditModifiedTime',
            type: 'int',
            includeForQuery: false,
            includeForEntity: false,
            includeForTable: true,
            nullable: true,
          ),
          if (model.persistBoundaryParameters) ...[
            const AttributeModel(
              name: 'localityBoundaryCode',
              type: 'String',
              includeForQuery: false,
              includeForEntity: false,
              includeForTable: true,
              nullable: true,
            ),
            const AttributeModel(
              name: 'localityBoundaryName',
              type: 'String',
              includeForQuery: false,
              includeForEntity: false,
              includeForTable: true,
              nullable: true,
            ),
          ],
        ],
      );

      if (model.attributes.firstWhereOrNull(
              (element) => element.name == 'clientReferenceId') ==
          null) {
        model = model.copyWith.attributes.addAll(
          [
            const AttributeModel(
              name: 'clientReferenceId',
              type: 'String',
              isPk: true,
              isList: true,
              includeForQuery: true,
              includeForEntity: false,
              includeForTable: false,
              nullable: false,
            ),
            const AttributeModel(
              name: 'clientReferenceId',
              type: 'String',
              isPk: true,
              includeForQuery: false,
              includeForEntity: true,
              includeForTable: true,
              nullable: false,
            ),
          ],
        );
      }

      if (model.attributes
              .firstWhereOrNull((element) => element.name == 'tenantId') ==
          null) {
        model = model.copyWith.attributes.add(
          const AttributeModel(
            name: 'tenantId',
            type: 'String',
            includeForQuery: true,
            nullable: true,
          ),
        );
      }

      if (model.attributes
              .firstWhereOrNull((element) => element.name == 'isDeleted') ==
          null) {
        model = model.copyWith.attributes.add(
          const AttributeModel(
            name: 'isDeleted',
            type: 'bool',
            defaultValue: "false",
            includeForQuery: false,
            includeForEntity: false,
            nullable: true,
          ),
        );
      }

      if (model.attributes
              .firstWhereOrNull((element) => element.name == 'rowVersion') ==
          null) {
        model = model.copyWith.attributes.add(
          const AttributeModel(
            name: 'rowVersion',
            type: 'int',
            includeForQuery: false,
            nullable: true,
          ),
        );
      }

      model = model.copyWith(
        attributes: model.attributes
            .where((e) => !model.ignoreFields.contains(e.name))
            .toList(),
      );

      final sqlAttributes = <AttributeModel>[
        ...model.attributes
            .where((element) => element.includeForTable)
            .map((e) {
          final type = _getSqlType(e.type);
          final columnType = _getSqlColumnType(e.type);
          return e.copyWith(type: type, columnType: columnType);
        }),
        ...model.dateTimeAttributes.map((e) {
          final type = _getSqlType(e.type);
          final columnType = _getSqlColumnType(e.type);
          return e.copyWith(type: type, columnType: columnType);
        }),
        ...model.customAttributes.where(
          (element) => element.isEnum && element.includeForTable,
        ),
      ];

      final references = [
        ...model.customAttributes
            .where((element) => element.createReference)
            .where((element) => !element.isEnum)
            .map((e) {
          final pkName = e.referencePkName ?? 'clientReferenceId';

          return e.copyWith(references: [
            TableReferenceModel(
              table: e.type,
              column: e.name,
              pkName: pkName,
            ),
          ]);
        }),
      ];

      final updateModel = model.copyWith(
        sqlAttributes: sqlAttributes,
        referenceAttributes: references,
      );
      vars = updateModel.toMap();
      return vars;
    } catch (e) {
      print(e);
    }
  }

  String _getSqlType(String dartType) {
    String type;
    switch (dartType) {
      case 'DateTime':
        type = 'Integer';
        break;
      case 'String':
        type = 'Text';
        break;
      case 'int':
        type = 'Integer';
        break;
      case 'double':
        type = 'Real';
        break;
      case 'bool':
        type = 'Boolean';
        break;
      default:
        type = 'Text';
    }

    return type;
  }

  String _getSqlColumnType(String dartType) {
    String type;
    switch (dartType) {
      case 'DateTime':
        type = 'Int';
        break;
      case 'String':
        type = 'Text';
        break;
      case 'int':
        type = 'Int';
        break;
      case 'double':
        type = 'Real';
        break;
      case 'bool':
        type = 'Bool';
        break;
      default:
        type = 'Text';
    }

    return type;
  }
}
