import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<Map<String, dynamic>> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  // Fetch notifications from Supabase
  Future<void> _fetchNotifications() async {
    try {
      final response = await Supabase.instance.client
          .from('notifications')
          .select()
          .order('timestamp', ascending: false);

      setState(() {
        notifications = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  String _formatTimestamp(String? timestamp) {
    if (timestamp == null) return 'No Timestamp';
    try {
      final dateTime = DateTime.parse(timestamp);
      return DateFormat('yMMMd • h:mm a').format(dateTime);
    } catch (e) {
      return 'Invalid Date';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: const Text(
            'Notifications',
            style: TextStyle(
              // color: Colors.orange,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.teal,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : notifications.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_off,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No notifications available',
                        style: TextStyle(
                          fontSize: isTablet ? 24 : 18,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.separated(
                    itemCount: notifications.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                notification['title'] ?? 'No Title',
                                style: TextStyle(
                                  fontSize: isTablet ? 20 : 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                notification['body'] ?? 'No Body',
                                style: TextStyle(
                                  fontSize: isTablet ? 16 : 14,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _formatTimestamp(notification['timestamp']),
                                style: TextStyle(
                                  fontSize: isTablet ? 14 : 12,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
