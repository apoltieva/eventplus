# encoding : utf-8

MoneyRails.configure do |config|

  # To set the default currency
  config.default_currency = :uah
  I18n.locale = :en
  Money.locale_backend = :i18n
  Money.rounding_mode = BigDecimal::ROUND_HALF_UP
end
