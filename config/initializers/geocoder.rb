Geocoder.configure(
  google: {
    api_key: Rails.application.credentials.google_maps_api_key
  },

  # IP address geocoding service (default :ipinfo_io)
  ip_lookup: :ipapi_com,

  # to use an API key:
  api_key: "...",

  # geocoding service request timeout, in seconds (default 3):
  timeout: 10,

  # set default units to kilometers:
  units: :km,

  # caching (see Caching section below for details):
  cache: Redis.new,
  cache_prefix: "..."

)

