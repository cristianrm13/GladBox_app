/* import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationStatusScreen extends StatefulWidget {
  const LocationStatusScreen({super.key});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationStatusScreen> {
  late GoogleMapController _mapController;
  final LatLng _initialPosition = const LatLng(16.633173171902612, -93.08483421213312); // Coordenadas iniciales (punto central del polígono)
  final Set<Polygon> _polygons = {};

  @override
  void initState() {
    super.initState();
    _loadPolygons();
  }

  void _loadPolygons() {
    // Lista de coordenadas convertidas a LatLng
    List<LatLng> suchiapaBoundary = [
      const LatLng(16.633173171902612, -93.08483421213312),
      const LatLng(16.636153348384568, -93.08566530365184),
      const LatLng(16.63912749652168, -93.08656698780683),
      const LatLng(16.640713255064085, -93.08698280459532),
      const LatLng(16.641704497542065, -93.08864174065879),
      const LatLng(16.641248450854008, -93.09168202041307),
      const LatLng(16.63668387725791, -93.09341086942862),
      const LatLng(16.635757165578937, -93.09396430210906),
      const LatLng(16.633570370332365, -93.09562428599594),
      const LatLng(16.632184767268967, -93.09701119875935),
      const LatLng(16.630460275090243, -93.09867215360705),
      const LatLng(16.629068932250206, -93.10054300144628),
      const LatLng(16.631127488859775, -93.10213829136777),
      const LatLng(16.63106147838981, -93.10290054850142),
      const LatLng(16.629867632747434, -93.10400970711869),
      const LatLng(16.62721232999337, -93.10449178543837),
      const LatLng(16.625753073677885, -93.10553324627973),
      const LatLng(16.62455903386528, -93.1064417411779),
      const LatLng(16.62289881690498, -93.10665319281915),
      const LatLng(16.621571494761895, -93.10713088072947),
      const LatLng(16.618982074915067, -93.10782496349967),
      const LatLng(16.61513173923744, -93.10844774286896),
      const LatLng(16.61353886578219, -93.10816983752191),
      const LatLng(16.61240010642959, -93.10624293070741),
      const LatLng(16.61141268077786, -93.10325267310873),
      const LatLng(16.611543361960173, -93.10159141268967),
      const LatLng(16.610879934901988, -93.09881900563137),
      const LatLng(16.610281152607385, -93.0969483897163),
      const LatLng(16.609016227524364, -93.09584035525886),
      const LatLng(16.607353148566176, -93.09528630343002),
      const LatLng(16.608956741495803, -93.09001854232265),
      const LatLng(16.610949449809283, -93.08835593849572),
      const LatLng(16.611877112869507, -93.08572232494416),
      const LatLng(16.61360325140265, -93.08544500831434),
      const LatLng(16.61632450460057, -93.08170160686899),
      const LatLng(16.618316990742855, -93.08093970103381),
      const LatLng(16.62137233483311, -93.07983449502986),
      const LatLng(16.622501114253794, -93.0798369004533),
      const LatLng(16.623297557836082, -93.07706554132486),
      const LatLng(16.62608313805164, -93.07860126978525),
      const LatLng(16.628404511314756, -93.07977690284827),
      const LatLng(16.62966591440272, -93.08192029186111),
      const LatLng(16.63085754590726, -93.08379217432068),
      const LatLng(16.633173171902612, -93.08483421213312),
    ];

    // Crea el polígono
    _polygons.add(
      Polygon(
        polygonId: const PolygonId('suchiapaBoundary'),
        points: suchiapaBoundary,
        strokeColor: Colors.orange, // Color del borde
        strokeWidth: 3, // Grosor del borde
        fillColor: Colors.orange.withOpacity(0.2), // Color de relleno semitransparente
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contorno de Suchiapa')),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 14,
        ),
        polygons: _polygons, // Agrega los polígonos al mapa
      ),
    );
  }
}
 */


import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationStatusScreen extends StatefulWidget {
  const LocationStatusScreen({super.key});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationStatusScreen> {
  late GoogleMapController _mapController;
  final LatLng _initialPosition = const LatLng(16.633173171902612, -93.08483421213312); // Coordenadas iniciales (punto central del polígono)
  final Set<Polygon> _polygons = {};

  @override
  void initState() {
    super.initState();
    _loadPolygons();
  }

  void _loadPolygons() {
    // Lista de coordenadas convertidas a LatLng
 List<LatLng> suchiapaBoundary = [
      const LatLng(16.62687888655954, -93.08680639857876),
      const LatLng(16.63054577605159, -93.08615152080996),
      const LatLng(16.633252144968353, -93.08607853026919),
      const LatLng(16.63595790366631, -93.08541861949939),
      const LatLng(16.63873857139339, -93.08625897933189),
      const LatLng(16.641515715718043, -93.08809498915001),
      const LatLng(16.6420720733706, -93.08950667034874),
      const LatLng(16.64104577196244, -93.09140981240965),
      const LatLng(16.638424378270884, -93.09248524250935),
      const LatLng(16.63603785533239, -93.0935634289176),
      const LatLng(16.63707730609518, -93.09513950080766),
      const LatLng(16.637712361006166, -93.0970532033511),
      const LatLng(16.639064779378117, -93.09788520319674),
      const LatLng(16.63939091456706, -93.10037746144876),
      const LatLng(16.637405602294805, -93.10328897132432),
      const LatLng(16.634937606987833, -93.10462170378736),
      const LatLng(16.632464540274455, -93.10353921364025),
      const LatLng(16.63070916894894, -93.1036225324005),
      const LatLng(16.63039104115974, -93.10653873809298),
      const LatLng(16.633502053688105, -93.11086807182349),
      const LatLng(16.63421964727783, -93.11328237903035),
      const LatLng(16.635495550394722, -93.1173615639605),
      const LatLng(16.63485756927041, -93.11877771195353),
      const LatLng(16.633741158611187, -93.1206945833728),
      const LatLng(16.632784744296828, -93.11944873176216),
      const LatLng(16.631190612637255, -93.11670723460001),
      const LatLng(16.631031226357678, -93.11395801252965),
      const LatLng(16.629593291261386, -93.1127058453316),
      const LatLng(16.628236499060478, -93.10904263855397),
      const LatLng(16.626080169951862, -93.10787280168361),
      const LatLng(16.622884198227766, -93.10704176776576),
      const LatLng(16.62065210897218, -93.10720517124092),
      const LatLng(16.619293007876422, -93.10778965506752),
      const LatLng(16.617616162366772, -93.10803964209127),
      const LatLng(16.616173173107157, -93.10620821444823),
      const LatLng(16.617059607074495, -93.10295637907369),
      const LatLng(16.61698195669156, -93.09987445799247),
      const LatLng(16.61610459411206, -93.09804225609723),
      const LatLng(16.61466786066204, -93.09704273156488),
      const LatLng(16.612750648286195, -93.09612577492508),
      const LatLng(16.61107073153144, -93.09437462081725),
      const LatLng(16.61059381988916, -93.09245961016086),
      const LatLng(16.61115367467896, -93.09029441245421),
      const LatLng(16.613309690354868, -93.08879570537817),
      const LatLng(16.61402630860863, -93.08804406511722),
      const LatLng(16.611462661316438, -93.084951458656),
      const LatLng(16.611625592782346, -93.08370497155317),
      const LatLng(16.61314085373965, -93.08311866266905),
      const LatLng(16.615057706867432, -93.08445216531184),
      const LatLng(16.618414537305952, -93.08579004840455),
      const LatLng(16.620251372388893, -93.08462408153885),
      const LatLng(16.622009926207255, -93.08646332876964),
      const LatLng(16.62400578996558, -93.08613246337444),
      const LatLng(16.62687888655954, -93.08680639857876),
    ];
    // Crea el polígono
    _polygons.add(
      Polygon(
        polygonId: const PolygonId('suchiapaBoundary'),
        points: suchiapaBoundary,
        strokeColor: Colors.orange, // Color del borde
        strokeWidth: 3, // Grosor del borde
        fillColor: Colors.orange.withOpacity(0.2), // Color de relleno semitransparente
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contorno de Suchiapa')),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 14,
            ),
            polygons: _polygons, // Agrega los polígonos al mapa
          ),
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'El servicio solo está disponible en el municipio de Suchiapa',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
