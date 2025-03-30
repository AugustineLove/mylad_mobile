import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myladmobile/provider/schoolsProvider.dart';
import 'package:provider/provider.dart';
import 'package:myladmobile/utils/colors.dart';
import 'package:myladmobile/utils/constants.dart';
import 'package:myladmobile/utils/text.dart';
import 'package:myladmobile/views/verify_number.dart';
import 'package:myladmobile/widget/school_card.dart';
import 'package:myladmobile/model/school.dart';

class SearchForSchool extends StatefulWidget {
  const SearchForSchool({super.key});

  @override
  _SearchForSchoolState createState() => _SearchForSchoolState();
}

class _SearchForSchoolState extends State<SearchForSchool> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SchoolProvider()..fetchSchools(),
      child: Scaffold(
        backgroundColor: AppColors().whiteColor,
        appBar: AppBar(
          backgroundColor: AppColors().whiteColor,
          elevation: 0,
          title: MyTexts().regularText("Search School"),
        ),
        body: Consumer<SchoolProvider>(
          builder: (context, schoolProvider, child) {
            if (schoolProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (schoolProvider.errorMessage != null) {
              return Center(child: Text(schoolProvider.errorMessage!));
            }

            List<School> filteredSchools = schoolProvider.schools
                .where((school) => school.schoolName
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase()))
                .toList();

            filteredSchools
                .sort((a, b) => a.schoolName.compareTo(b.schoolName));

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "Search for a school",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () => setState(() {}),
                      ),
                    ),
                    onChanged: (text) => setState(() {}),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredSchools.length,
                      itemBuilder: (context, index) {
                        final school = filteredSchools[index];

                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (context) => VerifyNumber(),
                              ),
                            );
                          },
                          child: SchoolCard(
                            schoolName: school.schoolName,
                            schoolMoto: school.schoolAddress,
                            schoolLogo: "schoolLogo",
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
