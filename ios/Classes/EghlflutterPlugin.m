#import "EghlflutterPlugin.h"
#import <objc/runtime.h>
#import <EGHL/EGHL.h>

 @implementation EghlflutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"eghlflutter"
            binaryMessenger:[registrar messenger]];
  EghlflutterPlugin* instance = [[EghlflutterPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"executePayment" isEqualToString:call.method]) {
      PaymentRequestPARAM *payParams = [[PaymentRequestPARAM alloc] init];
      EGHLPayment *eghlPay = [[EGHLPayment alloc] init];
      
      payParams.TransactionType = [call.arguments valueForKey:@"TransactionType"];
      payParams.PaymentID = [call.arguments valueForKey:@"PaymentId"];
      payParams.OrderNumber = [call.arguments valueForKey:@"OrderNumber"];
      payParams.ServiceID = [call.arguments valueForKey:@"ServiceId"];
      payParams.MerchantName = [call.arguments valueForKey:@"MerchantName"];
      payParams.PymtMethod = [call.arguments valueForKey:@"PymtMethod"];
      payParams.MerchantReturnURL = [call.arguments valueForKey:@"MerchantReturnURL"];
      payParams.MerchantCallBackURL = [call.arguments valueForKey:@"MerchantCallBackURL"];
      payParams.MerchantApprovalURL = [call.arguments valueForKey:@"MerchantApprovalURL"];
      payParams.MerchantUnApprovalURL = [call.arguments valueForKey:@"MerchantUnApprovalURL"];
      payParams.CustMAC = [call.arguments valueForKey:@"CustMAC"];
      payParams.PageTimeout = [call.arguments valueForKey:@"PageTimeout"];
      payParams.CustEmail = [call.arguments valueForKey:@"CustEmail"];
      payParams.CustPhone = [call.arguments valueForKey:@"CustPhone"];
      payParams.CustIP = [call.arguments valueForKey:@"CustIP"];
      payParams.CustName = [call.arguments valueForKey:@"CustName"];
      payParams.PaymentDesc = [call.arguments valueForKey:@"PaymentDesc"];
      payParams.Amount = [call.arguments valueForKey:@"Amount"];
      payParams.EPPMonth = [call.arguments valueForKey:@"EPPMonth"];
      payParams.CurrencyCode = [call.arguments valueForKey:@"CurrencyCode"];
      payParams.LanguageCode = [call.arguments valueForKey:@"LanguageCode"];
      payParams.IssuingBank = [call.arguments valueForKey:@"IssuingBank"];
      payParams.Password = [call.arguments valueForKey:@"Password"];
      payParams.CardHolder = [call.arguments valueForKey:@"CardHolder"];
      payParams.CardNo = [call.arguments valueForKey:@"CardNo"];
      payParams.CardExp = [call.arguments valueForKey:@"CardExp"];
      payParams.CardCVV2 = [call.arguments valueForKey:@"CardCVV2"];
      payParams.BillAddr = [call.arguments valueForKey:@"BillAddr"];
      payParams.BillPostal = [call.arguments valueForKey:@"BillPostal"];
      payParams.BillCity = [call.arguments valueForKey:@"BillCity"];
      payParams.BillRegion = [call.arguments valueForKey:@"BillRegion"];
      payParams.BillCountry = [call.arguments valueForKey:@"BillCountry"];
      payParams.PromoCode = [call.arguments valueForKey:@"PromoCode"];
      payParams.ShipAddr = [call.arguments valueForKey:@"ShipAddr"];
      payParams.ShipPostal = [call.arguments valueForKey:@"ShipPostal"];
      payParams.ShipCity = [call.arguments valueForKey:@"ShipCity"];
      payParams.ShipRegion = [call.arguments valueForKey:@"ShipRegion"];
      payParams.ShipCountry = [call.arguments valueForKey:@"ShipCountry"];
      payParams.Token = [call.arguments valueForKey:@"Token"];
      payParams.TokenType = [call.arguments valueForKey:@"TokenType"];
      payParams.SessionID = [call.arguments valueForKey:@"SessionID"];
      payParams.B4TaxAmt = [call.arguments valueForKey:@"B4TaxAmt"];
      payParams.Param6 = [call.arguments valueForKey:@"Param6"];
      payParams.Param7 = [call.arguments valueForKey:@"Param7"];
      payParams.ReqToken = [call.arguments valueForKey:@"ReqToken"];
      payParams.ReqVerifier = [call.arguments valueForKey:@"ReqVerifier"];
      payParams.PairingToken = [call.arguments valueForKey:@"PairingToken"];
      payParams.PairingVerifier = [call.arguments valueForKey:@"PairingVerifier"];
      payParams.CheckoutResourceURL = [call.arguments valueForKey:@"CheckoutResourceURL"];
      payParams.CardId = [call.arguments valueForKey:@"CardId"];
      payParams.PreCheckoutId = [call.arguments valueForKey:@"PreCheckoutId"];
      payParams.mpLightboxParameter = [call.arguments valueForKey:@"mpLightboxParameter"];
      payParams.sdkTimeOut = [[call.arguments objectForKey:@"sdkTimeout"] doubleValue];
      BOOL gatewayUrl = [[call.arguments valueForKey:@"PaymentGateway"] boolValue];
      BOOL cardPageEnable = [[call.arguments valueForKey:@"EnableCardPage"] boolValue];
      BOOL triggerReturnUrl = [[call.arguments valueForKey:@"TriggerReturnURL"] boolValue];
      payParams.settingDict = @{
          EGHL_DEBUG_PAYMENT_URL: [NSNumber numberWithBool:gatewayUrl],
          EGHL_ENABLED_CARD_PAGE: [NSNumber numberWithBool:cardPageEnable],
          EGHL_SHOULD_TRIGGER_RETURN_URL: [NSNumber numberWithBool:triggerReturnUrl],
      };

      
      UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];

      UIViewController *vc = keyWindow.rootViewController;
      
      [eghlPay execute:payParams fromViewController:vc successBlock:^(PaymentRespPARAM *responseData) {
          //Convert to NSData
          NSMutableDictionary *dict = [NSMutableDictionary dictionary];
          unsigned count;
          objc_property_t *properties = class_copyPropertyList([responseData class], &count);
          for(int i=0; i<count; i++) {
              NSString* key = [NSString stringWithUTF8String:property_getName(properties[i])];
              NSString *value = [responseData valueForKey:key];
              
              if(value)[dict setObject:value forKey:key];
          }
          
          NSError* error;
          NSData* responseJsonData = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:&error];
          
          result([[NSString alloc] initWithData:responseJsonData encoding:NSUTF8StringEncoding]);
          
      }failedBlock:^(NSString *errorCode, NSString *errorData, NSError *error) {
          result([FlutterError errorWithCode:[NSString stringWithFormat:@"Error %ld", error.code]
          message:error.domain details: nil]);
      }];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
