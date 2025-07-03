class Ball8State {
  Ball8State({
    String? luckyMessage,
    int randomNumber = 1,
  }) {
    this.luckyMessage = luckyMessage;
    this.randomNumber = randomNumber;
  }

  String? luckyMessage;
  int randomNumber = 1;

  Ball8State copyWith({String? luckyMessage, int randomNumber = 1}) {
    return Ball8State(
        luckyMessage: luckyMessage ?? "", randomNumber: randomNumber);
  }
}
