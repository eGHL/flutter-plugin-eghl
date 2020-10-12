import 'package:flutter/material.dart';
import 'package:eghlflutter/eghlflutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _eghlPaymentResult = 'Awaiting for payment.';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('eGHL Payment'),
        ),
        body: Container(
          child: Center (
            child: Column (
              mainAxisAlignment:  MainAxisAlignment.center,
              children: [
                Text(this._eghlPaymentResult),
                RaisedButton(
                  child: Text("Pay"),
                  onPressed: () {
                    _Pay(context);
                  },
                  color: Colors.amberAccent,
                  textColor: Colors.black,
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  splashColor: Colors.amber,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  void _Pay(BuildContext context) async {
    String result = '';
    String paymentId = 'SIT${new DateTime.now().millisecondsSinceEpoch}';

    try {
      Map<String, dynamic> payment = {
        'TransactionType': 'SALE',
        'Amount': '1.00',
        'CurrencyCode': 'MYR',
        'PaymentId': paymentId,
        'OrderNumber': paymentId,
        'PaymentDesc': 'Testing Payment',
        'PymtMethod': 'ANY',

        'CustName': 'somebody',
        'CustEmail': 'somebody@someone.com',
        'CustPhone': '0123456789',

        'MerchantReturnURL': 'SDK',
        'MerchantCallBackURL': 'SDK',

        'ServiceId': 'SIT',
        'Password': 'sit12345',
        'LanguageCode': 'EN',
        'PageTimeout': '600',
        'PaymentGateway': true,
        'EnableCardPage': false,
        'TriggerReturnURL' : false,
      };

      result = await Eghlflutter.executePayment(payment);
    } catch(e) {
      result = e.message;
    }

    setState(() {
      _eghlPaymentResult = result;
    });
  }
}
