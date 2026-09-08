import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../../config/PrefHelper/helper.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/assets_manager.dart';

import '../../../../core/utils/size_utils.dart';
import '../../../../widgets/back_button_widget.dart';
import '../../../../widgets/empty_data_widget.dart';
import '../../../../widgets/error_widget.dart';
import '../../../../widgets/filter_item.dart';
import '../../../../widgets/svg_image_widget.dart';
import '../../data/models/statistic_details_model.dart';
import '../cubit/statistic_details_cubit.dart';
import '../widget/app_headline_widget.dart';
import '../widget/claims_list_card_item.dart';

class ClaimsListScreen extends StatefulWidget {
  final String claimStatus;
  final String title;
  final String? uniqueId;
  final String buildingName;
  final String companyName;
  const ClaimsListScreen({
    super.key,
    required this.title,
    required this.claimStatus,
    this.uniqueId,
    required this.buildingName,
    required this.companyName,
  });

  @override
  State<ClaimsListScreen> createState() => _ClaimsListScreenState();
}

class _ClaimsListScreenState extends State<ClaimsListScreen> {
  final TextEditingController _searchController = TextEditingController();

  bool _isFirstLoad = true;
  bool _hasError = false;
  String _errorMsg = '';
  bool _isLoading = false;
  ClaimsData? _currentModel;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _fetchData() {
    setState(() {
      _isFirstLoad = true;
      _hasError = false;
    });

    BlocProvider.of<StatisticDetailsCubit>(context)
        .getData(widget.uniqueId!, widget.claimStatus, 9999);
  }

  void _onStateChanged(StatisticDetailsState state) {
    if (state is StatisticsDetailsIsLoading) {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });
    } else if (state is StatisticsDetailsError) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMsg = state.msg;
        _isFirstLoad = false;
      });
    } else if (state is StatisticsDetailsLoaded) {
      final claimsModel = state.data.claims;

      setState(() {
        _isLoading = false;
        _currentModel = claimsModel;
        _isFirstLoad = false;
        _hasError = false;
      });
    }
  }

  Widget _buildBody() {
    if (_isFirstLoad) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_hasError && (_currentModel == null || _currentModel!.data.isEmpty)) {
      return ErrorWidgetItem(
        onTap: _fetchData,
        isUnauthenticated: _errorMsg.contains('Unauthenticated.'),
      );
    }
    final claims = _currentModel?.data ?? [];
    if (claims.isEmpty) {
      return EmptyDataWidget();
    }
    return ListView.builder(
      padding: EdgeInsets.all(8.0.r),
      itemCount: claims.length,
      itemBuilder: (ctx, pos) {
        final claim = claims[pos];
        return ClaimsListCardItem(
          referenceId: claim.referenceId,
          status: claim.status.tr,
          priority: claim.priority,
          description: claim.description,
          availableTime: claim.availableTime,
          createdAt: claim.createdAt,
          buildingName: widget.buildingName,
          unitName: claim.unitName,
          onAssignTap: () {
            // TODO: wire up assign action for claim.referenceId
          },
        );
      },
    );
  }

  void search(String item) {
    setState(() {
      _currentModel!.data = _currentModel!.data
          .where((element) => element.referenceId.contains(item))
          .toList();
    });
  }

  Future<void> generatePdf() async {
    final pdf = pw.Document();
    final arabicFont = pw.Font.ttf(await rootBundle.load('assets/fonts/NotoNaskhArabic-Medium.ttf'));
    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) => <pw.Widget>[
          pw.Wrap(
            children: List<pw.Widget>.generate(_currentModel!.data.length, (int pos) {
              return _buildClaimCardPdf(arabicFont, _currentModel!.data[pos].referenceId.toString(),
                  _currentModel!.data[pos].status,
                  _currentModel!.data[pos].priority,
                  _currentModel!.data[pos].description,
                  Helper.formatDateTime(_currentModel!.data[pos].createdAt), Helper.getAvailableTime(_currentModel!.data[pos].availableTime));
            }),
          ),
        ],
      ),
    );

    // Print the PDF
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StatisticDetailsCubit, StatisticDetailsState>(
      listener: (context, state) => _onStateChanged(state),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: ResponsiveExtension(12).w),
                  child: Row(
                    children: [
                      const BackButtonWidget(),
                      Container(
                        margin: EdgeInsets.only(top: ResponsiveExtension(4).w),
                        child: AppHeadline(
                          title: widget.title,
                          padding: EdgeInsets.symmetric(horizontal: ResponsiveExtension(10).w),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ResponsiveExtension(12).h),
                appHeader(),
                SizedBox(height: ResponsiveExtension(10).h),
                Expanded(child: _buildBody()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget appHeader(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: ResponsiveExtension(12).w),
      child: Card(
        elevation: 1,
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          padding: EdgeInsets.all(10.adaptSize),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                      height: ResponsiveExtension(40).h,
                      width: ResponsiveExtension(240).w,
                      child: TextField(
                        onChanged: ((value){
                          if(value.isEmpty || value == ''){
                            BlocProvider.of<StatisticDetailsCubit>(context)
                                .getData(widget.uniqueId!, widget.claimStatus, 9999);
                          } else {
                            search(value);
                          }
                        }),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search , color: Colors.black38,),
                          hintText: 'search'.tr,
                          contentPadding: EdgeInsets.only(top: ResponsiveExtension(12).h),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                      )
                  ),
                  SizedBox(width: ResponsiveExtension(10).w,),
                  InkWell(
                    onTap: _showFilterBottomSheet,
                    child: Card(
                      color: AppColors.whiteColor,
                      elevation: 2,
                      child: Padding(
                        padding: EdgeInsets.all(5.adaptSize),
                        child: Center(
                          child: SVGImageWidget(image: AssetsManager.filter, width: ResponsiveExtension(18).w, height: ResponsiveExtension(18).h),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: ResponsiveExtension(3).w,),
                  InkWell(
                    onTap: generatePdf,
                    child: Card(
                      elevation: 2,
                      child: SVGImageWidget(image: AssetsManager.sort, width: ResponsiveExtension(18).w, height: ResponsiveExtension(18)  .h),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterBottomSheet() async {
    final filterData = await showModalBottomSheet<Map<String, dynamic>>(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.97,
          child: FilterBottomSheetContent(
            menuName: 'filterBy'.tr,
            data: const {},
            uniqueId: widget.uniqueId!,
          ),
        );
      },
    );

    if (filterData != null) {
      BlocProvider.of<StatisticDetailsCubit>(context).getData(
        widget.uniqueId!,
        '',
        9999,
        data: filterData,
      );
    }
  }

  pw.Widget _buildClaimCardPdf(
      pw.Font arabicFont,
      String id,
      String status,
      String priority,
      String type,
      String date,
      String availableTime,
      ) {
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(horizontal: ResponsiveExtension(7).w, vertical: ResponsiveExtension(3).h),
      child: pw.Container(
        decoration: pw.BoxDecoration(
          color: PdfColors.white,
          borderRadius: pw.BorderRadius.circular(12.0),
          boxShadow: const [
            pw.BoxShadow(
              color: PdfColors.grey300,
              blurRadius: 2.0,
            ),
          ],
        ),
        child: pw.Padding(
          padding: pw.EdgeInsets.all(16.0.fSize),
          child: pw.Container(
            margin: pw.EdgeInsets.symmetric(horizontal: ResponsiveExtension(5).w),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          id,
                          style: pw.TextStyle(
                            fontSize: 16.fSize,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    pw.Directionality(
                      textDirection: pw.TextDirection.rtl,
                      child: pw.Text(
                        status,
                        style: pw.TextStyle(
                          font: arabicFont,
                          fontSize: 12.fSize,
                          fontWeight: pw.FontWeight.normal,
                          color: PdfColors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: ResponsiveExtension(5).h),
                pw.Divider(thickness: 1, color: PdfColors.grey),
                pw.SizedBox(height: ResponsiveExtension(8).h),
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Priority:',
                      style: pw.TextStyle(
                        fontSize: 12.fSize,
                        color: PdfColors.black,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(width: ResponsiveExtension(10).w),
                    pw.Expanded(
                      child: pw.Directionality(
                        textDirection: pw.TextDirection.rtl,
                        child: pw.Text(
                          priority,
                          maxLines: 3,
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            font: arabicFont,
                            fontSize: 12.fSize,
                            color: PdfColors.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: ResponsiveExtension(8).h),
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Type:',
                      style: pw.TextStyle(
                        font: arabicFont,
                        fontSize: 12.fSize,
                        color: PdfColors.black,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(width: ResponsiveExtension(10).w),
                    pw.Expanded(
                      child: pw.Directionality(
                        textDirection: pw.TextDirection.rtl,
                        child: pw.Text(
                          type,
                          maxLines: 3,
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            font: arabicFont,
                            fontSize: 12.fSize,
                            color: PdfColors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: ResponsiveExtension(8).h),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Created Date:',
                      style: pw.TextStyle(
                        fontSize: 12.fSize,
                        color: PdfColors.black,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      date,
                      style: pw.TextStyle(
                        fontSize: 12.fSize,
                        color: PdfColors.grey,
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: ResponsiveExtension(8).h),
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Available Time:',
                      style: pw.TextStyle(
                        fontSize: 12.fSize,
                        color: PdfColors.black,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(width: ResponsiveExtension(10).w),
                    pw.Expanded(
                      child: pw.Directionality(
                        textDirection: pw.TextDirection.rtl,
                        child: pw.Text(
                          availableTime,
                          maxLines: 2,
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(
                            font: arabicFont,
                            fontSize: 12.fSize,
                            fontWeight: pw.FontWeight.normal,
                            color: PdfColors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 8.fSize),
              ],
            ),
          ),
        ),
      ),
    );
  }
}