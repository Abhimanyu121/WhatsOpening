class TimeModel{
  final BigInt opening_min;
  final BigInt opening_hour;
  final BigInt closing_hour;
  final BigInt closing_min;
  final BigInt upvotes;
  final BigInt downvotes;
  final String address;
  final String hash;
  TimeModel({this.hash, this.opening_min, this.opening_hour, this.closing_hour, this.closing_min, this.upvotes, this.downvotes, this.address});
}