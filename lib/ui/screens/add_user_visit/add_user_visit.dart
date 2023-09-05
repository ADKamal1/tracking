import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hook_atos/animation/faidAnimation.dart';
import 'package:hook_atos/layout/cubit/main_cubit.dart';
import 'package:hook_atos/model/LineModel.dart';
import 'package:hook_atos/model/customers_model.dart';
import 'package:hook_atos/ui/screens/success_screen/success_screen.dart';
import 'package:intl/intl.dart';
import 'package:tbib_toast/tbib_toast.dart';

import '../../../shared/helper/mangers/size_config.dart';
import '../../components/custom_button.dart';
import '../map_screen_distance/map_screen_distance.dart';
import '../user_old_visits/cubit/user_visits_cubit.dart';

class AddUserVisitScreen extends StatefulWidget {
  CustomerModel customerModel;
  bool planed;
  bool states;
  String note;
  String visitId;

  AddUserVisitScreen(
    this.customerModel,
    this.states,
    this.note,
    this.planed,
     this.visitId
  );

  @override
  State<AddUserVisitScreen> createState() => _AddUserVisitScreen();
}

class _AddUserVisitScreen extends State<AddUserVisitScreen> {
  var note = '';
  var formKey = GlobalKey<FormState>();
  TimeOfDay _selectedTime = TimeOfDay.now();
  DateTime _selectedDate = DateTime.now();
  String? selectedDis;
  Product? selectedpro;

  Line fullLine = Line(
      name: '',
      classification: [],
      distribution: [],
      speciality: [],
      products: [],type: []);
  String? proName;

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (newTime != null) {
      setState(() {
        _selectedTime = newTime;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (newDate != null) {
      setState(() {
        _selectedDate = newDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    MainCubit linesData = MainCubit.get(context);
    linesData.getUserData();
    linesData.getLines();
if(linesData.lines.isNotEmpty) {
  fullLine = linesData.lines
      .firstWhere((element) => element.name == widget.customerModel.line);
}
    return BlocConsumer<UserVisitsCubit, UserVisitsState>(
      listener: (context, state) async {
        if (state is AddVistingError) {
          Navigator.pop(context);
          Toast.show(state.metter, context,
              backgroundColor: Colors.red, duration: 10);
          LatLng customerPlace = LatLng(
              widget.customerModel.lat ?? 0.0, widget.customerModel.lon ?? 0.0);
          LatLng myPosition = LatLng(state.lat, state.lng);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MapScreenDistance(
                        myPos: myPosition,
                        customerPos: customerPlace,
                      ))).then((value) {
            setState(() {});
          });
        } else if (state is AddVistingSuccess) {
          if(widget.planed) {
            FirebaseFirestore.instance
                .collection('visitsV2')
                .doc(widget.visitId)
                .update({'status': true});
          }

          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SuccessScreen(),
              ));

          Toast.show("Visit added successfully", context,
              backgroundColor: Colors.green, duration: 5);
        } else if (state is TryCatchState) {
          Navigator.pop(context);
          Toast.show(state.error, context,
              backgroundColor: Colors.red, duration: 5);
        } else if (state is AddVistingLoading) {
          Center(
            child: CircularProgressIndicator(
              color: Colors.red,
              strokeWidth: 10,
              backgroundColor: Colors.grey,
            ),
          );
        }
      },
      builder: (context, state) {
        UserVisitsCubit cubit = UserVisitsCubit.get(context);



          return

            Scaffold(
            body:

            (linesData.lines.isNotEmpty)?
            SafeArea(
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(getProportionateScreenHeight(10)),
                    child: Center(
                      child: Column(
                        children: [
                          Container(
                            width: 350,
                            child: Card(
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0, vertical: 24),
                                child: FadeAnimation(
                                  0.5,
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Name : " +
                                            widget.customerModel.name
                                                .toString(),
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        "Phone : " +
                                            widget.customerModel.phone
                                                .toString(),
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        "Adress : " +
                                            widget.customerModel.address
                                                .toString(),
                                        maxLines: 3,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        "Line : " +
                                            widget.customerModel.line
                                                .toString(),
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        "Class : " +
                                            widget.customerModel.classy
                                                .toString(),
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        "specilty : " +
                                            widget.customerModel.specialty
                                                .toString(),
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        "Type : " +
                                            widget.customerModel.type
                                                .toString(),
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ExpansionTile(
                            title: Center(
                                child: Text(
                              'Notes ',
                              style: TextStyle(
                                color: Colors.deepOrange,
                                fontSize: 24,
                              ),
                            )),
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(widget.note),
                              )
                            ],
                            backgroundColor: Colors.white38,
                            collapsedBackgroundColor: Colors.white38,
                            tilePadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            collapsedIconColor: Colors.black,
                          ),
                          SizedBox(
                            height: SizeConfigManger.bodyHeight * .01,
                          ),
                          FadeAnimation(
                            1.3,
                            ElevatedButton(
                              onPressed: () {
                                _selectDate(context);
                              },
                              child: Text(
                                'Date for next visit ',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          FadeAnimation(
                            1.5,
                            Text(
                              'Selected date: ${DateFormat('dd/MM/yyyy').format(_selectedDate).toString()}',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w600),
                            ),
                          ),
                          FadeAnimation(
                            1.7,
                            ElevatedButton(
                              onPressed: () {
                                _selectTime(context);
                              },
                              child: Text(
                                'Time for next visit',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          Text(
                            'Selected time: ${_selectedTime.format(context).toString()}',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: SizeConfigManger.bodyHeight * .01,
                          ),
                          FadeAnimation(
                            1.8,
                            Builder(builder: (context) {
                              return DropdownButton<String>(
                                items: fullLine.distribution
                                    .toSet()
                                    .map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedDis = value;
                                  });
                                },
                                value: selectedDis,
                                hint: Text("Distruibutors"),
                              );
                            }),
                          ),
                          FadeAnimation(
                            2.2,
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Leave notes',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepOrange.shade900,
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  TextFormField(
                                    onChanged: (f) {
                                      setState(() {
                                        note = f;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Enter your notes here...',
                                      filled: true,
                                      fillColor: Colors.grey[80],
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: Colors.grey[400]!),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                            color: Colors.deepPurple),
                                      ),
                                    ),
                                    maxLines: 3,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                          state is AddVistingLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.red,
                                    strokeWidth: 10,
                                    backgroundColor: Colors.grey,
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          getProportionateScreenHeight(20)),
                                  child: CustomButton(
                                      press: () async {
                                        if (_selectedDate == null ||
                                            _selectedTime == null) {
                                          Toast.show(
                                              "select date and time", context,
                                              backgroundColor: Colors.red,
                                              duration: 1);
                                        } else {
                                          print(_selectedDate.toString());
                                          if (formKey.currentState!
                                              .validate()) {
                                            try {
                                              cubit.addVisitUser(
                                                planed: widget.planed,
                                                userName:
                                                    widget.customerModel.name ??
                                                        "",
                                                phone: widget
                                                        .customerModel.phone ??
                                                    "",
                                                name:
                                                    widget.customerModel.name ??
                                                        "",
                                                image: widget
                                                        .customerModel.image ??
                                                    "",
                                                orginalLat:
                                                    widget.customerModel.lat ??
                                                        0.0,
                                                orginalLong:
                                                    widget.customerModel.lon ??
                                                        0.0,
                                                line: widget.customerModel.line
                                                    .toString(),
                                                classy: widget
                                                    .customerModel.classy
                                                    .toString(),
                                                specilty: widget.customerModel
                                                        .specialty ??
                                                    "",
                                                dist: selectedDis ?? "",
                                                nextVisitDate:
                                                    DateFormat('dd/MM/yyyy')
                                                        .format(_selectedDate)
                                                        .toString(),
                                                visitDate:
                                                    DateFormat('dd/MM/yyyy')
                                                        .format(DateTime.now())
                                                        .toString(),
                                                states: widget.states,
                                                note: note,
                                                type: widget.customerModel.type??""
                                              );
                                            } catch (error) {
                                              // Handle any errors that occurred during the process
                                              print(
                                                  'Error in addVisitAndUpdateStatus: $error');
                                              return null;
                                            }
                                          }
                                        }
                                      },
                                      text: "Add Visit"),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ):Container(child: Center(child: CircularProgressIndicator(strokeWidth: 2,color: Colors.red,)),),
          );

      },
    );
  }
}
