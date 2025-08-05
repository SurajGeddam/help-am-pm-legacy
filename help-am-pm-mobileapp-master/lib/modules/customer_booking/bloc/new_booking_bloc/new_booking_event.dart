import '../../../onboarding/model/category_model/api/category_model.dart';
import '../../model/new_booking_req_body_model.dart';

abstract class NewBookingEvent {}

class NewBookingValidationEvent extends NewBookingEvent {
  final String textController;
  final Timeslots? timeslots;

  NewBookingValidationEvent({
    required this.textController,
    this.timeslots,
  });
}

class NewBookingSubmittedEvent extends NewBookingEvent {
  final NewBookingReqBodyModel sendObj;

  NewBookingSubmittedEvent({required this.sendObj});
}
