import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myladmobile/extensions/spacing.dart';
import 'package:myladmobile/model/school.dart';
import 'package:myladmobile/utils/colors.dart';
import 'package:myladmobile/utils/constants.dart';
import 'package:myladmobile/utils/text.dart';
import 'package:myladmobile/views/verify_number.dart';
import 'package:myladmobile/widget/school_card.dart';

class SearchForSchool extends StatelessWidget {
  const SearchForSchool({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors().whiteColor,
        appBar: AppBar(
          backgroundColor: AppColors().whiteColor,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: <Widget>[
                50.0.vSpace,
                MyTexts().regularText(
                  'Hi there!',
                ),
                90.0.vSpace,
                const AutocompleteBasicUserExample(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class User {
  const User({required this.email, required this.name});

  final String email;
  final String name;

  @override
  String toString() {
    return '$name, $email';
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is User && other.name == name && other.email == email;
  }

  @override
  int get hashCode => Object.hash(email, name);
}

class AutocompleteBasicUserExample extends StatelessWidget {
  const AutocompleteBasicUserExample({super.key});

  static List<School> schoolList = <School>[
    School(
        schoolName: "GREENWOOD ACADEMY",
        schoolMoto: "Find your remarkable",
        schoolLogo: "schoolLogo"),
    School(
        schoolName: "WESTERN HAPPY HOME ACADEMY",
        schoolMoto: "Find your remarkable",
        schoolLogo: "schoolLogo"),
    School(
        schoolName: "WESTSIDE ACADEMY",
        schoolMoto: "Find your remarkable",
        schoolLogo: "schoolLogo"),
    School(
        schoolName: "HOPES AND DREAMS",
        schoolMoto: "Find your remarkable",
        schoolLogo: "schoolLogo"),
    School(
        schoolName: "SMILING MORN",
        schoolMoto: "Find your remarkable",
        schoolLogo: "schoolLogo"),
    School(
        schoolName: "BLESSED HILL ACADEMY",
        schoolMoto: "Find your remarkable",
        schoolLogo: "schoolLogo"),
    School(
        schoolName: "JESUS NEVER FAILS",
        schoolMoto: "Find your remarkable",
        schoolLogo: "schoolLogo"),
    School(
        schoolName: "METHODIST",
        schoolMoto: "Find your remarkable",
        schoolLogo: "schoolLogo"),
  ];

  @override
  Widget build(BuildContext context) {
    return RawAutocomplete<School>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<School>.empty();
        }
        return schoolList.where((School option) {
          return option.schoolName
                  .toLowerCase()
                  .contains(textEditingValue.text.toLowerCase()) ||
              option.schoolMoto
                  .toLowerCase()
                  .contains(textEditingValue.text.toLowerCase());
        });
      },
      displayStringForOption: (School option) => option.schoolName,
      fieldViewBuilder: (BuildContext context,
          TextEditingController textEditingController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted) {
        return TextField(
          controller: textEditingController,
          focusNode: focusNode,
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
              color: AppColors().strokeColor,
            ),
            hintText: "Search for school",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
          ),
        );
      },
      optionsViewBuilder: (BuildContext context,
          AutocompleteOnSelected<School> onSelected, Iterable<School> options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            color: AppColors().whiteColor,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              constraints: const BoxConstraints(maxHeight: 500),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final School school = options.elementAt(index);
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(CupertinoPageRoute(
                          builder: (context) => VerifyNumber(
                                school: school,
                              )));
                    },
                    child: SchoolCard(
                        schoolName: school.schoolName,
                        schoolMoto: school.schoolMoto,
                        schoolLogo: "schoolLogo"),
                  );
                },
              ),
            ),
          ),
        );
      },
      onSelected: (School selection) {
        debugPrint('You just selected ${selection.schoolName}');
      },
    );
  }
}
