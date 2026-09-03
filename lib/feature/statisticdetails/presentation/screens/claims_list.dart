import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/assets_manager.dart';
import '../../../../widgets/back_button_widget.dart';
import '../../../../widgets/empty_data_widget.dart';
import '../../../../widgets/error_widget.dart';
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
  final ScrollController _scrollController = ScrollController();

  static const int _pageSize = 10; // how many more to load each time
  int _perPage = _pageSize;

  int _totalCount = 0; // from statistics.all / pagination.total, so we know when to stop
  bool _isLoadingMore = false;
  bool _isFirstLoad = true;
  bool _hasError = false;
  String _errorMsg = '';

  @override
  void initState() {
    super.initState();
    _fetchData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isLoadingMore || _isFirstLoad) return;

    final model = _currentModel;
    if (model != null && model.data.length >= _totalCount) return; // already have everything

    final threshold = _scrollController.position.maxScrollExtent - 200;
    if (_scrollController.position.pixels >= threshold) {
      _loadMore();
    }
  }

  ClaimsData? _currentModel;

  void _fetchData() {
    setState(() {
      _isFirstLoad = true;
      _hasError = false;
      _perPage = _pageSize;
    });
    BlocProvider.of<StatisticDetailsCubit>(context)
        .getData(widget.uniqueId!, widget.claimStatus,_perPage);
  }

  void _loadMore() {
    setState(() {
      _isLoadingMore = true;
      _perPage += _pageSize;
    });
    BlocProvider.of<StatisticDetailsCubit>(context)
        .getData(widget.uniqueId!, widget.claimStatus, _perPage);
  }

  void _onStateChanged(StatisticDetailsState state) {
    if (state is StatisticsDetailsIsLoading) {
      return;
    } else if (state is StatisticsDetailsError) {
      setState(() {
        _hasError = true;
        _errorMsg = state.msg;
        _isFirstLoad = false;
        _isLoadingMore = false;
      });
    } else if (state is StatisticsDetailsLoaded) {
      final claimsModel = state.data.claims;
      setState(() {
        _currentModel = claimsModel;
        _totalCount = claimsModel.meta.pagination.total; // adjust field name to your model
        _isFirstLoad = false;
        _isLoadingMore = false;
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
      controller: _scrollController,
      padding: const EdgeInsets.all(8.0),
      itemCount: claims.length + (_isLoadingMore ? 1 : 0),
      itemBuilder: (ctx, pos) {
        if (pos >= claims.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final claim = claims[pos];
        return ClaimsListCardItem(
          referenceId: claim.referenceId,
          status: claim.status,
          priority: claim.priority,
          description: claim.description,
          availableTime: claim.availableTime,
          createdAt: claim.createdAt,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StatisticDetailsCubit, StatisticDetailsState>(
      listener: (context, state) => _onStateChanged(state),
      child: Scaffold(
        // appBar: AppBar(
        //   title: widget.buildingName == ''
        //       ? Text(widget.companyName)
        //       : Text(widget.buildingName),
        //   leading: InkWell(
        //     child: Image.asset(
        //       AssetsManager.back,
        //       width: ScreenUtil().setWidth(14),
        //       height: ScreenUtil().setHeight(8),
        //     ),
        //     onTap: () {
        //       Navigator.of(context).pop();
        //     },
        //   ),
        // ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Row(
                    children: [
                      const BackButtonWidget(),
                      Container(
                        margin: EdgeInsets.only(top: 4.w),
                        child: AppHeadline(
                          title: widget.title,
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Expanded(child: _buildBody()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}