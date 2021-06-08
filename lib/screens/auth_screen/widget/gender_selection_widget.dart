import 'package:flutter/material.dart';

class GenderSelectionWidget extends StatefulWidget {
  final Function(String) onGenderSelected;

  const GenderSelectionWidget({Key? key, required this.onGenderSelected})
      : super(key: key);

  @override
  _GenderSelectionWidgetState createState() => _GenderSelectionWidgetState();
}

class _GenderSelectionWidgetState extends State<GenderSelectionWidget> {
  int selectedGender = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Card(
            elevation: selectedGender == 0 ? 8.0 : 0.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            color: selectedGender == 0
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).cardTheme.color,
            child: InkWell(
              onTap: () {
                setState(() {
                  selectedGender = 0;
                  widget.onGenderSelected("Male");
                });
              },
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                width: 100,
                height: 100,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.male_outlined,
                      size: 32.0,
                    ),
                    Text(
                      "Male",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: 32.0,
          ),
          Card(
            elevation: selectedGender == 1 ? 8.0 : 0.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            color: selectedGender == 1
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).cardTheme.color,
            child: InkWell(
              onTap: () {
                setState(() {
                  selectedGender = 1;
                  widget.onGenderSelected("Female");
                });
              },
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                width: 100,
                height: 100,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.female_outlined,
                      size: 32.0,
                    ),
                    Text(
                      "Female",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
