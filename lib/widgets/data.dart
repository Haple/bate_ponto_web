import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class Data extends StatefulWidget {
  final TextEditingController controller;
  final String label;

  const Data({
    Key key,
    @required this.controller,
    this.label,
  })  : assert(controller != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _DataState();
}

class _DataState extends State<Data> {
  @override
  Widget build(BuildContext context) {
    final format = DateFormat("mm/yyyy");
    return Column(
      children: <Widget>[
        DateTimeField(
          format: format,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: widget.label,
          ),
          controller: widget.controller,
          onShowPicker: (context, currentValue) async {
            final time = await showTimePicker(
              context: context,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(alwaysUse24HourFormat: true),
                child: child,
              ),
              initialTime:
                  TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
            );
            return DateTimeField.convert(time);
          },
        ),
      ],
    );
  }
}
