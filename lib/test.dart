library dart_force_mvc_unittest_lib;

import 'package:mock/mock.dart';
import 'package:forcemvc/force_mvc.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';

class MockHttpRequest extends Mock implements HttpRequest {}

class MockForceRequest implements ForceRequest {
  
   var postData;
   Map<String, String> postParams = new Map<String, String>();
   List<Cookie> mockCookies = new List<Cookie>();
   
   HttpRequest request;
   Map<String, String> path_variables;
   Completer _asyncCallCompleter;
   
   MockForceRequest({this.postData: "test"}) {
     path_variables = new Map<String, String>(); 
     _asyncCallCompleter = new Completer();
     request = new MockHttpRequest();
   }
   
   List header(String name) => new List();

   bool accepts(String type) => true;

   bool isMime(String type) => true;

   bool get isForwarded => false;

   List<Cookie> get cookies => mockCookies;
   
   Future<dynamic> getPostData({ bool usejson: true }) {
     Completer<dynamic> completer = new Completer<dynamic>();
     completer.complete(postData);

     return completer.future;
   }
   
   Future<Map<String, String>> getPostRawData() {
       Completer c = new Completer();
       c.complete(postParams);
       return c.future;
     }
   
   Future<Map<String, String>> getPostParams({ Encoding enc: UTF8 }) {
     Completer c = new Completer();
     c.complete(postParams);
     return c.future;
   }
   
   void async(value) {
     this._asyncCallCompleter.complete(value);
   }
   
   Future get asyncFuture => _asyncCallCompleter.future;
  
}