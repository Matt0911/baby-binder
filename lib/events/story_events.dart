import 'package:baby_binder/events/diaper_event.dart';
import 'package:baby_binder/events/feeding/feeding_event.dart';
import 'package:baby_binder/events/sleep_events.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'add_event_dialog.dart';

const kDiaperEventKey = 'diaper';
const kStartedSleepingEventKey = 'started_sleeping';
const kEndedSleepingEventKey = 'ended_sleeping';
const kFeedingEventKey = 'feeding';

enum EventType {
  diaper,
  started_sleeping,
  ended_sleeping,
  feeding,
}

extension Event on EventType {
  String get type {
    switch (this) {
      case EventType.diaper:
        return kDiaperEventKey;
      case EventType.started_sleeping:
        return kStartedSleepingEventKey;
      case EventType.ended_sleeping:
        return kEndedSleepingEventKey;
      case EventType.feeding:
        return kFeedingEventKey;
      default:
        return '';
    }
  }

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

final DateFormat _formatter = DateFormat('MMM dd hh:mm a');

abstract class StoryEvent {
  final EventType eventType;
  final DateTime eventTime;
  final String description;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final bool requiresDialog;
  Widget Function(BuildContext context)? buildAddDialog;

  StoryEvent(this.eventType, this.eventTime, this.description, this.icon,
      this.iconColor, this.backgroundColor, this.requiresDialog);

  String? _id;
  String? get id => _id;
  String getFormattedTime() => _formatter.format(eventTime.toLocal());
  DateTime getLocalTime() => eventTime.toLocal();
  Map<String, dynamic> convertToMap() => {
        'type': eventType.type,
        'time': eventTime,
      };
}

StoryEvent populateEvent(Map<String, dynamic> data) {
  switch (data['type']) {
    case kDiaperEventKey:
      return DiaperEvent();
    case kStartedSleepingEventKey:
      return StartSleepEvent.fromData(data);
    case kEndedSleepingEventKey:
      return EndSleepEvent();
    case kFeedingEventKey:
      return FeedingEvent();
    default:
      throw Exception('Invalid event type');
  }
}

final Widget Function(Function? onSave) emptyBuilder =
    (onSave) => SizedBox.shrink();
