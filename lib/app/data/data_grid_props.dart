class DataGridProps {
  final bool? enableSort;
  final bool? formatDate;
  final bool? showNo;
  final bool? showDrag;
  final String? dateFormat;

  DataGridProps(
      {this.enableSort = false,
      this.formatDate = true,
      this.showNo = true,
      this.showDrag = true,
      this.dateFormat = "dd-MM-yyyy"});
}
