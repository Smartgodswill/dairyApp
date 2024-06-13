import 'package:bookapp/custom.dart/time.dart';
import 'package:bookapp/themes/stylescreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Widget noteCard(Function()? onTap, QueryDocumentSnapshot doc) {
  String title = doc['title'];
  String noteContent = doc['note contains'];
  String formattedDate = doc['current_date'];
  String formattedTime = doc['current_time'];

  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
              image: AppStyles.images[doc["image_id"]], fit: BoxFit.cover),
        ),
        height: 150,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  title,
                  style: AppStyles.titleStyle,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: DeviceTimeWidget(
                        text: formattedTime,
                        style: AppStyles.dateStyle,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        formattedDate,
                        style: AppStyles.timeStyle,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    noteContent,
                    style: AppStyles.contentStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
