class Rack::Attack

  ### Throttle Spammy Clients ###

  throttle('req/ip', limit: 300, period: 5.minutes) do |req|
    req.ip unless req.path.start_with?('/assets')
  end

  ### Prevent Brute-Force Login Attacks ###
  throttle('logins/ip', limit: 5, period: 20.seconds) do |req|
    if req.path.end_with?('/users/sign_in') && req.post?
      req.ip
    end
  end

  throttle('logins/email', limit: 5, period: 20.seconds) do |req|
    if req.path == '/users/sign_in' && req.post?
      # Normalize the email, using the same logic as your authentication process, to
      # protect against rate limit bypasses. Return the normalized email if present, nil otherwise.
      req.params['email'].to_s.downcase.gsub(/\s+/, "").presence
    end
  end

  blocklist('block attacks to /php/myAdmin') do |req|
    req.path.start_with? '/php'
  end

end

Rack::Attack.throttled_response_retry_after_header = true
Rack::Attack.throttled_response = lambda do |env|
  match_data = env['rack.attack.match_data']
  now = match_data[:epoch_time]

  headers = {
    'RateLimit-Limit' => match_data[:limit].to_s,
    'RateLimit-Remaining' => '0',
    'RateLimit-Reset' => (now + (match_data[:period] - now % match_data[:period])).to_s
  }

  [ 429, headers, ["Throttled\n"]]
end
