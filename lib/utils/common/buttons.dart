import 'package:de/utils/app_colors.dart';
import 'package:flutter/material.dart';

class Workstatus extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final double buttonWidth, buttonHeight;
  const Workstatus({
    super.key,
    required this.child,
    required this.onPressed,
    this.buttonWidth = 150,
    this.buttonHeight = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: buttonWidth,
      height: buttonHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.appTheme,
      ),
      child: TextButton(onPressed: onPressed, child: child),
    );
  }
}

class PdfButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final double buttonWidth, buttonHeight;
  const PdfButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.buttonWidth = 150,
    this.buttonHeight = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: buttonWidth,
      height: buttonHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.startsettingbuttonColor,
      ),
      child: TextButton(onPressed: onPressed, child: child),
    );
  }
}

class ModelButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final double buttonWidth, buttonHeight;
  const ModelButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.buttonWidth = 150,
    this.buttonHeight = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: buttonWidth,
      height: buttonHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.startproductionbuttonColor,
      ),
      child: TextButton(onPressed: onPressed, child: child),
    );
  }
}

class ProgrameuploadButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final double buttonWidth, buttonHeight;
  const ProgrameuploadButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.buttonWidth = 150,
    this.buttonHeight = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: buttonWidth,
      height: buttonHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.programuploadcolor,
      ),
      child: TextButton(onPressed: onPressed, child: child),
    );
  }
}

class ProgrameDownloadeButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final double buttonWidth, buttonHeight;
  const ProgrameDownloadeButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.buttonWidth = 150,
    this.buttonHeight = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: buttonWidth,
      height: buttonHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.programdownloadcolor,
      ),
      child: TextButton(onPressed: onPressed, child: child),
    );
  }
}

class ShiftOneButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final double buttonWidth, buttonHeight;
  const ShiftOneButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.buttonWidth = 100,
    this.buttonHeight = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: buttonWidth,
      height: buttonHeight,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(5), bottomLeft: Radius.circular(5)),
        color: Theme.of(context).primaryColor,
      ),
      child: TextButton(onPressed: onPressed, child: child),
    );
  }
}

class ShiftTwoButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final double buttonWidth, buttonHeight;
  const ShiftTwoButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.buttonWidth = 100,
    this.buttonHeight = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: buttonWidth,
      height: buttonHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).primaryColor,
      ),
      child: TextButton(onPressed: onPressed, child: child),
    );
  }
}

class ShiftThreeButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final double buttonWidth, buttonHeight;
  const ShiftThreeButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.buttonWidth = 100,
    this.buttonHeight = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: buttonWidth,
      height: buttonHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).primaryColor,
      ),
      child: TextButton(onPressed: onPressed, child: child),
    );
  }
}
