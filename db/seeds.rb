# frozen_string_literal: true

DESCRIPTIONS = File.read('db/descriptions.txt').split("\n\n\n")

if Venue.none?
  10.times do
    Venue.create!(name: Faker::Mountain.name,
                  latitude: rand(50.0..51.0),
                  longitude: rand(30.0..31.0),
                  max_capacity: rand(10000))
  end
end

if Performer.none?
  10.times do
    Performer.create!(name: Faker::Name.name)
  end
end

performers = Performer.all
if Event.none?
  DESCRIPTIONS.each do | descr |
    Event.create!(title: Faker::Movie.title,
                  description: descr,
                  performer_id: performers.sample.id,
                  start_time: Faker::Time.between(from: DateTime.new(2021, 8, 3, 4, 5, 6),
                                                  to: DateTime.new(
                                                    2021, 12, 3, 4, 5, 6
                                                  )),
                  end_time: Faker::Time.between(from: DateTime.new(2022, 2, 3, 4, 5, 6),
                                                to: DateTime.new(2023,
                                                                 2, 3, 4, 5, 6)),
                  venue_id: Venue.all.sample.id,
                  total_number_of_tickets: rand(100000),
                  ticket_price_cents: rand(100000)
                  )
  end
end

Event.all.each do |e|
  if e.pictures.empty?
    (1..3).each do |i|
      e.pictures.attach(io: URI.open(Faker::LoremFlickr.image(search_terms: ['events', 'parties'])),
                        filename: "#{i}.png")
    end
  end
end
Venue.all.each do |v|
  if v.pictures.empty?
    (1..3).each do |i|
      v.pictures.attach(io: URI.open(Faker::LoremFlickr.image(search_terms: ['mountains'])),
        filename: "#{i}.png")
    end
  end
end
5.times do
  Admin.create!(email: Faker::Internet.email, password: "123456", confirmed_at: Time.now, role: 1)
end

#pagerank
# [[["ross", 28.538143543067793], ["skye", 28.204694233000637], ["blue", 21.13273294632153], ["morcheeba", 21.03425066443237], ["band", 20.614323525911566], ["blackest", 17.24781509322045], ["like", 16.9394459666923], ["album", 16.211649618859884], ["play", 15.910605059008859], ["tour", 13.32487270093612]], [["stand", 22.811652842283074], ["comedy", 17.65029996695264], ["participant", 16.85051265176943], ["comedian", 16.75504030316781], ["ukrainian", 14.484705496575362], ["kyiv", 14.081626466708506], ["club", 13.036566822542962], ["agency", 10.39781406565146], ["channel", 9.515602233956052], ["standup", 9.40812294427353]], [["kino", 27.690072452385262], ["group", 23.959833267714423], ["years", 19.29566757985496], ["concert", 19.00391648263598], ["tsoi", 18.9844623458263], ["original", 18.967517915816536], ["live", 17.24830996732263], ["fans", 15.0949856442987], ["viktor", 14.796244215169555], ["perform", 11.534644717682845]], [["studfest", 21.42236166930758], ["kyiv", 19.085796462210702], ["students", 19.06003775916306], ["dedication", 14.834257693345922], ["don", 13.256626688012158], ["night", 11.19118863254186], ["change", 10.413886076154014], ["original", 10.245974319763139], ["holiday", 9.765345066468193], ["stage", 9.654896404695855]], [["garden", 18.203808261127442], ["rock", 14.159193202403026], ["kyiv", 14.157631963531983], ["concert", 13.311445591970756], ["best", 12.095146107303336], ["queen", 12.024239208008112], ["orchestra", 8.75776260101472], ["virtuosos", 8.523378359898755], ["botanical", 8.508685834442828], ["concerts", 8.38514789472902]], [["sinatra", 13.78046574982971], ["frank", 13.392069212372656], ["roof", 11.71362378192007], ["jazz", 11.60667818849489], ["love", 10.868530067421455], ["concert", 9.490335959595571], ["kiev", 8.801862748040028], ["tsum", 8.452888373705647], ["spend", 6.379331189066344], ["excuse", 6.372418000984991]], [["sex", 27.249624837489446], ["love", 15.518054499149802], ["don", 14.738216210625867], ["understand", 14.394055276892065], ["just", 13.10306512860617], ["comedy", 12.970395912916635], ["adults", 10.182716065505067], ["frank", 10.074700191066222], ["viewers", 10.032804009452887], ["does", 9.81645619074843]], [["sharikov", 16.600543403897586], ["experiment", 15.853204616899305], ["professor", 15.31133205422586], ["dog", 14.089850485394972], ["real", 11.21501062011285], ["place", 10.742975888318316], ["moscow", 10.559521599017778], ["preobrazhensky", 10.540109472738127], ["kiev", 10.279289402942984], ["return", 6.7281999726913115]], [["children", 14.890662828114616], ["sand", 14.642578383124564], ["adults", 14.497998087346298], ["tale", 12.70301514079836], ["fairy", 11.904710303361883], ["art", 9.879652300473712], ["world", 9.173844891433612], ["lion", 9.089783595783526], ["magical", 9.0863515872366], ["golden", 8.82011400632406]], [["viewer", 10.97430624703349], ["different", 9.978317316092726], ["sparrows", 9.387653210848628], ["theater", 8.65938759189079], ["feathered", 8.572133974722888], ["guest", 8.035530650657087], ["absurd", 7.930557989846675], ["friend", 7.716267637563288], ["comedy", 7.694830916439345], ["laughter", 7.151131176566945]]]
# 3.0.0 :016 > DESCRIPTIONS.each do |desc|
# 3.0.0 :017 >   tr = GraphRank::Keywords.new
# 3.0.0 :018 >   rankings << tr.run(desc)[0...10]
# 3.0.0 :019 > end
