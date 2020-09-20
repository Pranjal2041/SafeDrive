import 'package:beauty_textfield/beauty_textfield.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:model_renderer/data/CarParts.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'dart:math' as math;
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:whatthehack/insurance/data/network.dart';
import 'package:whatthehack/insurance/values/colors.dart';
import 'package:whatthehack/insurance/widgets/header.dart';
import 'package:whatthehack/user/screens/reportCrash/report_result.dart';
import 'package:whatthehack/user/widgets/CustomTextDec.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';

class ReportCrashScreen extends StatefulWidget {
  @override
  _ReportCrashScreenState createState() => _ReportCrashScreenState();
}

class _ReportCrashScreenState extends State<ReportCrashScreen> {
  String description;
  TextEditingController controller;
  ProgressButton progressButton;
  String buttonCode;

  startRecordingForDescription() async {
    //TODO: Complete This
    void resultListener(SpeechRecognitionResult result) {
      setState(() {
        description = "${result.recognizedWords} - ${result.finalResult}";
        controller.text = result.recognizedWords;
      });
      print('hello $description');
    }

    void errorListener(SpeechRecognitionError error) {
      print(error.toString());
      setState(() {
        // lastError = "${error.errorMsg} - ${error.permanent}";
      });
    }

    void statusListener(String status) {
      print(status);
      // setState(() {
      //   // lastStatus = "$status";
      // });
    }

    stt.SpeechToText speech = stt.SpeechToText();
    bool available = await speech.initialize(onStatus: statusListener, onError: errorListener);
    if (available) {
      speech.listen(onResult: resultListener);
    } else {
      print("The user has denied the use of speech recognition.");
    }
    // some time later...
    speech.stop();
  }

  upload() async {
    if (_fbKey.currentState.saveAndValidate()) {
      print(_fbKey.currentState.value);
    }
    if (_fbKey2.currentState.saveAndValidate()) {
      print(_fbKey2.currentState.value);
    }
    if (_fbKey3.currentState.saveAndValidate()) {
      print(_fbKey3.currentState.value);
    }

    setState(() {
      buttonCode = "progress";
    });

    List<dynamic> lis = _fbKey2.currentState.value['parts_damaged'];
    List<String> dLis = new List<String>();
    lis.forEach((element) {
      dLis.add(element.toString());
    });

    await postDamagedParts(dLis);

    Position position = await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ReportCrashResult(
            lat: position.latitude,
            long: position.longitude,
            sendMsg: _fbKey2.currentState.value['emergency_family'] as bool, //Change later
          ),
        ));

    return true;
  }

  @override
  void initState() {
    // TODO: implement initState
    buttonCode = "normal";
    controller = TextEditingController();
    super.initState();
  }

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> _fbKey2 = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> _fbKey3 = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    progressButton = ProgressButton(
      // normalWidget: const Text('I am a button'),
      type: ProgressButtonType.Raised,
      color: colorPalette[11],
      defaultWidget: Text(
        "Report Crash and File claim".toUpperCase(),
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.8,
          fontSize: 16,
        ),
      ),
      progressWidget: const CircularProgressIndicator(),
      width: double.infinity,
      height: 60,
      onPressed: () async {
        var res = await upload();
        // After [onPressed], it will trigger animation running backwards, from end to beginning
        return () {};
      },
    );

    buildPersonalDetails() {
      return Column(children: <Widget>[
        FormBuilder(
            key: _fbKey,
            initialValue: {
              'date': DateTime.now(),
              'accept_terms': false,
            },
            autovalidate: true,
            child: Column(children: <Widget>[
              FormBuilderTextField(
                readOnly: true,
                attribute: "name",
                initialValue: "Richard Thompson",
                decoration: InputDecoration(labelText: "Driver Name"),
              ),
              FormBuilderPhoneField(
                attribute: "phone",
                readOnly: true,
                initialValue: "6669993331",
                enabled: false,
              ),
              FormBuilderTextField(
                readOnly: true,
                attribute: "car_model",
                initialValue: "Audi R8 spyder",
                decoration: InputDecoration(labelText: "Car Model"),
              ),
              FormBuilderDropdown(
                attribute: "gender",
                readOnly: true,
                initialValue: 'Male',
                decoration: InputDecoration(labelText: "Gender"),
                // initialValue: 'Male',
                hint: Text('Select Gender'),
                validators: [FormBuilderValidators.required()],
                items: ['Male', 'Female', 'Other'].map((gender) => DropdownMenuItem(value: gender, child: Text("$gender"))).toList(),
              ),
            ]))
      ]);
    }

    getCarPartsField() {
      var a = new List<FormBuilderFieldOption>();
      for (CarParts part in CarParts.values) {
        String tex = CarPartsClass.getStringFromCarParts(part);
        a.add(FormBuilderFieldOption(
          value: tex,
          label: tex,
        ));
      }
      return a;
    }

    getSignatureExpandable() {
      return Padding(
        padding: EdgeInsets.all(10),
        child: ExpandablePanel(
          theme: const ExpandableThemeData(
            headerAlignment: ExpandablePanelHeaderAlignment.center,
            tapBodyToExpand: true,
            tapBodyToCollapse: false,
            hasIcon: false,
          ),
          header: Builder(builder: (context) {
            var exp = ExpandableController.of(context);
            return Container(
              decoration: BoxDecoration(
                color: Colors.white54,
                borderRadius: !exp.expanded ? BorderRadius.all(Radius.circular(12)) : BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    ExpandableIcon(
                      theme: const ExpandableThemeData(
                        expandIcon: Icons.arrow_right,
                        collapseIcon: Icons.arrow_drop_down,
                        iconColor: Colors.black,
                        iconSize: 28.0,
                        iconRotationAngle: math.pi / 2,
                        iconPadding: EdgeInsets.only(right: 5),
                        hasIcon: false,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "Your Signature (Optional)".toUpperCase(),
                        style: TextStyle(
                          fontSize: 18,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }), //dsakml
          expanded: FormBuilder(
            key: _fbKey3,
            initialValue: {
              'date': DateTime.now(),
              'accept_terms': false,
            },
            autovalidate: true,
            child: Column(
              children: <Widget>[
                FormBuilderSignaturePad(
                  attribute: 'sign',
                )
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppHeader(
              height: 230,
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Material(
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(30, 0, 50, 50),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Report Crash',
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 2, 10, 10),
                            child: Icon(
                              MaterialCommunityIcons.alert_box,
                              size: 30,
                              color: Colors.white70,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: ExpandablePanel(
                theme: const ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToExpand: true,
                  tapBodyToCollapse: false,
                  hasIcon: false,
                ),
                header: Builder(builder: (context) {
                  var exp = ExpandableController.of(context);
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white54,
                      borderRadius: !exp.expanded ? BorderRadius.all(Radius.circular(12)) : BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          ExpandableIcon(
                            theme: const ExpandableThemeData(
                              expandIcon: Icons.arrow_right,
                              collapseIcon: Icons.arrow_drop_down,
                              iconColor: Colors.black,
                              iconSize: 28.0,
                              iconRotationAngle: math.pi / 2,
                              iconPadding: EdgeInsets.only(right: 5),
                              hasIcon: false,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Personal Details".toUpperCase(),
                              style: TextStyle(
                                fontSize: 18,
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }), //dsakml
                expanded: buildPersonalDetails(),
              ),
            ),
            Container(
              height: 10,
            ),
            getSignatureExpandable(),
            Container(
              height: 10,
            ),
            BeautyTextfield(
              backgroundColor: Color.fromRGBO(255, 224, 222, 1),
              textColor: colorPalette[11],
              controller: controller,
              width: double.maxFinite,
              height: 90,
              maxLines: null,
              duration: Duration(milliseconds: 200),
              inputType: TextInputType.text,
              prefixIcon: Icon(
                Icons.description,
                color: colorPalette[11],
              ),
              suffixIcon: Icon(Icons.mic),
              placeholder: "Description",
              onClickSuffix: () {
                startRecordingForDescription();
              },
              onSubmitted: (data) {
                setState(() {
                  description = data;
                });
                //print(data.length);
              },
            ),
            Container(
              height: 16,
            ),
            TextHeadingWidget(text: "Parts Damaged"),
            FormBuilder(
              key: _fbKey2,
              initialValue: {
                'date': DateTime.now(),
                'accept_terms': false,
              },
              autovalidate: true,
              child: Column(
                children: <Widget>[
                  FormBuilderFilterChip(
                    attribute: "parts_damaged",
                    options: getCarPartsField(),
                  ),
                  Container(
                    height: 24,
                  ),
                  TextHeadingWidget(
                    text: 'Add Photos/Videos',
                  ),
                  FormBuilderImagePicker(
                    attribute: "images",
                  ),
                  FormBuilderCheckbox(
                    attribute: "emergency_family",
                    label: Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                      child: Text(
                        'Send information of crash to family',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    initialValue: true,
                  ),
                  FormBuilderCheckbox(
                    attribute: "emergency_responders",
                    label: Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                      child: Text(
                        'Send information of crash to ambulance',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    initialValue: true,
                  ),
                  FormBuilderCheckbox(
                    attribute: "third_person",
                    label: Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                      child: Text(
                        'You are not involved in this crash',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    initialValue: false,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Center(child: progressButton),
            ),
            Container(
              height: 8,
            )
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class TextHeadingWidget extends StatelessWidget {
  TextHeadingWidget({this.text});
  String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 8,
          ),
          Text(
            text.toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              letterSpacing: 2,
            ),
          ),
          Container(
            height: 2,
          ),
          Padding(padding: EdgeInsets.only(left: 4), child: CustomTextDec())
        ],
      ),
    );
  }
}
