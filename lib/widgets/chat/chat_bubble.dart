import 'package:cached_network_image/cached_network_image.dart';
import 'package:flash_chat/constants.dart';
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


  Widget _builtSticker() {
    //TODO
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
          if (widget.isMe == false) BuildAvatar(name: widget.user.name, image: widget.user.photoUrl, isMe: widget.isMe),
          if (widget.message.type == 0) BuildText(text: widget.message.content,isMe: widget.isMe),
          if (widget.message.type == 1) BuildImage(image: widget.message.content),
          if (widget.message.type == 2) _builtSticker(),
          if (widget.isMe == true) BuildAvatar(name: widget.user.name, image: widget.user.photoUrl, isMe: widget.isMe),
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


class BuildText extends StatelessWidget {
  BuildText({this.text, this.isMe});

  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
      return Flexible(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Material(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(isMe ? 0.0 : 30.0),
                    topLeft: Radius.circular(isMe ? 30.0 : 0.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0)),
                elevation: 1.0,
                color: isMe ? kBlurYellow : Colors.grey[100],
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      text ?? "",
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
                            TranslationBottomSheet(text: text));
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
}


class BuildImage extends StatelessWidget {
  BuildImage({this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
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
          imageUrl: image ?? "");
  }
}


class BuildAvatar extends StatelessWidget {
  BuildAvatar({this.name, this.image, this.isMe});

  final String name;
  final String image;
  final bool isMe;


  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
            right: isMe ? 0.0 : 8.0, left: isMe ? 8.0 : 0.0),
        child: CircleAvatar(
            backgroundImage: image.isEmpty
                ? AssetImage(kPlaceholderImage)
                : CachedNetworkImageProvider(image)),
      );
  }
}

