import 'package:flutter/material.dart';
import 'package:helpampm/utils/app_utils.dart';
import '../../../../core_components/common_widgets/app_image_note_dialog.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_text_styles.dart';
import '../../model/api/new_order_list_model.dart';

class NoteImageWidget extends StatelessWidget {
  final Quotes scheduleOrder;

  const NoteImageWidget({
    super.key,
    required this.scheduleOrder,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await showDialog(
          context: context,
          barrierDismissible: false,
          useSafeArea: false,
          builder: (_) => AppImageNoteDialog(quotes: scheduleOrder),
        );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(
            top: 5.sh, left: 10.sh, right: 10.sh, bottom: 10.sh),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            scheduleOrder.imagePath.isNotEmpty
                ? Container(
                    height: 68.sh,
                    width: 68.sw,
                    margin: EdgeInsets.only(left: 0.sw, right: 14.sw),
                    alignment: Alignment.center,
                    child: Image.memory(
                      AppUtils.convertImage(scheduleOrder.imagePath),
                      fit: BoxFit.contain,
                      height: 68.sh,
                      width: 68.sw,
                    ),
                  )
                : const Offstage(),
            Expanded(
              child: Text(
                scheduleOrder.serviceDescription,
                style: AppTextStyles.defaultTextStyle.copyWith(
                  fontSize: 12.fs,
                  fontWeight: FontWeight.w300,
                  color: AppColors.black,
                ),
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
