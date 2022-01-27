import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget? child;

  const CategoryTile({Key? key, this.onTap, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        margin: const EdgeInsets.all(8),
        child: Center(child: child ?? const SizedBox()),
        decoration: const BoxDecoration(
          color: Color(0xffFFFFFF),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFDBDBDB),
              spreadRadius: 0,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}
