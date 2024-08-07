import 'package:flutter/material.dart';

class NotificationDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onClose;
  final VoidCallback? onUpdate;

  const NotificationDialog({
    Key? key,
    required this.title,
    required this.content,
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
                const SizedBox(height: 16),
                Flexible(
                  child: SingleChildScrollView(
                    child: Text(
                      content,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
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
void showNotificationDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierColor: Colors.transparent,
    builder: (BuildContext context) {
      return NotificationDialog(
        title: 'お知らせ',
        content: 'これは新しいお知らせです。アプリの新機能が利用可能になりました！',
        onClose: () => Navigator.of(context).pop(),
        onUpdate: () {
          // アップデート処理をここに記述
          print('アップデートボタンが押されました');
          Navigator.of(context).pop();
        },
      );
    },
  );
}