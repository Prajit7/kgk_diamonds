class Diamond {
  final String lotId;
  final double size;
  final double carat;
  final String lab;
  final String shape;
  final String color;
  final String clarity;
  final String cut;
  final String polish;
  final String symmetry;
  final String fluorescence;
  final double discount;
  final double perCaratRate;
  final double finalAmount;
  final String keyToSymbol;
  final String labComment;

  Diamond({
    required this.lotId,
    required this.size,
    required this.carat,
    required this.lab,
    required this.shape,
    required this.color,
    required this.clarity,
    required this.cut,
    required this.polish,
    required this.symmetry,
    required this.fluorescence,
    required this.discount,
    required this.perCaratRate,
    required this.finalAmount,
    required this.keyToSymbol,
    required this.labComment,
  });

  // Used to decode from app storage or local map
  factory Diamond.fromMap(Map<String, dynamic> map) {
    return Diamond(
      lotId: map['lotId'],
      size: (map['size'] as num).toDouble(),
      carat: (map['carat'] as num).toDouble(),
      lab: map['lab'],
      shape: map['shape'],
      color: map['color'],
      clarity: map['clarity'],
      cut: map['cut'],
      polish: map['polish'],
      symmetry: map['symmetry'],
      fluorescence: map['fluorescence'],
      discount: (map['discount'] as num).toDouble(),
      perCaratRate: (map['perCaratRate'] as num).toDouble(),
      finalAmount: (map['finalAmount'] as num).toDouble(),
      keyToSymbol: map['keyToSymbol'],
      labComment: map['labComment'],
    );
  }

  // Used to encode to shared_preferences or local store
  Map<String, dynamic> toMap() {
    return {
      'lotId': lotId,
      'size': size,
      'carat': carat,
      'lab': lab,
      'shape': shape,
      'color': color,
      'clarity': clarity,
      'cut': cut,
      'polish': polish,
      'symmetry': symmetry,
      'fluorescence': fluorescence,
      'discount': discount,
      'perCaratRate': perCaratRate,
      'finalAmount': finalAmount,
      'keyToSymbol': keyToSymbol,
      'labComment': labComment,
    };
  }
}
