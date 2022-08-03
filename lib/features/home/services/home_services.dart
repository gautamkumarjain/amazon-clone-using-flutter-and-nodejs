import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/error_handling.dart';
import '../../../constants/global_variables.dart';
import '../../../constants/utils.dart';
import '../../../models/product.dart';
import 'package:http/http.dart' as http;

import '../../../provider/user_provider.dart';

class HomeServices {
  Future<List<Product>> fetchCategoryProducts(
      {required BuildContext context, required String category}) async {
    List<Product> productList = [];

    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/products?category=$category'),
        headers: <String, String>{
          'content-Type': 'application/json; charset=UTF-8',
          // ignore: use_build_context_synchronously
          'x-auth-token':
              // ignore: use_build_context_synchronously
              Provider.of<UserProvider>(context, listen: false).user.token,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSucess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            productList.add(
              Product.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      showSnakeBar(context, e.toString());
    }

    return productList;
  }

  Future<Product> fetchDealOfDay({required BuildContext context}) async {
    Product product = Product(
        name: '',
        description: '',
        quantity: 0,
        images: [],
        category: '',
        price: 0);

    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/deal-of-day'),
        headers: <String, String>{
          'content-Type': 'application/json; charset=UTF-8',
          // ignore: use_build_context_synchronously
          'x-auth-token':
              // ignore: use_build_context_synchronously
              Provider.of<UserProvider>(context, listen: false).user.token,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSucess: () {
          product = Product.fromJson(res.body);
        },
      );
    } catch (e) {
      showSnakeBar(context, e.toString());
    }

    return product;
  }
}
