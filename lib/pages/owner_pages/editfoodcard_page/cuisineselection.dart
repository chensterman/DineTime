import 'package:flutter/material.dart';
import 'package:dinetime_mobile_mvp/theme/designsystem.dart';

class CuisineSelection extends StatefulWidget {
  final String cuisineName;
  final String imageAsset;

  const CuisineSelection({
    Key? key,
    required this.cuisineName,
    required this.imageAsset,
  }) : super(key: key);

  @override
  _CuisineSelectionState createState() => _CuisineSelectionState();
}

class _CuisineSelectionState extends State<CuisineSelection> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 3,
              offset: Offset(0, 3),
            ),
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 3,
              offset: Offset(0, -3),
            ),
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 3,
              offset: Offset(3, 0),
            ),
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 3,
              offset: Offset(-3, 0),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(width: 12.0),
            Padding(
              padding: const EdgeInsets.only(
                left: 15.0,
                right: 12.0,
              ),
              child: Container(
                height: 25,
                width: 25,
                child: Image(
                  image: AssetImage(widget.imageAsset),
                ),
              ),
            ),
            SizedBox(width: 20.0),
            Text(
              widget.cuisineName,
              style: dineTimeTypography.bodyMedium?.copyWith(
                fontSize: 16.0,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(width: 8.0),
            Spacer(),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isSelected = !_isSelected;
                });
              },
              child: Container(
                height: 25,
                width: 25,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _isSelected
                        ? dineTimeColorScheme.primary
                        : Colors.grey.withOpacity(0.5),
                    width: 2.0,
                  ),
                  color: _isSelected
                      ? dineTimeColorScheme.primary
                      : Colors.transparent,
                ),
                child: _isSelected
                    ? Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 15,
                      )
                    : null,
              ),
            ),
            SizedBox(width: 12.0),
          ],
        ),
      ),
    );
  }
}
