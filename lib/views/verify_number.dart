import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myladmobile/extensions/spacing.dart';
import 'package:myladmobile/model/school.dart';
import 'package:myladmobile/utils/colors.dart';
import 'package:myladmobile/utils/constants.dart';
import 'package:myladmobile/views/home_page.dart';
import 'package:myladmobile/widget/school_card.dart';
import 'package:myladmobile/widget/submit_button.dart';

class VerifyNumber extends StatefulWidget {
  final School school;
  const VerifyNumber({super.key, required this.school});

  @override
  State<VerifyNumber> createState() => _VerifyNumberState();
}

class _VerifyNumberState extends State<VerifyNumber> {
  TextEditingController phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().whiteColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SchoolCard(
              schoolName: widget.school.schoolName,
              schoolMoto: widget.school.schoolMoto,
              schoolLogo: "schoolLogo",
              borderColor: AppColors().whiteColor,
            ),
            10.0.vSpace,
            Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    TextFormField(
                      controller: phoneController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your number';
                        }
                      },
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: AppColors().strokeColor,
                        )),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: AppColors().greyColor,
                        )),
                        hintStyle: TextStyle(
                            fontFamily: fontFamily,
                            color: AppColors().strokeColor),
                        hintText: "Search for school",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                      ),
                    )
                  ],
                )),
            50.0.vSpace,
            InkWell(
                onTap: () {
                  bool isValidate = _formKey.currentState!.validate();
                  if (isValidate) {
                    Navigator.of(context).push(
                        CupertinoPageRoute(builder: (context) => HomePage()));
                  }
                },
                child: SubmitButton(label: "Verify"))
          ],
        ),
      ),
    );
  }
}
