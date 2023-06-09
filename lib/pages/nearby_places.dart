import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:voyager_v01/nearby_reponse.dart';

import 'package:http/http.dart' as http;

class NearByPlacesScreen extends StatefulWidget {
  const NearByPlacesScreen({Key? key}) : super(key: key);

  @override
  State<NearByPlacesScreen> createState() => _NearByPlacesScreenState();
}

class _NearByPlacesScreenState extends State<NearByPlacesScreen> {
  String apiKey = "AIzaSyDi9LTi74Ad-hxuJC8n92hHUBD2O9ItN4U";
  double _radius = 250;

  double latitude = 38.7377200;
  double longitude = 35.473196;

  NearbyPlacesResponse nearbyPlacesResponse = NearbyPlacesResponse();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nearby Places',
          style: TextStyle(fontSize: 22),
        ),
        centerTitle: true,
        backgroundColor: Color(0xffFF6000),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Row(
            children: [
              ElevatedButton(
                  onPressed: () {
                    getNearbyPlacesByType('school');
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffFF6000),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                  child: Row(
                    children: const <Widget>[
                      Icon(Icons.school),
                      SizedBox(width: 8),
                      Text(
                        "Schools",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  )),
              const SizedBox(width: 10),
              ElevatedButton(
                  onPressed: () {
                    getNearbyPlacesByKeyword('hukuk');
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffFF6000),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                  child: Row(
                    children: const [
                      Icon(Icons.balance),
                      SizedBox(width: 8),
                      Text(
                        "Law Offices",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  )),
            ],
          ),
          Row(
            children: [
              ElevatedButton(
                  onPressed: () {
                    getNearbyPlacesByKeyword('restaurant');
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffFF6000),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                  child: Row(
                    children: const [
                      Icon(Icons.dining_sharp),
                      SizedBox(width: 8),
                      Text(
                        "Restaurants",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  )),
              const SizedBox(width: 10),
              ElevatedButton(
                  onPressed: () {
                    getNearbyPlacesByKeyword('coffee');
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffFF6000),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                  child: Row(
                    children: const [
                      Icon(Icons.coffee),
                      SizedBox(width: 8),
                      Text(
                        "Cafés",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  )),
            ],
          ),
          Row(
            children: [
              ElevatedButton(
                  onPressed: () {
                    getNearbyPlacesByKeyword('shopping');
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffFF6000),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                  child: Row(
                    children: const [
                      Icon(Icons.shopping_bag),
                      SizedBox(width: 8),
                      Text(
                        "Shopping",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  )),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Adjust Radius',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Slider(
              activeColor: Color(0xffFF6000),
              inactiveColor: Colors.black45,
              max: 300,
              min: 80,
              divisions: 4,
              value: _radius,
              label: _radius.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _radius = value;
                });
              }),
          if (nearbyPlacesResponse.results != null)
            for (int i = 0; i < nearbyPlacesResponse.results!.length; i++)
              nearbyPlacesWidget(nearbyPlacesResponse.results![i])
        ],
      )),
    );
  }

  void getNearbyPlacesByKeyword(String input) async {
    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?keyword=$input&location=$latitude,$longitude&radius=$_radius&key=$apiKey');

    var response = await http.post(url);

    nearbyPlacesResponse =
        NearbyPlacesResponse.fromJson(jsonDecode(response.body));

    setState(() {});
  }

  void getNearbyPlacesByType(String input) async {
    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=$_radius&type=$input&key=$apiKey');

    var response = await http.post(url);

    nearbyPlacesResponse =
        NearbyPlacesResponse.fromJson(jsonDecode(response.body));

    setState(() {});
  }

  Widget nearbyPlacesWidget(Results results) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              results.name!,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('${results.vicinity}'),
            Text(
              results.openingHours != null ? "Open" : "Closed",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
