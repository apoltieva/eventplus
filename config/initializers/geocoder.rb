Geocoder.configure(
  lookup: :yandex,
  # IP address geocoding service (default :ipinfo_io)
  ip_lookup: :db_ip_com,
  db_ip_com: { api_key: 'free'},
  timeout: 10,
  units: :km
)

