# medium_weather_app

Piscine Mobile — Module 02: *API and Data Management*.

Continuation of the Module 01 weather app: the three tabs are now filled with
real data from Open-Meteo, the search bar suggests cities as you type, and the
device position comes from the platform geolocation API.

## APIs

| Purpose | Endpoint |
| --- | --- |
| City search / suggestions | `geocoding-api.open-meteo.com/v1/search` |
| Forecast (current, hourly, daily) | `api.open-meteo.com/v1/forecast` |
| Coordinates → city name | `api-bdc.net/data/reverse-geocode-client` |

Open-Meteo's geocoding API only resolves names to coordinates, so the reverse
lookup used by the geolocation button goes through BigDataCloud's key-less
client endpoint. Coordinates themselves always come from the platform
geolocation API (`geolocator`: native GPS on device/emulator, the browser
Geolocation API on web) — never from an external geolocation service.

Temperatures are in Celsius and wind speeds in km/h, which are Open-Meteo's
defaults.

## Layout

```
lib/
├── constants/    colors, WMO weather-code table
├── models/       GeoLocation, WeatherReport, WeatherState
├── screens/      Currently, Today, Weekly
├── services/     geocoding, forecast, geolocation, HTTP client
├── widgets/      top bar, suggestion list, bottom bar, shared frame
└── main.dart     tab + search state
```

## Run

```sh
flutter pub get
flutter run
```

Location permission is declared in `android/app/src/main/AndroidManifest.xml`,
`ios/Runner/Info.plist` and the macOS entitlements.
