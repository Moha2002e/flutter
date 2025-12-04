import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'dart:io' show Platform;

/// Service pour gérer les notifications locales (Android uniquement)
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  /// Initialise le service de notifications (Android uniquement)
  Future<void> initialize() async {
    if (_initialized) return;
    
    // Ne fonctionne que sur Android
    if (!Platform.isAndroid) {
      debugPrint('Notifications disponibles uniquement sur Android');
      return;
    }

    // Initialiser timezone
    tz.initializeTimeZones();

    // Configuration Android uniquement
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Configuration d'initialisation (Android uniquement)
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    // Initialiser le plugin
    final initialized = await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Demander les permissions Android 13+ (disponible dans les versions récentes)
    if (Platform.isAndroid) {
      final androidImplementation = _notifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      
      if (androidImplementation != null) {
        // La méthode requestNotificationsPermission existe dans les versions récentes
        try {
          await androidImplementation.requestNotificationsPermission();
        } catch (e) {
          // Si la méthode n'existe pas, on continue quand même
          debugPrint('Permission request not available: $e');
        }
      }
    }
    
    _initialized = initialized ?? false;
  }

  /// Gère le tap sur une notification
  void _onNotificationTapped(NotificationResponse response) {
    // Vous pouvez naviguer vers un écran spécifique ici si nécessaire
    print('Notification tapée: ${response.payload}');
  }

  /// Affiche une notification immédiate (Android uniquement)
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!Platform.isAndroid) return;
    if (!_initialized) await initialize();

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'campuslink_channel',
      'CampusLink Notifications',
      channelDescription: 'Notifications pour les événements et clubs',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    await _notifications.show(id, title, body, details, payload: payload);
  }

  /// Programme une notification pour une date/heure spécifique (Android uniquement)
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    if (!Platform.isAndroid) return;
    if (!_initialized) await initialize();

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'campuslink_channel',
      'CampusLink Notifications',
      channelDescription: 'Notifications pour les événements et clubs',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      details,
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// Annule une notification programmée
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  /// Annule toutes les notifications
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  /// Notifie qu'un nouveau club a été créé
  Future<void> notifyNewClub(String clubName) async {
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: 'Nouveau club créé !',
      body: 'Un nouveau club "$clubName" a été créé. Découvrez-le maintenant !',
      payload: 'club',
    );
  }

  /// Notifie qu'un nouvel événement a été créé
  Future<void> notifyNewEvent(String eventName, DateTime? eventDate) async {
    final now = DateTime.now();
    final id = now.millisecondsSinceEpoch.remainder(100000);

    if (eventDate != null && eventDate.isAfter(now)) {
      // Programmer une notification pour la date de l'événement
      await scheduleNotification(
        id: id,
        title: 'Événement à venir',
        body: 'L\'événement "$eventName" commence bientôt !',
        scheduledDate: eventDate.subtract(const Duration(hours: 1)),
        payload: 'event',
      );
    }

    // Notification immédiate
    await showNotification(
      id: id + 1,
      title: 'Nouvel événement !',
      body: 'Un nouvel événement "$eventName" a été créé.',
      payload: 'event',
    );
  }

  /// Notifie qu'une nouvelle annonce a été créée
  Future<void> notifyNewAnnonce(String annonceName) async {
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: 'Nouvelle annonce !',
      body: 'Une nouvelle annonce "$annonceName" a été publiée.',
      payload: 'annonce',
    );
  }

  /// Notifie qu'un nouveau cours a été ajouté
  Future<void> notifyNewCours(String coursName, DateTime? coursDate) async {
    final now = DateTime.now();
    final id = now.millisecondsSinceEpoch.remainder(100000);

    if (coursDate != null && coursDate.isAfter(now)) {
      // Programmer une notification pour la date du cours
      await scheduleNotification(
        id: id,
        title: 'Cours à venir',
        body: 'Le cours "$coursName" commence bientôt !',
        scheduledDate: coursDate.subtract(const Duration(minutes: 30)),
        payload: 'cours',
      );
    }

    // Notification immédiate
    await showNotification(
      id: id + 1,
      title: 'Nouveau cours ajouté !',
      body: 'Un nouveau cours "$coursName" a été ajouté au calendrier.',
      payload: 'cours',
    );
  }
}

