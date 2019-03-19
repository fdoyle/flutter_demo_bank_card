import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_villains/villain.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorObservers: [VillainTransitionObserver()],
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

Random random = Random();

String getRandomCreditCardNumber() {
  int getFourDigits() {
    return random.nextInt(9999);
  }
  return "${getFourDigits()}-${getFourDigits()}-${getFourDigits()}-${getFourDigits()}";
}

String getFakeExpirationDate() {
  return "${random.nextInt(12)}/${random.nextInt(20) + 19}";
}

class User {
  String name;
  List<Card> cards;

  User(this.name, this.cards);
}

class Card {
  String title;
  String backgroundUrl;
  String number;
  String expirationDate;

  Card.fake(this.title, this.backgroundUrl) {
    this.number = getRandomCreditCardNumber();
    this.expirationDate = getFakeExpirationDate();
  }
}

var user = User("Austin Hammond", [
  Card.fake("IAMD Platinum",
      "https://wallpapersmug.com/large/7a22c5/forest_mountains_sunset_cool_weather_minimalism.jpg"),
  Card.fake("IAMD Gold",
      "https://www.oodlesthemes.com/wp-content/uploads/2017/10/OO1122575-blue-abstract-vector-background-design-590x300.jpg"),
  Card.fake("IAMD Silver", "https://i.imgur.com/9od0mSo.jpg"),
  Card.fake("IAMD 4", "https://i.imgur.com/Vdtct7v.jpg"),
  Card.fake("IAMD 5", "https://i.redd.it/8mbwlbjkbuu01.jpg"),
  Card.fake("IAMD 6",
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTR_3uI3jesaHn0LTHprwzwxfFFz20oNQtddsL8-ztc3OEKtbed"),
  Card.fake("IAMD 7",
      "https://mondrian.mashable.com/wp-content%252Fgallery%252F20-beautiful-minimalist-wallpapers-for-a-simpler-desktop%252F06.jpg%252Ffit-in__850x850.jpg?signature=XE-9F-CQChQwSTh3aBFJJ0gTIRs=&source=https%3A%2F%2Fmashable.com"),
  Card.fake("IAMD 8",
      "https://i.pinimg.com/originals/66/15/1d/66151d4bbcda8425a233c69fc6ed3767.jpg"),
  Card.fake("IAMD 9", "https://wallpapercave.com/wp/yvAFPDR.jpg"),
]);

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double currentPage = 0;

  @override
  Widget build(BuildContext context) {
    var controller = PageController();
    controller.addListener(() {
      setState(() {
        currentPage = controller.page;
      });
    });

    return Scaffold(
        backgroundColor: Color(0xFF1D3671),
        body: SafeArea(
            child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      child: Text("Design Bitcoin",
                          style: TextStyle(fontSize: 14))),
                  Icon(Icons.menu)
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: <Widget>[
                  Center(
                      child: Text("PLEASE ADD",
                          style: TextStyle(
                              fontSize: 46,
                              color: Colors.white.withAlpha(10),
                              fontWeight: FontWeight.bold))),
                  Positioned.directional(
                      textDirection: TextDirection.ltr,
                      bottom: 0,
                      start: 0,
                      end: 0,
                      child: Center(
                          child: Text("Credit Card",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)))),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.adjust,
                color: Colors.red,
                size: 24,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("OnePay",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text("Invest in your\nfuture",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withAlpha(150),
                      fontWeight: FontWeight.bold)),
            ),
            Expanded(child: LayoutBuilder(builder: (context, constraints) {
              var cardWidgets = <Widget>[];
              for (int i = 0; i != user.cards.length; i++) {
                var delta = currentPage - i;
                var card = Center(
                    child: Transform.rotate(
                        angle: -delta * pi / 14,
                        origin: Offset(
                            0,
                            min(constraints.maxWidth, constraints.maxHeight) *
                                3),
                        //this ended up looking good on ios and android, but they're just fudged numbers.
                        //you'd have to do some proper math to really make it work
                        child: VerticalCard(user.cards[i])));
                cardWidgets.add(card);
              }

              return Stack(
                children: <Widget>[
                  PageView.builder(
                    //as in some of my other studies, the PageView here is essentially a glorified gestureDetector
                    //that is, I want its touch interactions, and i want it to tell me what page I'm on
                    //but i dont want it to control the rendering of my "pages". There may be a more idiomatic way to do this
                    //if you know of one, please let me know
                      controller: controller,
                      itemCount: user.cards.length,
                      itemBuilder: (context, index) {
                        return Container();
                      }),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Stack(
                          children: cardWidgets,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }))
          ],
        )));
  }
}

const double CARD_ASPECT_RATIO = 1.586; // default aspect ratio for cards

class VerticalCard extends StatelessWidget {
  final Card card;

  VerticalCard(this.card);

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        IgnorePointer(
          //ensure this doesn't intercept touch events
          //only the gesture detector below should catch touches
          //and it is set to allow touches to pass through
          //so that the PageView below these can also receive those same touch events
          child: Center(
            child: AspectRatio(
              aspectRatio: CARD_ASPECT_RATIO,
              child: Hero(
                tag: "image${card.title}",
                child: Transform.rotate(
                  angle: pi / 2,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image.network(
                        card.backgroundUrl,
                        fit: BoxFit.cover,
                      )),
                ),
              ),
            ),
          ),
        ),
        IgnorePointer(
          //ensure this doesn't intercept touch events
          child: Center(
            child: Hero(
              tag: "title${card.title}",
              child: Text(
                card.title,
                style: TextStyle(
                    fontFamily: "Roboto",
                    fontSize: 26,
                    shadows: [
                      Shadow(
                          blurRadius: 5.0,
                          color: Colors.black87,
                          offset: Offset.zero)
                    ],
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        Center(
          child: GestureDetector(
            //this should be the only widget in this stack listening for touch events
            behavior: HitTestBehavior.translucent, //this flag allows the gesture detector to both receive touch events AND pass them on to widgets behind it
            //this means that this widget can receive tap events, but the pageview below can handle swipes at the same time
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CardDetail(card)),
              );
            },
            child: IgnorePointer(
              //this shouldn't intercept touch events either
              //if we don't have this, this view will block touch events.
              //Even though the above gestureDetector is set to transluscent,
              //this view would otherwise still block events from reaching the PageView
              child: AspectRatio(
                //this is a vertical container of the same size as the above rotated image used for hit detection
                // GestureDetectors don't play well with rotations for some reason
                aspectRatio: 1 / CARD_ASPECT_RATIO,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Container()),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class CardDetail extends StatelessWidget {
  final Card card;

  CardDetail(this.card);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1D3671),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(child: HorizontalCard(card)),
      ),
    );
  }
}

class HorizontalCard extends StatelessWidget {
  final Card card;

  HorizontalCard(this.card);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: CARD_ASPECT_RATIO,
          child: Hero(
            flightShuttleBuilder: (
              BuildContext flightContext,
              Animation<double> animation,
              HeroFlightDirection flightDirection,
              BuildContext fromHeroContext,
              BuildContext toHeroContext,
            ) {
              final Hero toHero = toHeroContext.widget;

              return RotationTransition(
                turns: animation,
                child: toHero.child,
                reverse: flightDirection == HeroFlightDirection.push,
              );
            },
            tag: "image${card.title}",
            child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.network(
                  card.backgroundUrl,
                  fit: BoxFit.cover,
                )),
          ),
        ),
        Positioned.fill(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Hero(
                    tag: "title${card.title}",
                    flightShuttleBuilder: (
                      BuildContext flightContext,
                      Animation<double> animation,
                      HeroFlightDirection flightDirection,
                      BuildContext fromHeroContext,
                      BuildContext toHeroContext,
                    ) {
                      final Hero toHero = toHeroContext.widget;
                      return new Material(
                        //this is extremely important.
                        //text in heros isn't a child of your normal hierarchy, which means it doesn't get styling information
                        //without this, your hero shuttle (the text that flies across during the animation)
                        //will not have style/theme data, and will render differently. This not only looks bad
                        //but will cause display errors (you'll get the nasty red text with double underlines and other errors)
                          color: Colors.transparent, child: toHero);
                    },
                    child: Text(
                      card.title,
                      style: TextStyle(
                          fontSize: 26,
                          fontFamily: "Roboto",
                          shadows: [
                            Shadow(
                                blurRadius: 5.0,
                                color: Colors.black87,
                                offset: Offset.zero)
                          ],
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: CardContentAppearAnimation(//this custom widget controls how widgets should appear
                      child: Text(
                        card.number,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          shadows: [
                            Shadow(
                                blurRadius: 2.0,
                                color: Colors.black87,
                                offset: Offset.zero)
                          ],
                          fontSize: 18,
                          letterSpacing: 1.5,
                          fontFamily: "monospace",
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: CardContentAppearAnimation(
                      delayIndex: 1, //as defined in the CardContentAppearAnimation widget, this value defines how the animations should be staggered
                      child: Text(
                          user.name,
                          textAlign: TextAlign.left,
                          style: TextStyle(shadows: [
                            Shadow(
                                blurRadius: 2.0,
                                color: Colors.black87,
                                offset: Offset.zero)
                          ], fontSize: 18),
                        ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: CardContentAppearAnimation(
                      delayIndex: 2,
                      child:Text(
                        card.expirationDate,
                        textAlign: TextAlign.left,
                        style: TextStyle(shadows: [
                          Shadow(
                              blurRadius: 2.0,
                              color: Colors.black87,
                              offset: Offset.zero)
                        ], fontSize: 18),
                      ),
                    ),
                  ),
                ]),
          ),
        ),
      ],
    );
  }
}


/*
* This animation is tricky.
*
* Hero animations work by creating a copy of the heros child, then floating that
* widget overtop your UI into the place where its supposed to end up
* Problem is, one of our hero images is a background (the card image), and ideally it would stay "below" its content
* Hero animations don't support that, so we have to cheat
*
* The strategy here is to simply make the card contents invisible until the hero has "settled" (returned to its normal z order position)
* then animate in the text contents of the card
*
* note the use of composition here. Most of the parameters passed to the
* villain widget are shared, so why not wrap that in a new widget and use that everywhere?
* On android, Views are heavy, so you might not want to do this, but in flutter, as I understand it, this is encouraged
* */
class CardContentAppearAnimation extends StatelessWidget {
  Widget child;
  int delayIndex;

  int BASE_DELAY = 400; //wait a little bit longer than the default hero animation duration
  int DURATION = 300; //the duration of this animation
  int DELAY_OFFSET = 140; //the text animations should be staggered. the delayIndex below defines how this is used. 0 comes first, 1 comes after, 2 comes after that, etc


  CardContentAppearAnimation({
    Key key,
    Widget this.child,
    int this.delayIndex = 0
  });

  @override
  Widget build(BuildContext context) {
    return Villain( //The Villain module pairs well with heroes, animating things into place that *aren't* shared between screens
        villainAnimation: VillainAnimation.fromBottom(
          relativeOffset: 0.4,
          from: Duration(milliseconds: BASE_DELAY + DELAY_OFFSET * delayIndex),
          to: Duration(milliseconds: BASE_DELAY + DURATION + DELAY_OFFSET * delayIndex),
        ),
        animateExit: true,
        secondaryVillainAnimation: VillainAnimation.fade(),
        child: child);
  }
}

class RotationTransition extends AnimatedWidget {
  const RotationTransition(
      {Key key,
      @required Animation<double> turns,
      this.alignment = Alignment.center,
      this.child,
      this.reverse})
      : super(key: key, listenable: turns);

  Animation<double> get turns => listenable;
  final Alignment alignment;

  final Widget child;
  final bool reverse;

  @override
  Widget build(BuildContext context) {
    final double turnsValue = turns.value;

    Matrix4 transform;
    if (reverse) { //this animation should rotate CCW on the push, and CW on the pop
      transform = Matrix4.rotationZ((1 - turnsValue) * pi / 2);//not gonna lie, this took a few tries to get right
    } else {
      transform = Matrix4.rotationZ(-(turnsValue) * pi / 2);
    }
    return Transform(
      transform: transform,
      alignment: alignment,
      child: child,
    );
  }
}