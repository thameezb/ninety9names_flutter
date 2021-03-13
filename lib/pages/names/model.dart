class Name {
  final String id;
  final String arabic;
  final String transliteration;
  final String meaningShaykh;
  final String meaningGeneral;
  final String explanation;

  Name(this.id, this.arabic, this.transliteration, this.meaningShaykh,
      this.meaningGeneral, this.explanation);

  Name.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        arabic = json["arabic"],
        transliteration = json["transliteration"],
        meaningShaykh = json["meaning_shaykh"],
        meaningGeneral = json["meaning_general"],
        explanation = json["explanation"];
}