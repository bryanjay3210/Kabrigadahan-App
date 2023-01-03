class GetUnremittedDonationsCurrentUserParams{
  final String? header;
  final List<String>? checkStatusOfExistingDonationIds;
  final int? skipCount;

  GetUnremittedDonationsCurrentUserParams({this.header,this.checkStatusOfExistingDonationIds, this.skipCount});
}