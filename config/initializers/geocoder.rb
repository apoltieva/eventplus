Geocoder.configure(
  lookup: { google: {
    api_key: Rails.application.credentials.google_maps_api_key
    }
  },
  # IP address geocoding service (default :ipinfo_io)
  ip_lookup: :db_ip_com,
  timeout: 10,
  units: :km
)

