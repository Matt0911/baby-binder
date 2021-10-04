import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'add_event_dialog.dart';

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

abstract class StoryEvent {
  final EventType _eventType;
  final DateTime _eventTime;
  final DateFormat _formatter = DateFormat('MMM dd hh:mm a');
  final String _description;
  final IconData _icon;
  final Color _iconColor;
  final Color _backgroundColor;
  final bool _requiresDialog;
  final Widget Function(Function? onSave) _buildAddDialog;

  StoryEvent(
      this._eventType,
      this._eventTime,
      this._description,
      this._icon,
      this._iconColor,
      this._backgroundColor,
      this._requiresDialog,
      this._buildAddDialog);

  String getFormattedTime() => _formatter.format(_eventTime.toLocal());
  DateTime getLocalTime() => _eventTime.toLocal();
  EventType getEventType() => _eventType;
  String getDescription() => _description;
  IconData getIcon() => _icon;
  Color getIconColor() => _iconColor;
  Color getBackgroundColor() => _backgroundColor;
  bool requiresDialog() => _requiresDialog;
  Widget buildAddDialog() => _buildAddDialog(null);
}

final Widget Function(Function? onSave) emptyBuilder =
    (onSave) => SizedBox.shrink();
