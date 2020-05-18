import 'package:algov/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:algov/constants.dart';
import 'dart:math';

class searchingScreen extends StatefulWidget {
  @override
  _searchingScreenState createState() => _searchingScreenState();
}

class _searchingScreenState extends State<searchingScreen> {
  var theList = List();
  var currentIndex = List();
  var checkedIndex = List();
  double sliderValue = 10.0;
  String labelText = 'Start Sorting';
  int setSpeed = 300;
  bool isSearchingON = false;
  static const itemMenu = <String>[
    'Linear Searching',
    'Binary Searching',
  ];
  String selectedAlgorithm = itemMenu[0];
  int arrowIndex = 0;
  @override
  void initState() {
    shuffle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgGroundColor,
      drawer: myDrawer(),
      appBar: AppBar(
        title: Text('Searching Algorithms'),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: isSearchingON
                    ? null
                    : () => showModalBottomSheet(
                        context: context,
                        builder: (context) => buildBottomSheet(context)),
                child: Icon(
                  Icons.settings,
                  size: 23.0,
                  color: isSearchingON ? disabledColor : Colors.white,
                ),
              ))
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: enabledColor,
            ),
            margin: EdgeInsets.all(8.0),
            child: AspectRatio(
              aspectRatio: 1,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: BarChart(
                  BarData(),
                  swapAnimationDuration: Duration(milliseconds: 200),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: enabledColor,
            ),
            height: 90.0,
            margin: EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                labelText,
                style: TextStyle(color: Colors.white, fontSize: 18.0),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                onTap: arrowIndex == 0
                    ? null
                    : () {
                        setState(() {
                          arrowIndex--;
                          selectedAlgorithm = itemMenu[arrowIndex];
                        });
                      },
                child: Icon(
                  Icons.chevron_left,
                  color: arrowIndex == 0 ? disabledColor : Colors.white,
                  size: 30.0,
                ),
              ),
              Container(
                width: 200,
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                    color: Color(0xff91CFE9),
                    borderRadius: BorderRadius.circular(12.0)),
                child: Center(
                  child: Text(
                    selectedAlgorithm,
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              GestureDetector(
                onTap: arrowIndex == itemMenu.length - 1
                    ? null
                    : () {
                        setState(() {
                          arrowIndex++;
                          selectedAlgorithm = itemMenu[arrowIndex];
                        });
                      },
                child: Icon(
                  Icons.chevron_right,
                  color: arrowIndex == itemMenu.length - 1
                      ? disabledColor
                      : Colors.white,
                  size: 30.0,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FlatButton.icon(
                color: enabledColor,
                padding: EdgeInsets.all(18.0),
                onPressed: isSearchingON
                    ? null
                    : () {
                        shuffle(value: sliderValue);
                      },
                icon: Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                disabledColor: disabledColor,
                label: Text(
                  'Shuffle',
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
              FlatButton.icon(
                color: enabledColor,
                padding: EdgeInsets.all(18.0),
                onPressed: isSearchingON
                    ? () {
                        setState(() {
                          isSearchingON = false;
                        });
                      }
                    : () {
                        setState(() {
                          isSearchingON = true;
                        });
                        startSearching();
                      },
                icon: isSearchingON
                    ? Icon(Icons.cancel, color: Colors.white)
                    : Icon(
                        Icons.sort,
                        color: Colors.white,
                      ),
                label: Text(
                  isSearchingON ? 'Cancel' : 'Search',
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  BarChartData BarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        enabled: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          textStyle: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
          margin: 10,
          getTitles: (double value) {
            return theList[value.toInt()].toString();
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: List.generate(sliderValue.toInt(), (i) {
        return makeGroupData(i, theList[i].toDouble() + 6,
            barColor: getBarColor(i));
      }),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    Color barColor = Colors.white,
    double width = 13,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: y,
          color: barColor,
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            color: Colors.blue[200],
            y: 25,
          ),
        )
      ],
    );
  }

  Container buildBottomSheet(BuildContext context) {
    return Container(
      height: 300,
      color: Color(0xff154A62),
      child: Container(
        padding: EdgeInsets.all(18.0),
        decoration: BoxDecoration(
          color: Colors.lightBlueAccent[100],
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18.0), topRight: Radius.circular(12.0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Settings',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.white,
                fontSize: 25.0,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(),
            SizedBox(
              height: 15.0,
            ),
            Text(
              'Array Length',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
            StatefulBuilder(
              builder: (context, setState) {
                return Slider(
                  value: sliderValue,
                  onChanged: (double value) {
                    setState(() {
//                      sliderValue = value;
                      shuffle(value: value);
                    });
                  },
                  label: sliderValue.toString(),
                  min: 8,
                  max: 15,
                  divisions: 7,
                );
              },
            ),
            Text(
              'Speed',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
            StatefulBuilder(
              builder: (context, setState) {
                return Slider(
                  value: setSpeed.toDouble(),
                  onChanged: (double value) {
                    setState(() {
                      updateSpeed(value.toInt());
                    });
                  },
                  label: setSpeed.toString(),
                  min: 200,
                  max: 1000,
                  divisions: 8,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void linearSearch() async {
    int i;
    var rng = new Random();
    int n = theList.length;
    int target = rng.nextInt(sliderValue.toInt()) + 1;
    updateLabelText("Let's search for $target");
    await Future.delayed(Duration(milliseconds: 1500));
    for (i = 0; i < n; i++) {
      if (!isSearchingON) {
        break;
      }
      setCurrentIndex([i]);
      updateLabelText("Is ${theList[i]} Equal to $target ");
      await Future.delayed(Duration(milliseconds: setSpeed));
      if (theList[i] == target) {
        endSearching();
        break;
      } else {
        setCheckedIndex(i);
        updateLabelText("No, so let's move ahead");
      }
      await Future.delayed(Duration(milliseconds: setSpeed));
    }
    if (!isSearchingON) {
      updateLabelText('Search is Complete!');
    } else {
      updateLabelText('Canceled');
    }
    endSearching();
  }

  void binarySearch() async {
    int mid, high, low, i;
    theList.sort();
    var rng = new Random();
    high = theList.length - 1;
    low = 0;
    int target = rng.nextInt(sliderValue.toInt()) + 1;
    updateLabelText("Let's search for $target");
    await Future.delayed(Duration(milliseconds: 1500));
    while (high >= low) {
      if (!isSearchingON) {
        break;
      }
      mid = ((high + low) ~/ 2);
      updateLabelText("is ${theList[mid]} equal to $target ?");
      await Future.delayed(Duration(milliseconds: setSpeed));
      setCurrentIndex([mid]);

      if (theList[mid] == target) {
        endSearching();
        break;
      }
      updateLabelText("No, is ${theList[mid]} < $target ?");
      await Future.delayed(Duration(milliseconds: setSpeed));
      if (theList[mid] < target) {
        for (i = low; i <= mid; i++) {
          setCheckedIndex(i);
        }
        low = mid + 1;
        updateLabelText("yes, so new low is $low");
        await Future.delayed(Duration(milliseconds: setSpeed));
      } else {
        for (i = mid + 1; i <= high; i++) {
          setCheckedIndex(i);
        }
        high = mid;
        updateLabelText("No, so new high is $high");
        await Future.delayed(Duration(milliseconds: setSpeed));
      }
    }
    if (!isSearchingON) {
      updateLabelText('Search is Complete!');
    } else {
      updateLabelText('Canceled');
    }
    endSearching();
  }

  void swap(numbers, i, j) {
    int temp = numbers[i];
    numbers[i] = numbers[j];
    numbers[j] = temp;
  }

  void shuffle({double value = 10.0}) {
    setState(() {
      sliderValue = value;
    });
    updateLabelText('Just shuffled!');
    theList = List.generate(sliderValue.toInt(), (i) => i + 1);
    theList.shuffle();
  }

  void updateLabelText(String text) {
    setState(() {
      labelText = text;
    });
  }

  void updateSpeed(int speed) {
    setState(() {
      setSpeed = speed;
    });
  }

  void startSearching() {
    switch (selectedAlgorithm) {
      case 'Linear Searching':
        linearSearch();
        break;

      case 'Binary Searching':
        binarySearch();
        break;
    }
  }

  void endSearching() {
    setState(() {
      currentIndex.clear();
      checkedIndex.clear();
      isSearchingON = false;
    });
  }

  void setCurrentIndex(List<int> currentIndexes) {
    setState(() {
      currentIndex = currentIndexes;
    });
  }

  Color getBarColor(int i) {
    if (checkedIndex.contains(i)) {
      return Colors.red;
    } else {
      return currentIndex.contains(i) ? Colors.green : Colors.blue[400];
    }
  }

  void setCheckedIndex(int value) {
    setState(() {
      checkedIndex.add(value);
    });
  }
}
