class TokenModel {
  final String passId;
  final int issuedAt;
  final int expiresAt;
  final String nonce;
  final String scope;
  final String signature;

  TokenModel({
    required this.passId,
    required this.issuedAt,
    required this.expiresAt,
    required this.nonce,
    required this.scope,
    required this.signature,
  });

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      passId: json['passId'] as String,
      issuedAt: json['issuedAt'] as int,
      expiresAt: json['expiresAt'] as int,
      nonce: json['nonce'] as String,
      scope: json['scope'] as String,
      signature: json['signature'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'passId': passId,
      'issuedAt': issuedAt,
      'expiresAt': expiresAt,
      'nonce': nonce,
      'scope': scope,
      'signature': signature,
    };
  }
}
