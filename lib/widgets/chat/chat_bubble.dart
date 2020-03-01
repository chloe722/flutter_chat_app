import 'package:cached_network_image/cached_network_image.dart';
import 'package:flash_chat/model/message.dart';
import 'package:flash_chat/model/user.dart';
import 'package:flash_chat/widgets/translation_bottom_sheet.dart';
import 'package:flutter/material.dart';

import '../../strings.dart';

class ChatBubble extends StatefulWidget {
  ChatBubble({this.user, this.isMe, this.message, this.isLatestMsg});

  final User user;
  final bool isMe;
  final Message message;
  final bool isLatestMsg;

  @override
  _ChatBubbleState createState() => _ChatBubbleState();

  /// Equality check in order for Flutter to compare if two objects are the same, if not it will rebuild

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ChatBubble &&
              runtimeType == other.runtimeType &&
              message == other.message &&
              isLatestMsg == other.isLatestMsg;

  @override
  int get hashCode =>
      message.hashCode ^
      isLatestMsg.hashCode;

}

class _ChatBubbleState extends State<ChatBubble>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    _animationController =
        AnimationController(duration: Duration(seconds: 2), vsync: this);

    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(1.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    super.initState();
  }

  @override
  void didUpdateWidget(ChatBubble oldWidget) {
    if (widget.isLatestMsg ){
      _animationController.reverse(from: 0.3);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildText(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Material(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(widget.isMe ? 0.0 : 30.0),
                  topLeft: Radius.circular(widget.isMe ? 30.0 : 0.0),
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0)),
              elevation: 1.0,
              color: widget.isMe ? Colors.amber[300] : Colors.grey[100],
              child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    widget.message.content ?? "",
                    softWrap: true,
                    maxLines: 10,
                  )),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: InkWell(
                onTap: () async {
                  showModalBottomSheet(
                      context: context,
                      isDismissible: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      ),
                      builder: (context) =>
                          TranslationBottomSheet(text: widget.message.content));
                },
                child: Icon(
                  Icons.translate,
                  color: Colors.white,
                  size: 20.0,
                ),
                splashColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _builtImage() {
    return CachedNetworkImage(
        placeholder: (context, url) => Container(
            height: 100.0,
            width: 100.0,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Center(child: CircularProgressIndicator())),
        errorWidget: (context, url, error) => Material(
              child: Text("Image is not available"),
              borderRadius: BorderRadius.circular(10.0),
            ),
        width: 200.0,
        height: 200.0,
        fit: BoxFit.cover,
        imageUrl: widget.message.content ?? "");
  }

  Widget _builtSticker() {
    //TODO
  }

  Widget _buildAvatar() {
    return Padding(
      padding: EdgeInsets.only(
          right: widget.isMe ? 0.0 : 8.0, left: widget.isMe ? 8.0 : 0.0),
      child: CircleAvatar(
          backgroundImage: widget.user.photoUrl.isEmpty
              ? AssetImage(kPlaceholderImage)
              : CachedNetworkImageProvider(widget.user.photoUrl)),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget _chatBubble = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment:
            widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          if (widget.isMe == false) _buildAvatar(),
          if (widget.message.type == 0) _buildText(context),
          if (widget.message.type == 1) _builtImage(),
          if (widget.message.type == 2) _builtSticker(),
          if (widget.isMe == true) _buildAvatar(),
        ],
      ),
    );

    if (widget.isLatestMsg) {
      return SlideTransition(
        position: _offsetAnimation,
        textDirection: widget.isMe ? TextDirection.ltr : TextDirection.rtl,
        child: _chatBubble,
      );
    } else {
      return _chatBubble;
    }
  }
}
