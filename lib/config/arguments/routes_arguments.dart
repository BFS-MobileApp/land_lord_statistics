class RoutesArgument{}


class StatisticDetailsRoutesArguments extends RoutesArgument{

  final String uniqueId;
  final String companyName;
  final String buildingName;
  String date;

  StatisticDetailsRoutesArguments({required this.uniqueId , required this.companyName , required this.buildingName , required this.date});

}

class LoginRoutesArguments extends RoutesArgument{
  final bool addOtherMail;
  LoginRoutesArguments({required this.addOtherMail});
}