class OverlayPoliticianTrade {
  final String name;
  final String date;
  final String size;
  final String polTicker;
  final String? image;
  final bool isBuy;

  const OverlayPoliticianTrade({
    required this.name,
    required this.date,
    required this.size,
    required this.polTicker,
    this.image,
    required this.isBuy,
  });
}

class OverlayArkTrade {
  final String etf;
  final String date;
  final String direction;
  final int shares;

  const OverlayArkTrade({
    required this.etf,
    required this.date,
    required this.direction,
    required this.shares,
  });
}

class OverlayMotleyData {
  final String dir; // 'Long' or 'Short'
  final dynamic heldBy;
  final dynamic rank;

  const OverlayMotleyData({
    required this.dir,
    this.heldBy,
    this.rank,
  });
}

class OverlayItem {
  final String ticker;
  final String companyName;
  final String direction; // 'Buy' or 'Sell'
  final int arkNet;
  final int polBuys;
  final int polSells;
  final int uniquePols;
  final bool isAligned;
  final List<OverlayPoliticianTrade> polDetails;
  final List<OverlayArkTrade> arkDetails;
  final OverlayMotleyData? motleyData;
  final DateTime mostRecentDate;

  const OverlayItem({
    required this.ticker,
    required this.companyName,
    required this.direction,
    required this.arkNet,
    required this.polBuys,
    required this.polSells,
    required this.uniquePols,
    required this.isAligned,
    required this.polDetails,
    required this.arkDetails,
    this.motleyData,
    required this.mostRecentDate,
  });
}
