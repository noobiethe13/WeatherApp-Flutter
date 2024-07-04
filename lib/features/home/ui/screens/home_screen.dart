import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:weatherapp/features/home/controller/home_controller.dart';
import 'package:weatherapp/models/weather_model.dart';
import 'package:weatherapp/responsive.dart';
import '../../../../providers/last_city.dart';
import '../../../../providers/theme_notifier.dart';
import '../../../weather/ui/screens/weather_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final HomeController _homeController = HomeController();
  final _searchController = TextEditingController();
  WeatherModel? weatherData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWeatherData(); //search weather info on page load
  }

  //function to search weather for current user's city
  Future<void> _fetchWeatherData() async {
    setState(() {
      isLoading = true;
    });
    String? cityName = await _homeController.getCityName(context);
    if (cityName != null) {
      WeatherModel? data = await _homeController.getWeatherData(cityName);
      setState(() {
        weatherData = data;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lastSearchedCity = ref.watch(lastSearchedCityProvider); //fetch last searched city from cache
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final Responsive responsive = Responsive(height: height, width: width);
    final themeNotifier = ref.watch(themeNotifierProvider); //fetch last set app theme from cache
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "WeatherApp",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: responsive.height25,
            color: themeNotifier.isDarkTheme ? Colors.white : Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(themeNotifierProvider).toggleTheme(); //change app theme
            },
            icon: Icon(
              themeNotifier.isDarkTheme ? Icons.wb_sunny : Icons.nights_stay,
              color: themeNotifier.isDarkTheme ? Colors.yellow : Colors.purple,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: responsive.width400,
                  height: responsive.height50,
                  decoration: BoxDecoration(
                    color: const Color(0xff61788A).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: TextFormField(
                            controller: _searchController,
                            cursorColor: themeNotifier.isDarkTheme ? Colors.white : Colors.grey[700],
                            style: TextStyle(color: themeNotifier.isDarkTheme ? Colors.white : Colors.grey[700]),
                            decoration: InputDecoration(
                              hintText: 'Search',
                              hintStyle: TextStyle(color: themeNotifier.isDarkTheme ? Colors.white : Colors.grey[700], fontSize: responsive.height18),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: themeNotifier.isDarkTheme ? Colors.white : Colors.grey[700],
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.search,
                            color: themeNotifier.isDarkTheme ? Colors.black : Colors.white,
                            size: responsive.height25,
                          ),
                          onPressed: () {
                            //check if field is empty
                            if(_searchController.text.isEmpty){
                              Fluttertoast.showToast(
                                  msg: "Please enter a city name",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 3,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: responsive.height18);
                            } else {
                              final cityName = _searchController.text;
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => WeatherScreen(cityName: cityName,)),
                              );
                              ref.read(lastSearchedCityProvider.notifier).setCity(cityName); //set last searched city name
                              _searchController.clear();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: responsive.height20),
              //display weather card for user's city
              Text(
                "Weather for you",
                style: TextStyle(
                  fontSize: responsive.height25,
                  fontWeight: FontWeight.w600,
                  color: themeNotifier.isDarkTheme ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: responsive.height10),
              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else if (weatherData != null)
                _buildWeatherCard(),
              SizedBox(height: responsive.height20,),
              //display weather card for last searched city
              Text("Last searched city",
                style: TextStyle(
                  fontSize: responsive.height25,
                  fontWeight: FontWeight.w600,
                  color: themeNotifier.isDarkTheme ? Colors.white : Colors.black,
                ),),
              SizedBox(height: responsive.height10,),
              if (lastSearchedCity.isEmpty)
                Center(
                  child: Text(
                    "Search a city first",
                    style: TextStyle(
                      fontSize: responsive.height18,
                      color: Colors.grey[600],
                    ),
                  ),
                )
              else
                FutureBuilder<WeatherModel?>(
                  future: _homeController.getWeatherData(lastSearchedCity), //fetch data for last searched city
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasData) {
                      return _buildWeatherCard(snapshot.data!);
                    } else {
                      return Text(
                        "Unable to fetch weather for $lastSearchedCity",
                        style: TextStyle(
                          fontSize: responsive.height18,
                          color: Colors.red,
                        ),
                      );
                    }
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherCard([WeatherModel? data]) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final Responsive responsive = Responsive(height: height, width: width);
    final weather = data ?? weatherData!;
    final themeNotifier = ref.watch(themeNotifierProvider);
    //weather card
    return Card(
      color: themeNotifier.isDarkTheme ? Colors.black : Colors.white,
      elevation: 10,
      shadowColor: themeNotifier.isDarkTheme ? Colors.white : Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  weather.location.name,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: themeNotifier.isDarkTheme ? Colors.white : Colors.black,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.blue),
                  onPressed: _fetchWeatherData,
                ),
              ],
            ),
            SizedBox(height: responsive.height10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${weather.current.tempC.toStringAsFixed(1)}°C',
                        style: TextStyle(
                          fontSize: responsive.height25,
                          fontWeight: FontWeight.w500,
                          color: themeNotifier.isDarkTheme ? Colors.white : Colors.black,
                        ),
                      ),
                      Text(
                        weather.current.condition.text,
                        style: TextStyle(
                          fontSize: responsive.height18,
                          color: themeNotifier.isDarkTheme ? Colors.white : Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
                Image.network(
                  'https:${weather.current.condition.icon}',
                  width: responsive.width80,
                  height: responsive.height80,
                ),
              ],
            ),
            SizedBox(height: responsive.height18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildWeatherInfo(
                  Icons.water_drop,
                  '${weatherData!.current.humidity}%',
                  'Humidity',
                ),
                _buildWeatherInfo(
                  Icons.wind_power,
                  '${weatherData!.current.windKph} km/h',
                  'Wind',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //widget to build weather data
  Widget _buildWeatherInfo(IconData icon, String value, String label) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final Responsive responsive = Responsive(height: height, width: width);
    final themeNotifier = ref.watch(themeNotifierProvider);
    return Column(
      children: [
        Icon(icon, size: responsive.height25, color: Colors.blue),
        Text(value, style: TextStyle(
            fontSize: responsive.height18,
            fontWeight: FontWeight.w500,
            color: themeNotifier.isDarkTheme ? Colors.white : Colors.black
        ),
        ),
        Text(label, style: TextStyle(fontSize: responsive.height10, color: themeNotifier.isDarkTheme ? Colors.white : Colors.black)),
      ],
    );
  }
}
