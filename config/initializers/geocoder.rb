Geocoder.configure(
  google: {
    api_key: Rails.application.credentials.google_maps_api_key
  },
  # IP address geocoding service (default :ipinfo_io)
  ip_lookup: :ipinfo_io,
  timeout: 10,
  units: :km
)

