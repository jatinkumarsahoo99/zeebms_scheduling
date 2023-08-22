import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';

import './csv/pluto_grid_csv_export.dart';
import 'csv/pluto_grid_csv_export1.dart';

/// Export to CSV from PlutoGrid
class PlutoGridExport1 {
  /// [state] The stateManager received from the [onLoaded] callback of [PlutoGrid].
  static String exportCSV(
      PlutoGridStateManager state, {
        String? fieldDelimiter,
        String? textDelimiter,
        String? textEndDelimiter,
        String? eol,
      }) {
    var plutoGridCsvExport = PlutoGridDefaultCsvExport1(
      fieldDelimiter: fieldDelimiter,
      textDelimiter: textDelimiter,
      textEndDelimiter: textEndDelimiter,
      eol: eol,
    );

    return plutoGridCsvExport.export(state);
  }
}
