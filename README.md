# eGHL Flutter Plugin

An example of Flutter integration with eGHL SDK

## Guidelines linking to SDK

Refer [here](https://github.com/eGHL/flutter-plugin-eghl/wiki/Android-&-iOS-SDK-library-linking) on how to link for iOS & Android platform

## Usage 
---------------

### Request Payment

```
String paymentId = 'DEMO${new DateTime.now().millisecondsSinceEpoch}';

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
  'MerchantReturnURL': 'SDK',   //merchant system's browser redirect
  'MerchantCallBackURL': 'SDK', //server-to-server URL as an additional link to merchant's website

  'ServiceId': 'SIT',
  'Password': 'sit12345',
  'LanguageCode': 'EN',
  'PageTimeout': '600',
  'PaymentGateway': true,      //default is true for staging, false for production
  'EnableCardPage': false,    //default is false
  'TriggerReturnURL': false, //default is false
};

result = await Eghlflutter.executePayment(payment);
