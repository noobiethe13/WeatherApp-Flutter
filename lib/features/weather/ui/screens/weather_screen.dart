import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:weatherapp/features/weather/controller/weather_controller.dart';
import 'package:weatherapp/responsive.dart';
import '../../../../models/weather_model.dart';
import '../../../../providers/last_city.dart';
import '../../../../providers/theme_notifier.dart';

class WeatherScreen extends ConsumerStatefulWidget {
  final String cityName;
  const WeatherScreen({super.key, required this.cityName});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends ConsumerState<WeatherScreen> {
  final WeatherController _weatherController = WeatherController();
  final _searchController = TextEditingController();
  bool isLoading = false;
  List<WeatherModel> weatherDataList = [];

  @override
  void initState() {
    super.initState();
    _fetchWeatherData(widget.cityName); //fetch data for searched city
  }

  //function to fetch weather data on refresh and search
  Future<void> _fetchWeatherData(String? cityName, {bool isRefresh = false}) async {
    setState(() {
      isLoading = true;
    });
    if (cityName != null) {
      WeatherModel? data = await _weatherController.getWeatherData(cityName);
      setState(() {
        if (data != null) {
          if (isRefresh) {
            int index = weatherDataList.indexWhere((w) => w.location.name == cityName);
            if (index != -1) {
              weatherDataList[index] = data;
            }
          } else {
            weatherDataList.add(data);
          }
        }
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
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final Responsive responsive = Responsive(height: height, width: width);
    final themeNotifier = ref.watch(themeNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: themeNotifier.isDarkTheme ? Colors.white : Colors.black, width: 1.5),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                  onPressed: (){Navigator.pop(context);},
                  icon: Icon(
                    CupertinoIcons.back,
                    size: responsive.height18,
                  color: themeNotifier.isDarkTheme ? Colors.white : Colors.black,)
              )
          ),
        ),
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
            onPressed: () {ref.read(themeNotifierProvider).toggleTheme();},
            icon: Icon(
              themeNotifier.isDarkTheme ? Icons.wb_sunny : Icons.nights_stay,
              color: themeNotifier.isDarkTheme ? Colors.yellow : Colors.purple,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
                          style: TextStyle(color: themeNotifier.isDarkTheme ? Colors.white : Colors.grey[700],),
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
                      //button to add more cities to the page
                      child: IconButton(
                        icon: Icon(
                          Icons.add_circle_outline,
                          color: themeNotifier.isDarkTheme ? Colors.black : Colors.white,
                          size: responsive.height25,
                        ),
                        onPressed: () {
                          if(_searchController.text.isEmpty){
                            Fluttertoast.showToast(
                                msg: "Please enter a city name",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 3,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: responsive.height18);
                          }
                          if (_searchController.text.isNotEmpty) {
                            ref.read(lastSearchedCityProvider.notifier).setCity(_searchController.text); //update the last searched city
                            _fetchWeatherData(_searchController.text);
                            _searchController.clear();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: responsive.height20,),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: ListView.builder(
                  itemCount: weatherDataList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: _buildWeatherCard(weatherDataList[index]),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherCard(WeatherModel weatherData) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final Responsive responsive = Responsive(height: height, width: width);
    final themeNotifier = ref.watch(themeNotifierProvider);
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
                  weatherData.location.name,
                  style: TextStyle(
                      fontSize: responsive.height25,
                      fontWeight: FontWeight.bold,
                    color: themeNotifier.isDarkTheme ? Colors.white : Colors.black,),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.blue),
                  onPressed: () {
                    _fetchWeatherData(weatherData.location.name, isRefresh: true);
                  },
                ),
              ],
            ),
            SizedBox(height: responsive.height10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${weatherData.current.tempC.toStringAsFixed(1)}°C',
                      style: TextStyle(fontSize: responsive.height25, fontWeight: FontWeight.w500, color: themeNotifier.isDarkTheme ? Colors.white : Colors.black,),
                    ),
                    Text(
                      weatherData.current.condition.text,
                      style: TextStyle(
                        fontSize: responsive.height18,
                        color: themeNotifier.isDarkTheme ? Colors.white : Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
                Image.network(
                  'https:${weatherData.current.condition.icon}',
                  width: responsive.width80,
                  height: responsive.height80,
                ),
              ],
            ),
            SizedBox(height: responsive.height18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildWeatherInfo(Icons.water_drop, '${weatherData.current.humidity}%', 'Humidity'),
                _buildWeatherInfo(Icons.wind_power, '${weatherData.current.windKph} km/h', 'Wind'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherInfo(IconData icon, String value, String label) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final Responsive responsive = Responsive(height: height, width: width);
    final themeNotifier = ref.watch(themeNotifierProvider);
    return Column(
      children: [
        Icon(icon, size: responsive.height25, color: Colors.blue),
        Text(value, style: TextStyle(fontSize: responsive.height18,
            fontWeight: FontWeight.w500,
        color: themeNotifier.isDarkTheme ? Colors.white : Colors.black,)),
        Text(label, style: TextStyle(fontSize: responsive.height10,
        color: themeNotifier.isDarkTheme ? Colors.white : Colors.black,)),
      ],
    );
  }
}
