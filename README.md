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

  'MerchantReturnURL': 'SDK',
  'MerchantCallbackURL': 'SDK',

  'ServiceId': 'SIT',
  'Password': 'sit12345',
  'LanguageCode': 'EN',
  'PageTimeout': '600',
  'PaymentGateway': 'https://test2pay.ghl.com/IPGSG/Payment.aspx'
};

result = await Eghlflutter.executePayment(payment);
