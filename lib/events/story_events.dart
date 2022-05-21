import 'package:baby_binder/events/diaper_event.dart';
import 'package:baby_binder/events/feeding/feeding_event.dart';
import 'package:baby_binder/events/sleep_events.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  String get title {
    switch (this) {
      case EventType.diaper:
        return 'Diaper';
      case EventType.started_sleeping:
        return 'Start Sleep';
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
  DateTime eventTime;
  Widget Function(BuildContext context, {bool isEdit})? buildDialog;

  StoryEvent(
      {required this.eventType,
      required this.eventTime,
      this.buildDialog,
      this.id});

  String? id;
  String getFormattedTime() => _formatter.format(eventTime.toLocal());
  DateTime getLocalTime() => eventTime.toLocal();
  void updateDate(DateTime? date) {
    if (date != null) {
      eventTime = date;
    }
  }

  String getTimelineDescription();

  Map<String, dynamic> convertToMap() => {
        'type': eventType.type,
        'time': eventTime,
      };
}

DateTime castDate(dynamic x) {
  try {
    return (x as DateTime);
  } on TypeError catch (e) {
    print('TypeError when trying to cast $x as DateTime, trying Timestamp');
    return (x as Timestamp).toDate();
  }
}

StoryEvent createEventFromData(Map<String, dynamic> data, String? id) {
  switch (data['type']) {
    case kDiaperEventKey:
      return DiaperEvent.fromData(data, id);
    case kStartedSleepingEventKey:
      return StartSleepEvent.fromData(data, id);
    case kEndedSleepingEventKey:
      return EndSleepEvent.fromData(data, id);
    case kFeedingEventKey:
      return FeedingEvent.fromData(data, id);
    default:
      throw Exception('Invalid event type');
  }
}

StoryEvent cloneEvent(StoryEvent event) {
  return createEventFromData(event.convertToMap(), event.id);
}

StoryEvent createEventFromType(EventType type) {
  switch (type) {
    case EventType.diaper:
      return DiaperEvent();
    case EventType.started_sleeping:
      return StartSleepEvent();
    case EventType.ended_sleeping:
      return EndSleepEvent();
    case EventType.feeding:
      return FeedingEvent();
    default:
      throw Exception('Invalid event type');
  }
}

final Widget Function(Function? onSave) emptyBuilder =
    (onSave) => SizedBox.shrink();
