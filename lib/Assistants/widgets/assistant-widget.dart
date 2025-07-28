// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, file_names
import 'package:flutter/material.dart';

class AssistantCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onTap;
  final IconData icon;

  AssistantCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 13),
        child: Card(
          elevation: 5, // Increased elevation for a more pronounced shadow
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(15), // Rounded corners for a modern look
          ),
          child: Container(
            height : 120,
            padding: const EdgeInsets.all(16), // Consistent padding
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade50,
                  Colors.white
                ], // Subtle gradient background
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius:
                  BorderRadius.circular(15), // Match card border radius
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Customer Details Section
                Row(
                  children: [
                    // Icon Section
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        // color: AppColors.primaryColor.withOpacity(0.1),
                        borderRadius:
                            BorderRadius.circular(10), // Rounded corners
                      ),
                      child: Icon(
                        icon,
                        size: 40,
                        // color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 16), // Spacing between icon and text
                    // Text Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors
                                  .black87, // Darker text for better readability
                            ),
                          ),
                          const SizedBox(height: 8), // Spacing
                          Text(
                            description,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54, // Slightly lighter text
                            ),
                          ),
                        // Spacing
                          // Text(
                          //   cusDetails.plotSize.toString(),
                          //   style: const TextStyle(
                          //     fontSize: 16,
                          //     fontWeight: FontWeight.w400,
                          //     color: AppColors.fontGrey,
                          //   ),
                          // ),
                          
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
    
  }
}


// 

