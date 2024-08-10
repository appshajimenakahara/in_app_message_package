import 'package:flutter/material.dart';

class NotificationDialog extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final String content;
  final String? dateString;  // 新しいパラメータ
  final VoidCallback? onClose;
  final VoidCallback? onUpdate;

  const NotificationDialog({
    Key? key,
    required this.title,
    this.imageUrl,
    required this.content,
    this.dateString,  // オプショナルパラメータとして追加
    required this.onClose,
    this.onUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.7),
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        tween: Tween(begin: 1.0, end: 0.0),
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(0, MediaQuery.of(context).size.height * value),
            child: child,
          );
        },
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.9,
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
                if (imageUrl != null) ...[
                  const SizedBox(height: 16),
                  Image.network(
                    imageUrl!,
                    fit: BoxFit.contain,
                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error);
                    },
                  ),
                ],
                const SizedBox(height: 16),
                Flexible(
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Text(
                          content,
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                      if (dateString != null)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Text(
                            dateString!,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (onClose != null)
                      TextButton(
                        onPressed: onClose,
                        child: const Text('閉じる'),
                      ),
                    if (onUpdate != null) ...[
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: onUpdate,
                        child: const Text('アップデート'),
                      ),
                    ],
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

// 使用例
void showNotificationDialog(
    BuildContext context, {
      required String title,
      String? imageUrl,
      required String content,
      String? dateString,  // 新しいパラメータ
      required bool isForceUpdate,
      required VoidCallback? updateAction,
    }) {
  showDialog(
    context: context,
    barrierColor: Colors.transparent,
    builder: (BuildContext context) {
      return NotificationDialog(
        title: title,
        imageUrl: imageUrl,
        content: content,
        dateString: dateString,  // 日付文字列を渡す
        onClose: isForceUpdate ? null : () => Navigator.of(context).pop(),
        onUpdate: updateAction == null
            ? null
            : () {
          updateAction();
          Navigator.of(context).pop();
        },
      );
    },
  );
}