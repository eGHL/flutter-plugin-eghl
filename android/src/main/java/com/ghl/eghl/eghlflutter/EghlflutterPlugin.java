package com.ghl.eghl.eghlflutter;

import android.app.Activity;
import android.content.Intent;
import android.util.Log;

import com.eghl.sdk.EGHL;
import com.eghl.sdk.params.PaymentParams;
import com.eghl.sdk.payment.PaymentActivity;
import com.google.gson.Gson;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** EghlflutterPlugin */
public class EghlflutterPlugin implements MethodCallHandler, PluginRegistry.ActivityResultListener {
  private Activity _activity;
  private EghlPaymentParam paymentParam;
  private static final String TAG = "eGHLModule";
  private Result _result;


  private EghlflutterPlugin(Activity activity) {
    this._activity = activity;
  }

  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "eghlflutter");
    EghlflutterPlugin plugin = new EghlflutterPlugin(registrar.activity());
    registrar.addActivityResultListener(plugin);
    channel.setMethodCallHandler(plugin);
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("executePayment")) {
        this._result = result;
        paymentParam = new Gson().fromJson(new Gson().toJsonTree(call.arguments()).getAsJsonObject().toString(), EghlPaymentParam.class);

        try {
          PaymentParams.Builder params = new PaymentParams.Builder()
                  /*Mandatory fields*/
                  .setTransactionType(paymentParam.getTransactionType())
                  .setPaymentMethod(paymentParam.getPaymentMethod())
                  .setServiceId(paymentParam.getServiceId())
                  .setPaymentId(paymentParam.getPaymentId())
                  .setOrderNumber(paymentParam.getOrderNumber())
                  .setPaymentDesc(paymentParam.getPaymentDesc())
                  .setMerchantReturnUrl(paymentParam.getMerchantReturnUrl())
                  .setMerchantCallbackUrl(paymentParam.getMerchantCallbackUrl())
                  .setAmount(paymentParam.getAmount())
                  .setCurrencyCode(paymentParam.getCurrencyCode())
                  .setPassword(paymentParam.getPassword())
                  .setLanguageCode(paymentParam.getLanguageCode())
                  .setDebugPaymentURL(paymentParam.getProduction())
                  .setPageTimeout(paymentParam.getPageTimeout())

                  /*Optional fields*/
                  .setCustIp(paymentParam.getCustIp())
                  .setCustName(paymentParam.getCustName())
                  .setCustEmail(paymentParam.getCustEmail())
                  .setCustPhone(paymentParam.getCustPhone())
                  .setB4TaxAmt(paymentParam.getB4TaxAmt())
                  .setTaxAmt(paymentParam.getTaxAmt())
                  .setMerchantName(paymentParam.getMerchantName())
                  .setCustMac(paymentParam.getCustMac())
                  .setMerchantApprovalUrl(paymentParam.getMerchantApprovalUrl())
                  .setMerchantUnapprovalUrl(paymentParam.getMerchantUnapprovalUrl())
                  .setPaymentTimeout(paymentParam.getPaymentTimeout())
                  .setCardHolder(paymentParam.getCardHolder())
                  .setCardNo(paymentParam.getCardNo())
                  .setCardExp(paymentParam.getCardExp())
                  .setCardCvv2(paymentParam.getCardCvv2())
                  .setIssuingBank(paymentParam.getIssuingBank())
                  .setBillAddr(paymentParam.getBillAddr())
                  .setBillPostal(paymentParam.getBillPostal())
                  .setBillCity(paymentParam.getBillCity())
                  .setBillRegion(paymentParam.getBillRegion())
                  .setBillCountry(paymentParam.getBillCountry())
                  .setShipAddr(paymentParam.getShipAddr())
                  .setShipPostal(paymentParam.getShipPostal())
                  .setShipCity(paymentParam.getShipCity())
                  .setShipRegion(paymentParam.getShipRegion())
                  .setShipCountry(paymentParam.getShipCountry())
                  .setSessionId(paymentParam.getSessionId())
                  .setTokenType(paymentParam.getTokenType())
                  .setToken(paymentParam.getToken())
                  .setParam6(paymentParam.getParam6())
                  .setParam7(paymentParam.getParam7())
                  .setEppMonth(paymentParam.getEppMonth())

                  /*Conditional fields*/
                  .setPromoCode(paymentParam.getPromoCode())
                  .setTriggerReturnURL(paymentParam.getTriggerReturnUrl());

          Intent payment = new Intent(this._activity, PaymentActivity.class);
          payment.putExtras(params.build());

          this._activity.startActivityForResult(payment, EGHL.REQUEST_PAYMENT);
        } catch (Exception e) {
          this._result.error("eGHLModule", e.getMessage(), null);
        }
    } else {
      result.notImplemented();
    }
  }

  @Override
  public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
    if(_result == null) {
      return false;
    }
    else if (requestCode == EGHL.REQUEST_PAYMENT) {
      isInProgress = false;
      String message = data.getStringExtra(EGHL.TXN_MESSAGE);
      switch (resultCode) {
        case EGHL.TRANSACTION_SUCCESS:
          Log.d(TAG, "onActivityResult: payment successful");
          String resultString = data.getStringExtra(EGHL.RAW_RESPONSE);
          this._result.success(resultString);
          this._result = null;

          break;
        case EGHL.TRANSACTION_FAILED:
          if(message == null) {
            Log.d(TAG, "onActivityResult: payment failure");
            this._result.error("PAYMENT_FAILED", String.valueOf(resultCode), null);
            this._result = null;
          } else {
            // Check for "buyer cancelled" string in JS
            Log.d(TAG, "onActivityResult: payment failure or cancelled '"+message+"'");
            this._result.error("PAYMENT_CANCELLED", message, null);
            this._result = null;
          }

          break;
        default:
          Log.d(TAG, "onActivityResult: " + resultCode);
          if(message == null) {
            this._result.error("UNKNOWN_FAILED", String.valueOf(resultCode), null);
            this._result = null;
          } else {
            this._result.error("UNKNOWN_CANCELLED", message, null);
          }

          break;
      }
    }
    return false;
  }
}

