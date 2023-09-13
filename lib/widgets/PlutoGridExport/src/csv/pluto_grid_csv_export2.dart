import 'package:csv/csv.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';

import '../abstract_text_export.dart';

/// Csv exporter for PlutoGrid
class PlutoGridDefaultCsvExport2 extends AbstractTextExport<String> {
  const PlutoGridDefaultCsvExport2({
    this.fieldDelimiter,
    this.textDelimiter,
    this.textEndDelimiter,
    this.eol,
    this.removeKeysFromFile
  }) : super();

  final String? fieldDelimiter;
  final String? textDelimiter;
  final String? textEndDelimiter;
  final String? eol;
  final List<String>? removeKeysFromFile;

  /// [state] PlutoGrid's PlutoGridStateManager.
  @override
  String export(PlutoGridStateManager state) {
    String toCsv = const ListToCsvConverter().convert(
      [
        getColumnTitles2(state,removeKeysFromFile: removeKeysFromFile),
        ...mapStateToListOfRows2(state,removeKeysFromFile: removeKeysFromFile),
      ],
      fieldDelimiter: fieldDelimiter,
      textDelimiter: textDelimiter,
      textEndDelimiter: textEndDelimiter,
      delimitAllFields: true,
      eol: eol,
    );

    return toCsv;
  }
}
