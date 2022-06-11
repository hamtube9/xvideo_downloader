import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:videodownloader/bloc/main_bloc.dart';
import 'package:videodownloader/bloc/main_provider.dart';
import 'package:videodownloader/model/category/category.dart';
import 'package:videodownloader/services/download_service.dart';
import 'package:videodownloader/views/button_animation_color.dart';
import 'package:videodownloader/views/download_view.dart';

class LanguageView extends StatefulWidget {
  const LanguageView({Key? key}) : super(key: key);

  @override
  State<LanguageView> createState() => _LanguageViewState();
}

class _LanguageViewState extends State<LanguageView> {
  @override
  Widget build(BuildContext context) {
    final categories = categoriesLanguage;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Select your Language'),
         Center(child:  Padding(
           padding: const EdgeInsets.all(24),
           child: Wrap(spacing: 16, direction: Axis.horizontal, alignment: WrapAlignment.center, children: [
             if (categories.isNotEmpty)
               for (int i = 0; i < categories.length; i++)
                 ChangeRaisedButtonColor(
                   text: categories[i].name!,
                   onClick: (v) {
                     selectAnswer(categories[i]);
                   },
                   isSelected: categories[i].isSelected,
                 )
           ]),
         ),),
          buttonContinue()
        ],
      ),
    );
  }

  buttonContinue() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => MainProvider(child: const DownloadView(),bloc: MainBloc(service: GetIt.instance.get<DownloadService>())),
        ));
      },
      child: Center(
        child: Container(
          width: 160,
          margin: const EdgeInsets.all(16),
          height: 60,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.black),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Continue',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 4,
              ),
              Icon(
                Icons.arrow_forward_outlined,
                color: Colors.white,
                size: 28,
              )
            ],
          ),
        ),
      ),
    );
  }

  void selectAnswer(Category cat) {
    setState(() {
      cat.isSelected = !cat.isSelected;
    });
  }
}
