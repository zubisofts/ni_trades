import 'package:flutter/material.dart';

import 'package:ni_trades/model/investment.dart';
import 'package:ni_trades/util/my_utils.dart';

class ReturnsDescriptionWidget extends StatefulWidget {
  final Investment investment;

  const ReturnsDescriptionWidget({
    Key? key,
    required this.investment,
  }) : super(key: key);

  @override
  _ReturnsDescriptionWidgetState createState() =>
      _ReturnsDescriptionWidgetState();
}

class _ReturnsDescriptionWidgetState extends State<ReturnsDescriptionWidget> {
  var date = '';

  @override
  void initState() {
    var nextCreditDate = widget.investment.currentInterval + 2.628e+9;
    date = AppUtils.getDateFromTimestamp(nextCreditDate.round());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return !widget.investment.isDue
        ? Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Theme.of(context).cardTheme.color,
            ),
            child: Text(
              'Your next monthly credit will be on $date',
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
          )
        : SizedBox.shrink();
  }
}
