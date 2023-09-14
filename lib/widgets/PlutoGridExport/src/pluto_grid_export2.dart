import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';

import './csv/pluto_grid_csv_export.dart';
import 'csv/pluto_grid_csv_export2.dart';

/// Export to CSV from PlutoGrid
class PlutoGridExport2 {
  /// [state] The stateManager received from the [onLoaded] callback of [PlutoGrid].
  static String exportCSV(
      PlutoGridStateManager state, {
        String? fieldDelimiter,
        String? textDelimiter,
        String? textEndDelimiter,
        String? eol,
        List<String>? removeKeysFromFile,
      }) {
    var plutoGridCsvExport = PlutoGridDefaultCsvExport2(
      fieldDelimiter: fieldDelimiter,
      textDelimiter: textDelimiter,
      textEndDelimiter: textEndDelimiter,
      eol: eol,
      removeKeysFromFile: removeKeysFromFile
    );

    return plutoGridCsvExport.export(state);
  }
}
