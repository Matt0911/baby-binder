import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum EventType {
  diaper,
  started_sleeping,
  ended_sleeping,
  feeding,
}

extension Event on EventType {
  String get description {
    switch (this) {
      case EventType.diaper:
        return 'Diaper';
      case EventType.started_sleeping:
        return 'Started sleeping';
      case EventType.ended_sleeping:
        return 'Woke up';
      case EventType.feeding:
        return 'Ate';
      default:
        return '';
    }
  }

  Color get iconColor {
    switch (this) {
      case EventType.diaper:
        return Colors.red;
      case EventType.started_sleeping:
        return Colors.green;
      case EventType.ended_sleeping:
        return Colors.green;
      case EventType.feeding:
        return Colors.orange;
      default:
        return Colors.transparent;
    }
  }

  Color get backgroundColor {
    switch (this) {
      case EventType.diaper:
        return Colors.red.shade50;
      case EventType.started_sleeping:
        return Colors.green.shade50;
      case EventType.ended_sleeping:
        return Colors.green.shade50;
      case EventType.feeding:
        return Colors.orange.shade50;
      default:
        return Colors.transparent;
    }
  }

  IconData get icon {
    switch (this) {
      case EventType.diaper:
        return Icons.baby_changing_station;
      case EventType.started_sleeping:
        return Icons.crib;
      case EventType.ended_sleeping:
        return Icons.crib;
      case EventType.feeding:
        return Icons.restaurant;
      default:
        return Icons.close;
    }
  }
}

class StoryEvent {
  EventType _eventType;
  DateTime _eventTime = DateTime.now();
  final DateFormat formatter = DateFormat('MMM dd hh:mm a');

  StoryEvent(this._eventType);
  StoryEvent.withTime(this._eventType, this._eventTime);

  String getFormattedTime() => formatter.format(_eventTime.toLocal());
  DateTime getLocalTime() => _eventTime.toLocal();
  EventType getEventType() => _eventType;
  String getDescription() => _eventType.description;
}
