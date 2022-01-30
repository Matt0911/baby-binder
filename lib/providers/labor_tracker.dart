import 'package:baby_binder/providers/children_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

final laborTrackerDataProvider = ChangeNotifierProvider((ref) {
  final activeChild = ref.watch(activeChildProvider);
  return LaborTrackerData(activeChild?.document);
});

class LaborTrackerData extends ChangeNotifier {
  LaborTrackerData(DocumentReference<Map<String, dynamic>>? activeChildDocument)
      : _document = activeChildDocument {
    if (_document != null) {
      _document!.collection('labor').orderBy('time').snapshots().listen(
            (snapshot) => snapshot.docChanges.forEach(
              (docChange) {
                if (docChange.type == DocumentChangeType.added) {
                  contractions.insert(
                      0,
                      Contraction.fromData(
                          docChange.doc.id, docChange.doc.data() ?? {}));
                } else if (docChange.type == DocumentChangeType.removed) {
                  contractions.removeWhere((c) => c.id == docChange.doc.id);
                }
                notifyListeners();
              },
            ),
          );
    }
  }

  List<Contraction> contractions = [];
  DocumentReference<Map<String, dynamic>>? _document;

  void _addEvent(Contraction c) {
    // _events.insert(0, event);
    if (_document != null) {
      _document!.collection('labor').add(c.convertToMap());
    }
  }

  void addNewContraction(Contraction c) async {
    _addEvent(c);
  }
}

class Contraction {
  Contraction({DateTime? start}) {
    this._start = start ?? DateTime.now();
  }

  Contraction.fromData(String id, Map<String, dynamic> data)
      : _start = (data['time'] as Timestamp).toDate(),
        duration = Duration(seconds: data['durationSeconds']);

  String? id;
  late DateTime _start;
  DateTime get start => _start;
  Duration? duration;

  Map<String, dynamic> convertToMap() => {
        'time': start,
        'durationSeconds': duration!.inSeconds,
      };
}
