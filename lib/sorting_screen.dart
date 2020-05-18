import 'package:algov/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:algov/constants.dart';
import 'dart:math';

class sortingScreen extends StatefulWidget {
  @override
  _sortingScreenState createState() => _sortingScreenState();
}

class _sortingScreenState extends State<sortingScreen> {
  var theList = List();
  var currentIndex = List();
  double sliderValue = 10.0;
  String labelText = 'Start Sorting';
  int setSpeed = 300;
  bool isSortingON = false;
  bool isCanceled = false;
  static const itemMenu = <String>[
    'Bubble Sort',
    'Insertion Sort',
    'Selection Sort',
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
        title: Text('Sorting Algorithms'),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: isSortingON
                    ? null
                    : () => showModalBottomSheet(
                        context: context,
                        builder: (context) => buildBottomSheet(context)),
                child: Icon(
                  Icons.settings,
                  size: 23.0,
                  color: isSortingON ? disabledColor : Colors.white,
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
                    color: enabledColor,
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
                onPressed: isSortingON
                    ? null
                    : () {
                        shuffle(value: sliderValue);
                      },
                icon: Icon(Icons.refresh, color: Colors.white),
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
                onPressed: isSortingON
                    ? () {
                        setState(() {
                          isSortingON = false;
                        });
                      }
                    : () {
                        setState(() {
                          isSortingON = true;
                        });
                        startSorting();
                      },
                icon: isSortingON
                    ? Icon(Icons.cancel, color: Colors.white)
                    : Icon(Icons.sort, color: Colors.white),
                label: Text(
                  isSortingON ? 'Cancel' : 'Sort',
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
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

  void startSorting() {
    switch (selectedAlgorithm) {
      case 'Bubble Sort':
        BubbleSort();
        break;

      case 'Insertion Sort':
        insertionSort();
        break;
      case 'Selection Sort':
        selectionSort();
        break;
    }
  }

  void endSorting() {
    setState(() {
      currentIndex.clear();
      isSortingON = false;
    });
  }

  void setCurrentIndex(List<int> currentIndexes) {
    setState(() {
      currentIndex = currentIndexes;
    });
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
            barColor:
                currentIndex.contains(i) ? Colors.green : Colors.blue[400]);
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

  void BubbleSort() async {
    int i, step;
    int n = theList.length;
    for (step = 0; step < n; step++) {
      if (!isSortingON) {
        break;
      }
      for (i = 0; i < n - step - 1; i++) {
        if (!isSortingON) {
          break;
        }
        setCurrentIndex([i, i + 1]);
        updateLabelText('Is ${theList[i]} Greater than ${theList[i + 1]} ?');
        await Future.delayed(Duration(milliseconds: setSpeed));
        if (theList[i] > theList[i + 1]) {
          setState(() {
            swap(theList, i, i + 1);
            updateLabelText('Yes, so swapping.');
          });
        } else {
          updateLabelText('No, so NO swapping.');
        }
        await Future.delayed(Duration(milliseconds: setSpeed));
      }
    }
    if (isSortingON) {
      updateLabelText('the List is Sorted!');
    } else {
      updateLabelText('Canceled');
    }
    endSorting();
  }

  //SelectionSort
  void selectionSort() async {
    int n = theList.length;
    for (int i = 0; i < n - 1; i++) {
      if (!isSortingON) {
        break;
      }
      int minIdx = i;
      updateLabelText('Finding minimum');
      for (int j = i + 1; j < n; j++) {
        if (!isSortingON) {
          break;
        }
        setCurrentIndex([i, j]);
        await Future.delayed(Duration(milliseconds: setSpeed));
        if (theList[j] < theList[minIdx]) minIdx = j;
      }

      setCurrentIndex([minIdx, i]);
      updateLabelText(
          'Swapping minimum element ${theList[minIdx]} and ${theList[i]}');
      await Future.delayed(Duration(milliseconds: setSpeed));
      swap(theList, minIdx, i);
    }
    if (isSortingON) {
      updateLabelText('the List is Sorted!');
    } else {
      updateLabelText('Canceled');
    }
    endSorting();
  }

//  Insertion Sort
  void insertionSort() async {
    int n = theList.length;
    int i, key, j;
    setCurrentIndex([0]);
    updateLabelText('Suppose first element is already sorted');
    await Future.delayed(Duration(milliseconds: setSpeed));
    for (i = 1; i < n; i++) {
      if (!isSortingON) {
        break;
      }
      setCurrentIndex([i]);
      updateLabelText('Taking ${theList[i]} as key element.');
      await Future.delayed(Duration(milliseconds: setSpeed));
      key = theList[i];
      j = i - 1;

      while (j >= 0 && theList[j] > key) {
        setCurrentIndex([theList.indexOf(key), j]);
        updateLabelText(
            'Since $key < ${theList[j]} so, inserting it one place before.');
        await Future.delayed(Duration(milliseconds: setSpeed));

        swap(theList, j + 1, j);
        setCurrentIndex([theList.indexOf(key)]);
        await Future.delayed(Duration(milliseconds: setSpeed));
        j = j - 1;
      }
      theList[j + 1] = key;
    }
    if (isSortingON) {
      updateLabelText('the List is Sorted!');
    } else {
      updateLabelText('Canceled');
    }
    endSorting();
  }
}
