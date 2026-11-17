/// A place with coordinates, used for prayer times and the weather.
typedef City = ({String name, double lat, double lng});

/// Capitals of the 24 Tunisian governorates (+ Djerba). Choosing a city in
/// the app keeps the location on the phone; no GPS is needed.
abstract final class Cities {
  static const all = <City>[
    (name: 'Tunis', lat: 36.8065, lng: 10.1815),
    (name: 'Ariana', lat: 36.8625, lng: 10.1956),
    (name: 'Ben Arous', lat: 36.7531, lng: 10.2189),
    (name: 'Manouba', lat: 36.8101, lng: 10.0956),
    (name: 'Nabeul', lat: 36.4561, lng: 10.7376),
    (name: 'Zaghouan', lat: 36.4029, lng: 10.1429),
    (name: 'Bizerte', lat: 37.2744, lng: 9.8739),
    (name: 'Béja', lat: 36.7256, lng: 9.1817),
    (name: 'Jendouba', lat: 36.5011, lng: 8.7802),
    (name: 'Le Kef', lat: 36.1826, lng: 8.7149),
    (name: 'Siliana', lat: 36.0849, lng: 9.3708),
    (name: 'Sousse', lat: 35.8256, lng: 10.6084),
    (name: 'Monastir', lat: 35.7643, lng: 10.8113),
    (name: 'Mahdia', lat: 35.5047, lng: 11.0622),
    (name: 'Sfax', lat: 34.7406, lng: 10.7603),
    (name: 'Kairouan', lat: 35.6781, lng: 10.0963),
    (name: 'Kasserine', lat: 35.1676, lng: 8.8365),
    (name: 'Sidi Bouzid', lat: 35.0382, lng: 9.4849),
    (name: 'Gabès', lat: 33.8815, lng: 10.0982),
    (name: 'Médenine', lat: 33.3549, lng: 10.5055),
    (name: 'Djerba', lat: 33.8754, lng: 10.8577),
    (name: 'Tataouine', lat: 32.9297, lng: 10.4518),
    (name: 'Gafsa', lat: 34.4250, lng: 8.7842),
    (name: 'Tozeur', lat: 33.9197, lng: 8.1335),
    (name: 'Kébili', lat: 33.7044, lng: 8.9690),
  ];

  static City byName(String name) => all.firstWhere((c) => c.name == name, orElse: () => all.first);
}
