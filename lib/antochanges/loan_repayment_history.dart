import 'package:craft_dynamic/craft_dynamic.dart';
import 'package:flutter/material.dart';

class LoanRepaymentHistoryScreen extends StatefulWidget {
  final ModuleItem moduleItem;
  final String encryptedPin;
  const LoanRepaymentHistoryScreen({
    super.key,
    required this.moduleItem,
    required this.encryptedPin,
  });

  @override
  State<LoanRepaymentHistoryScreen> createState() =>
      _LoanRepaymentHistoryScreenState();
}

class _LoanRepaymentHistoryScreenState
    extends State<LoanRepaymentHistoryScreen> {
  final _apiServices = APIService();
  List<Map<String, dynamic>> eventList = [];
  bool isLoading = true;
  List<FormItem> formControls = [];
  final formRepo = FormsRepository();
  FormItem? recentList;

  @override
  void initState() {
    super.initState();
    _apiServices
        .getLoanRepaymentHistory(userPin: widget.encryptedPin)
        .then((response) {
      setState(() {
        if (response != null && response.status == "000") {
          eventList =
              List<Map<String, dynamic>>.from(response.dynamicList ?? []);
          isLoading = false;
        } else {
          eventList = [];
          isLoading = false;
        }
      });
    }).catchError((error) {
      debugPrint('Error fetching repayment list: $error');
      setState(() {
        eventList = [];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Loan Repayment History"),
      ),
      body: SingleChildScrollView(
          child: Container(
        child: Text("data"),
      )
          // Container(
          //   child: Column(
          //     children: [
          //       isLoading == false
          //           ? ListView.builder(
          //               shrinkWrap: true,
          //               itemCount: eventList.length,
          //               itemBuilder: (context, index) {
          //                 return Padding(
          //                   padding: const EdgeInsets.all(8.0),
          //                   child: Container(
          //                     decoration: BoxDecoration(
          //                       border: Border.all(),
          //                       borderRadius:
          //                           const BorderRadius.all(Radius.circular(10)),
          //                     ),
          //                     child: ListTile(
          //                       leading: Container(
          //                           width: 40.0,
          //                           height: 40.0,
          //                           decoration: BoxDecoration(
          //                             shape: BoxShape.circle,
          //                             border: Border.all(
          //                               width: 1.0,
          //                             ),
          //                           ),
          //                           child: Icon(Icons.event)),
          //                       title: Text(
          //                         eventList[index]["EVENTNAME"] ??
          //                             'Event Name Missing',
          //                         style: TextStyle(
          //                             color: AppTheme.primaryColor, fontSize: 15),
          //                       ),
          //                       trailing: Icon(
          //                         Icons.arrow_forward_ios_sharp,
          //                         size: 20,
          //                         color: AppTheme.primaryColor,
          //                       ),
          //                       onTap: () {
          //                         context.navigate(DynamicEventPaymentFormScreen(
          //                           moduleItem: widget.moduleItem,
          //                           eventName: eventList[index]["EVENTNAME"],
          //                         ));
          //                       },
          //                     ),
          //                   ),
          //                 );
          //               },
          //             )
          //           : const SizedBox(height: 200, child: CircleLoader())
          //     ],
          //   ),
          // ),
          ),
    );
  }
}
