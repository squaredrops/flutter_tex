import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tex/flutter_tex.dart';

class Quiz {
  final String statement;
  final List<QuizOption> options;
  final String correctOptionId;

  Quiz({this.statement, this.options, this.correctOptionId});
}

class QuizOption {
  final String id;
  final String option;

  QuizOption(this.id, this.option);
}

class TeXViewQuizExample extends StatefulWidget {
  final TeXViewRenderingEngine renderingEngine;

  TeXViewQuizExample(
      {this.renderingEngine = const TeXViewRenderingEngine.katex()});

  @override
  _TeXViewQuizExampleState createState() => _TeXViewQuizExampleState();
}

class _TeXViewQuizExampleState extends State<TeXViewQuizExample> {
  int currentQuizIndex = 0;
  String selectedOptionId;
  bool isWrong = false;

  List<Quiz> quizList = [
    Quiz(
      statement: r"""<h3>What is the correct form of quadratic formula?</h3>""",
      options: [
        QuizOption(
          "id_1",
          r""" <h2>(A)   \(x = {-b \pm \sqrt{b^2+4ac} \over 2a}\)</h2>""",
        ),
        QuizOption(
          "id_2",
          r""" <h2>(B)   \(x = {b \pm \sqrt{b^2-4ac} \over 2a}\)</h2>""",
        ),
        QuizOption(
          "id_3",
          r""" <h2>(C)   \(x = {-b \pm \sqrt{b^2-4ac} \over 2a}\)</h2>""",
        ),
        QuizOption(
          "id_4",
          r""" <h2>(D)   \(x = {-b + \sqrt{b^2+4ac} \over 2a}\)</h2>""",
        ),
      ],
      correctOptionId: "id_3",
    ),
    Quiz(
      statement:
          r"""<h3>Choose the correct mathematical form of Bohr's Radius.</h3>""",
      options: [
        QuizOption(
          "id_1",
          r""" <h2>(A)   \( a_0 = \frac{{\hbar ^2 }}{{m_e ke^2 }} \)</h2>""",
        ),
        QuizOption(
          "id_2",
          r""" <h2>(B)   \( a_0 = \frac{{\hbar ^2 }}{{m_e ke^3 }} \)</h2>""",
        ),
        QuizOption(
          "id_3",
          r""" <h2>(C)   \( a_0 = \frac{{\hbar ^3 }}{{m_e ke^2 }} \)</h2>""",
        ),
        QuizOption(
          "id_4",
          r""" <h2>(D)   \( a_0 = \frac{{\hbar }}{{m_e ke^2 }} \)</h2>""",
        ),
      ],
      correctOptionId: "id_1",
    ),
    Quiz(
      statement: r"""<h3>Select the correct Chemical Balanced Equation.</h3>""",
      options: [
        QuizOption(
          "id_1",
          r""" <h2>(A)   \( \ce{CO + C -> 2 CO} \)</h2>""",
        ),
        QuizOption(
          "id_2",
          r""" <h2>(B)   \( \ce{CO2 + C ->  CO} \)</h2>""",
        ),
        QuizOption(
          "id_3",
          r""" <h2>(C)   \( \ce{CO + C ->  CO} \)</h2>""",
        ),
        QuizOption(
          "id_4",
          r""" <h2>(D)   \( \ce{CO2 + C -> 2 CO} \)</h2>""",
        ),
      ],
      correctOptionId: "id_4",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("TeXView Quiz"),
      ),
      body: ListView(
        physics: ScrollPhysics(),
        children: <Widget>[
          Text(
            'Quiz ${currentQuizIndex + 1}/${quizList.length}',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          TeXView(
            renderingEngine: widget.renderingEngine,
            child: TeXViewColumn(children: [
              TeXViewDocument(quizList[currentQuizIndex].statement,
                  style: TeXViewStyle(textAlign: TeXViewTextAlign.Center)),
              TeXViewGroupRadio(
                  children: quizList[currentQuizIndex]
                      .options
                      .map((QuizOption option) {
                    return TeXViewGroupRadioItem(
                        rippleEffect: false,
                        initiallySelected: false,
                        id: option.id,
                        child: TeXViewDocument(option.option,
                            style:
                                TeXViewStyle(padding: TeXViewPadding.all(10))));
                  }).toList(),
                  selectedItemStyle:
                      TeXViewStyle(margin: TeXViewMargin.all(10)),
                  normalItemStyle: TeXViewStyle(margin: TeXViewMargin.all(10)),
                  onTap: (id) {
                    this.selectedOptionId = id;
                    setState(() {
                      isWrong = false;
                    });
                  })
            ]),
            style: TeXViewStyle(
              margin: TeXViewMargin.all(5),
              padding: TeXViewPadding.all(10),
              borderRadius: TeXViewBorderRadius.all(10),
              border: TeXViewBorder.all(
                TeXViewBorderDecoration(
                    borderColor: Colors.blue,
                    borderStyle: TeXViewBorderStyle.Solid,
                    borderWidth: 5),
              ),
              backgroundColor: Colors.white,
            ),
          ),
          TextFormField(
                      keyboardType: TextInputType.multiline,
                      minLines: 5,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Description',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      )),
          if (isWrong)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                "Wrong answer!!! Please choose a correct option.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (currentQuizIndex > 0) {
                      selectedOptionId = null;
                      currentQuizIndex--;
                    }
                  });
                },
                child: Text("Previous"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (selectedOptionId ==
                        quizList[currentQuizIndex].correctOptionId) {
                      selectedOptionId = null;
                      if (currentQuizIndex != quizList.length - 1)
                        currentQuizIndex++;
                    } else {
                      isWrong = true;
                    }
                  });
                },
                child: Text("Next"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
