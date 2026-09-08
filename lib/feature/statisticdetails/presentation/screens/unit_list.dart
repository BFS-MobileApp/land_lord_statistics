import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../widgets/back_button_widget.dart';
import '../../../../widgets/empty_data_widget.dart';
import '../../../../widgets/error_widget.dart';
import '../../data/models/units_model.dart';
import '../cubit/statistic_details_cubit.dart';
import '../widget/app_headline_widget.dart';
import '../widget/units_export_button.dart';
import '../widget/units_table_widget.dart';

class UnitsListScreen extends StatefulWidget {
  final String uniqueId;
  final String title;

  const UnitsListScreen({
    super.key,
    required this.uniqueId,
    required this.title,
  });

  @override
  State<UnitsListScreen> createState() => _UnitsListScreenState();
}

class _UnitsListScreenState extends State<UnitsListScreen> {
  List<PropertyUnit> _units = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMsg = '';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    BlocProvider.of<StatisticDetailsCubit>(context).getUnitsData(widget.uniqueId);
  }

  void _onStateChanged(StatisticDetailsState state) {
    if (state is UnitsDetailsIsLoading) {
      return;
    } else if (state is UnitsDetailsError) {
      setState(() {
        _hasError = true;
        _errorMsg = state.msg;
        _isLoading = false;
      });
    } else if (state is UnitsDetailsLoaded) {
      setState(() {
        _units = state.units.data;
        _isLoading = false;
        _hasError = false;
      });
    }
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_hasError && _units.isEmpty) {
      return ErrorWidgetItem(
        onTap: _fetchData,
        isUnauthenticated: _errorMsg.contains('Unauthenticated.'),
      );
    }
    if (_units.isEmpty) {
      return const EmptyDataWidget();
    }
    return UnitsTableWidget(units: _units);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StatisticDetailsCubit, StatisticDetailsState>(
      listener: (context, state) => _onStateChanged(state),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 8),
              Expanded(child: _buildBody()),
              if (!_isLoading && !_hasError && _units.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: UnitsDownloadButtons(units: _units),
                ),
            ],
          ),
        ),
      ),
    );
  }
}