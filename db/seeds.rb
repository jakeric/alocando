
# Seed of cities and airports

if City.count != 4925
  # destroy all existing Airport datasets
  puts "detroy all airports..."
  Airport.destroy_all
  Attachment.destroy_all
  City.destroy_all
  puts "airports destroyed"

  # parsing all airports and cities
  puts "get data from json..."
  airport_url = 'https://raw.githubusercontent.com/ram-nadella/airport-codes/master/airports.json'
  airports_serialized = open(airport_url).read
  airports = JSON.parse(airports_serialized)

  puts "creating the airports and cities..."

  airports.each do |airport|
    airport_code = airport.last["iata"]
    airport_name = airport.last["name"]
    city_name = airport.last["city"]
    city_country = airport.last["country"]
    city_timezone = airport.last["timezone"]

    # get city or create a new one
    if City.where("name = ? and country = ?", city_name, city_country) == [] && city_country != 'Canada'
      new_city = City.new(name: city_name, country: city_country, timezone: city_timezone)
      new_city.save
      new_airport = Airport.new(name: airport_name, acronym: airport_code)
      new_airport.city = new_city
      new_airport.save
    else
      city = City.where("name = ?", city_name)
      new_airport = Airport.new(name: airport_name, acronym: airport_code, city_id: city.ids.first)
      # new_airport.city = city
      new_airport.save
    end
  end

  puts "Created #{Airport.count} airports and #{City.count} cities."
else
  puts "Airports and Cities are already created, Sir."
end

# Seed of the airlines

if Airline.count != 806
  # destroy all existing Airport datasets
  puts "detroy all airlines and flights..."
  FlightBundleFlight.destroy_all
  FlightBundle.destroy_all
  Flight.destroy_all
  Airline.destroy_all
  puts "airlines and flights has been destroyed"

  # parsing all airlines
  puts "getting json for the airlines..."
  airline_url = 'https://raw.githubusercontent.com/BesrourMS/Airlines/master/airlines.json'
  airlines_serialized = open(airline_url).read
  airlines = JSON.parse(airlines_serialized)

  puts "creating airlines now..."
  airlines.each do |airline|

    airline_acronym = airline["iata"]
    airline_name = airline["name"]

    new_airline = Airline.new(acronym: airline_acronym, name: airline_name).save # if Airline.where("acronym = ?", airline_acronym) == []

  end
  puts "Created #{Airline.count} airlines."
else
  puts "Airlines are already created, Sir."
end

# deleting all the airports where city is nil
puts "deleting airports without a city"
Airport.where(city_id: nil).destroy_all
puts "airports without a city has been deleted"


# seeding flights
if Flight.count != 20000

  puts "deleting all the flights..."
  number_of_flights = Flight.count
  FlightBundleFlight.destroy_all
  FlightBundle.destroy_all
  # Flight.destroy_all
  puts "#{number_of_flights} has been deleted."

  puts "creating 20000 f**king flights..."
  # average speed of a plane 885 km/hr
  airplane_speed = 885.0

  20000.times do
    # get random start and end airport

    # Munich, Berlin, Paris, Lisbon, London, Madrid, Bratislava, Oslo, Reykjavik, Rome, Vienna, Warschau, Stockholm, Budapest, Dublin
    start_airport = ['MUC','TXL','SXF', 'CDG', 'LGW', 'LHR', 'LIS', 'MAD', 'BTS', 'OSL', 'RKV', 'FCO', 'VIE', 'WAW', 'ARN', 'BUD', 'DUB'].sample

    # search for start airport city
    start_airport = Airport.where(acronym: start_airport)
    city_one = start_airport[0].city.name


    exclude_airports = Airport.where(city_id: start_airport[0].city_id).pluck(:acronym)

    end_airport = ['MUC','TXL','SXF', 'CDG', 'LGW', 'LHR', 'LIS', 'MAD', 'BTS', 'OSL', 'RKV', 'FCO', 'VIE', 'WAW', 'ARN', 'BUD', 'DUB']
    end_airport = end_airport - exclude_airports
    end_airport = end_airport.sample

    # search for end_airport city
    end_airport = Airport.where(acronym: end_airport)
    city_two = end_airport[0].city.name

    # get random airline
    # airline = Airline.limit(1).order("RANDOM()")
    random_airline = ['Ryanair', 'Lufthansa', 'KLM', 'EasyJet', 'Turkish Airlines', 'TAP Portugal', 'Air France', 'Aeroflot', 'Pegasus Airlines', 'Wizz Air', 'Eurowings', 'Virgin Atlantic', 'Norwegian Air'].sample
    airline = Airline.where(name: random_airline).first

    # calculate random start date
    departure_hour = rand(6..22)
    departure_min = [5, 10, 15 ,20 ,25 ,30 ,35 ,40 ,45 ,50 ,55].sample.to_f
    departure_hour_min = "#{departure_hour + (departure_min / 60.0)}".to_f
    day_range = rand(1..30)
    departure_datetime = Date.today.to_datetime + day_range + (departure_hour_min / 24.0)

    # distance_km = distance["distance"]
    distance_km = [2316.0, 2000.0, 1600.0, 1400.0, 900.0].sample
    flight_duration = distance_km / airplane_speed
    # time_offset_hours = distance["travel"]["timeOffset"]["offsetMins"] / 60

    arrival_datetime = departure_datetime + (flight_duration / 24.0) #+ time_offset_hours

    price = rand(15..449)

    new_flight = Flight.new(
      departure_datetime: departure_datetime,
      arrival_datetime: arrival_datetime,
      price: price,
      flight_duration: flight_duration,
      from_airport_id: start_airport.ids.first,
      to_airport_id: end_airport.ids.first,
      airline_id: airline.id
      )
    new_flight.save
    puts "1000 flights" if Flight.count == 1000
    puts "2000 flights" if Flight.count == 2000
    puts "3000 flights" if Flight.count == 3000
    puts "4000 flights" if Flight.count == 4000
    puts "5000 flights" if Flight.count == 5000
    puts "6000 flights" if Flight.count == 6000
    puts "7000 flights" if Flight.count == 7000
    puts "8000 flights" if Flight.count == 8000
    puts "9000 flights" if Flight.count == 9000
    puts "10000 flights" if Flight.count == 10000
    puts "11000 flights" if Flight.count == 11000
    puts "12000 flights" if Flight.count == 12000
    puts "13000 flights" if Flight.count == 13000
    puts "14000 flights" if Flight.count == 14000
    puts "15000 flights" if Flight.count == 15000
    puts "16000 flights" if Flight.count == 16000
    puts "17000 flights" if Flight.count == 17000
    puts "18000 flights" if Flight.count == 18000
    puts "19000 flights.. pray for it" if Flight.count == 19000
  end
else
  puts "There are already 1000 flights, Sir."
end

puts "all flights created"
puts "fetching the city description, acitivities and picture"

# city description
all_cities = ['Munich', 'Berlin', 'Paris', 'Lisbon', 'London', 'Madrid', 'Bratislava', 'Oslo', 'Reykjavik', 'Rome', 'Vienna', 'Warsaw', 'Stockholm', 'Budapest', 'Dublin']

img_munich = 'https://cdn.pixabay.com/photo/2017/10/18/10/20/munich-2863539_1280.jpg'
img_berlin = 'https://images.unsplash.com/photo-1515711883701-0f1104702fff?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=9eca1da4d1f9e9136e06ec5be3ba923b&auto=format&fit=crop&w=934&q=80'
img_paris = 'https://cdn.pixabay.com/photo/2018/04/06/17/17/paris-3296269_1280.jpg'
img_lisbon = 'https://images.unsplash.com/photo-1531258932533-1ecc042f713a?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=5c060456302b94ec3f00ed512968bd1f&auto=format&fit=crop&w=1950&q=80'
img_London = 'https://images.unsplash.com/photo-1513635269975-59663e0ac1ad?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=18dcdd4e1c2627bc3c9bf68645c9ae92&auto=format&fit=crop&w=1950&q=80'
img_madrid = 'https://images.unsplash.com/photo-1512847819326-205ee05f3ceb?ixlib=rb-0.3.5&s=c6bda1339ae942a71268fae3cec7c97a&auto=format&fit=crop&w=1950&q=80'
img_bratislava = 'https://cdn.pixabay.com/photo/2017/09/24/10/48/slovakia-2781470_1280.jpg'
img_oslo = 'https://images.unsplash.com/photo-1504971588239-ba9c6ac9097f?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=7e88faff53045331e1bad18806ab3b8e&auto=format&fit=crop&w=2850&q=80'
img_rey = 'https://cdn.pixabay.com/photo/2016/08/20/17/41/iceland-1608065_1280.jpg'
img_rome = 'https://cdn.pixabay.com/photo/2014/03/26/05/47/vittorio-emanuele-monument-298412_1280.jpg'
img_vienna = 'https://images.unsplash.com/photo-1519923041107-e4dc8d9193da?ixlib=rb-0.3.5&s=5f1f40dad83fbdda6773c3c3728e0721&auto=format&fit=crop&w=1950&q=80'
img_warsaw = 'https://cdn.pixabay.com/photo/2016/05/29/21/09/warsaw-1423864_1280.jpg'
img_stockholm = 'https://images.unsplash.com/photo-1497217968520-7d8d60b7bc25?ixlib=rb-0.3.5&s=6714b91de94028c081135d2a3fd5954e&auto=format&fit=crop&w=1950&q=80'
img_budapest = 'https://cdn.pixabay.com/photo/2018/02/23/22/00/water-3176750_1280.jpg'
img_dublin = 'https://images.unsplash.com/photo-1532534716609-075d657a64b3?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=dc93b6e23e2c5da88edb3a4c9eee9b57&auto=format&fit=crop&w=1950&q=80'

img_array = [img_munich, img_berlin, img_paris, img_lisbon, img_London, img_madrid, img_bratislava, img_oslo, img_rey, img_rome, img_vienna, img_warsaw, img_stockholm, img_budapest, img_dublin]


desc_munich = "Munich was almost completely destroyed in two world wars, yet it's managed to recreate much of its folkloric, Bavarian past. Oktoberfest is legendary, but you can visit the Hofbrauhaus any time of year for an immense beer. Olympiapark, the site of the 1972 games, is not to be missed (you can skate on the Olympic ice rink and swim in the pool). On a somber note, take time to visit the concentration camp at Dachau—it's an intense, yet unforgettable, glimpse into the not-too-distant horrors of the Holocaust."
desc_berlin = "In progressive Berlin, the old buildings of Mitte gracefully coexist with the modern Reichstag. Don't miss top historical sights like the Berlin Wall, Checkpoint Charlie, the Brandenburg Gate and Potsdamer Platz."
desc_paris = "Everyone who visits Paris for the first time probably has the same punchlist of major attractions to hit: The Louvre, Notre Dame, The Eiffel Tower, etc. Just make sure you leave some time to wander the city's grand boulevards and eat in as many cafes, bistros and brasseries as possible. And don't forget the shopping—whether your tastes run to Louis Vuitton or Les Puces (the flea market), you can find it here."
desc_lisbon = "Lisbon, the capital city of Portugal, has become an increasingly popular place to visit in recent years, with a warm Mediterranean climate in spite of its place facing the Atlantic Ocean. Full of bleached white limestone buildings and intimate alleyways, Lisbon's mix of traditional architecture and contemporary culture makes it the perfect place for a family holiday."
desc_London = "There's so much to see and do in London, it's easy to be overwhelmed. Major sights like the Tower of London and Buckingham Palace are on most visitors' itineraries, but no matter what your interests, you'll probably find something here."
desc_madrid = "Madrid is the financial and cultural hub for Spain, and much of Southern Europe. There is a huge amount to see and do there, as well as excellent nightlife in terms of bars, restaurants, clubs and entertainment. As the area has been inhabited since Roman times, there are also plenty of historical sites to explore and enjoy."
desc_bratislava = "Staré Mesto, the Old Town of Slovakia's capital, whisks visitors back a few centuries as they wander through cobbled streets, admire the Baroque architecture, enjoy summer and Christmas concerts at Old Town Hall and while away time at cafés and restaurants. Venture beyond for more sites, including the 15th-century hrad (castle)."
desc_oslo = "The 1000-year-old Norwegian capital sits at the head of Oslo Fjord. This stunning setting gives hints of the wild wonders that lie just beyond the city. From taking in visual delights at Vigeland Sculpture Park, the Viking Ship Museum, the Munch Museum and Holmenkollen, to the challenging content within the new Nobel Peace Centre and the Holocaust Centre, Oslo offers plenty of food for thought."
desc_rey = "Iceland's biggest city, Reykjavik bears the distinction of being the world's northernmost capital, and for virtually every Icelandic visitor it serves as a gateway, just to the city itself or to the rugged adventure options beyond. Founded in the country's southwest at the end of the 18th century, Reykjavik has been Iceland's cultural hub ever since."
desc_rome = "It's nicknamed the Eternal City for a reason. In Rome, you can drink from a street fountain fed by an ancient aqueduct. Or see the same profile on a statue in the Capitoline Museum and the guy making your cappuccino. (Which, of course, you know never to order after 11 am.) Rome is also a city of contrasts—what other place on earth could be home to both the Vatican and La Dolce Vita?"
desc_vienna = "If you currently think your neighbourhood coffee shop is nice, you might want to stay out of Vienna's coffeehouses. After you've gotten used to these palatial, yet welcoming cafes—and their delicious coffee and Sacher torte—your local café will pale in comparison. Between coffee breaks, visitors can explore Vienna's Schonbrunn Palace and Imperial Palace. And if you have a chance, catch a performance at the State Opera House—it's not to be missed."
desc_warsaw = "Palaces and parkland abound in the Polish capital. Public transport - buses, metro, trams and trolley buses - make it accessible. See the city spread before you from the monumental Palace of Culture and Science. Visit the Royal Castle and the Gothic, cobbled alleys and baroque palaces of the Old Town - destroyed by German troops but now masterfully reconstructed. The Old Town sights include the moving Uprising Monument and lovely Krasinski gardens. Walk the Royal Way to see the best of Warsaw."
desc_stockholm = "The capital city of Sweden combines modern attractions with historic charm. Kick off your stay with visits to Stockholm's two UNESCO World Heritage Sites: the Royal Palace Drottningholm (the residence of the royal family) and the magical Skogskyrkogården, or Woodland Cemetery. Stroll the cobblestone streets of Old Town and over the picturesque bridges that span the city's canals. The 19th-century Skansen was the world's first open-air museum and is still a premier place to learn about Swedish history."
desc_budapest = "Over 15 million gallons of water bubble daily into Budapest's 118 springs and boreholes. The city of spas offers an astounding array of baths, from the sparkling Gellert Baths to the vast 1913 neo-baroque Szechenyi Spa to Rudas Spa, a dramatic 16th-century Turkish pool with original Ottoman architecture. The 'Queen of the Danube' is also steeped in history, culture and natural beauty. Get your camera ready for the Roman ruins of the Aquincum Museum, Heroes' Square and Statue Park, and the 300-foot dome of St. Stephen's Basilica."
desc_dublin = "You've probably heard that Guinness tastes better in Dublin (fresh from the factory), but what you may not know is that Dublin is a perfect destination for the whole family. No, we're not suggesting you let the kiddies drink a pint. Instead, take them to the Dublin Zoo, to feed the ducks in Stephen's Green or on a picnic in Phoenix Park. Scholars enjoy walking in the literary footsteps of such writers as Yeats and Joyce, while discerning shoppers have their pick of designer boutiques."

desc_array = [desc_munich, desc_berlin, desc_paris, desc_lisbon, desc_London, desc_madrid, desc_bratislava, desc_oslo, desc_rey, desc_rome, desc_vienna, desc_warsaw, desc_stockholm, desc_budapest, desc_dublin]

# array of arrays first: sights, second:restaurants, third: museum
details_munich = [['Olympiapark','Marienplatz','Virktualenmarkt'],['Pils Corner','Halali','Steinheil 16'],['BMW Headquarters','Valentin Museum','Municipal Gallery']]
details_berlin = [['Reichstag','Brandenburg Gate','Memorial of the Berlin Wall'],['Zur Haxe','Kurpfalz-Weinstuben','Marjellchen'],['Pergamon Museum','DDR Museum','Game Science Center']]
details_paris = [['Eiffel Tower','Notre Dame Cathedral','Sainte-Chapelle'],['Cafe Mimosa','Les Apotres de Pigalle','Can Alegria Paris'],['Louvre',"Museum d'Orsay","Museum de l'Orangerie"]]
details_lisbon = [["St. Jorge's Castle","Belem Tower","Jeronimos Monastery"],['Cervejaria Ramiro','Mestrias','Alma'],['Calouste Gulbenkian','Museu Colecao Berardo','Museu da Marinha']]
details_London = [['Tower of London','Tower Bridge','St. James Park'],['The Oystermen Seafood','The Golden Chippy','Amrutha Lounge'],['National Gallery','Churchill War Rooms','The British Museum']]
details_madrid = [['Royal Palace','Bernabeu Stadium','San Miguel Market'],['Los Montes de Galicia','Moratin Vinoteca Bistrot','Nuevo Horno de S. Teresa'],['Prado National Museum','Thyssen Bornemisza','Museo Sorolla']]
details_bratislava = [['Old Town','Devin Castle','Slovakia National Theatre'],['Dolnozemska Krcma','Modra Hviezda','Koliba Kamzik'],['Danubiana Art Museum','Nedbalka Gallery','Bratislava City Museum']]
details_oslo = [['National Opera and Ballet','Frogner Park','Karl Johans'],['Elias Mat & Sant','VulkanFisk','Den Glade Gris'],['Vigeland Museum','Fram Polar Ship Museum','National Museum']]
details_rey = [['Hallgrimskirkja','Northern Lights','Harpa Reykjavik Concert Hall'],['Icelandic Street Food','Ostabudin','Resto'],['Perlan','National Museum','The Settlement Exhibition']]
details_rome = [['Colosseum','Roman Forum','Galleria Borghese'],['Tonnarello','Pane e Salame','Trinita de Monti'],["Museo Nazionale di Sant'Angelo",'Museo Capitolini','Palazzo Colonna']]
details_vienna = [['Schonbrunn Palaca','Historic Center','Belvedere Palace'],['Die Metzgerei','Brau-bar','Schachtelwirt'],["Time Travel Vienna",'Schmetterlinghaus','MAK']]
details_warsaw = [['Lazienki Krolewskie','Old town','Castle Square'],['Stary Dom','Stolica','Przy Zamku'],["POLIN Museum",'Uprising Museum','Fryderyk Chopin Museum']]
details_stockholm = [['Old town','City Hall','Kungliga Djurgarden'],['Gastabud','Kajsas Fisk','Tradition'],["Vasa Museum",'Nobel Museum','Medieval Museum']]
details_budapest = [['Parliament',"St. Stephen's Basilica","Fisherman's Bastion"],['Kacsa','Varosliget','Hungarikum Bisztro'],["Pinball Museum",'Hungarian National Museum','Victor Vasarely Museum']]
details_dublin = [['Guiness Storehouse','The Book of Kells','Trinity College'],['Bloom Brasserie',"Darkey Kelly's Bar & Restaurant",'Brookwood'],['National Museum of Art','National Gallery of Ireland','Chester Beatty Library']]

detail_array = [details_munich, details_berlin, details_paris, details_lisbon, details_London, details_madrid, details_bratislava, details_oslo, details_rey, details_rome, details_vienna, details_warsaw, details_stockholm, details_budapest, details_dublin]


i = 0
all_cities.each do |city|
  puts "for #{city}"

  # update the description of the city
  city_to_update = City.where(name: city).first
  city_to_update.description = desc_array[i]

  # city details
  city_to_update.sight_one = detail_array[i][0][0]
  city_to_update.sight_two = detail_array[i][0][1]
  city_to_update.sight_three = detail_array[i][0][2]

  city_to_update.restaurant_one = detail_array[i][1][0]
  city_to_update.restaurant_two = detail_array[i][1][1]
  city_to_update.restaurant_three = detail_array[i][1][2]

  city_to_update.bar_one = detail_array[i][2][0]
  city_to_update.bar_two = detail_array[i][2][1]
  city_to_update.bar_three = detail_array[i][2][2]

  #insert city picture url
  imaaage = img_array[i]
  att = Attachment.new(photo: open(imaaage))
  att.city_id = city_to_update.id
  att.save

  # save city
  city_to_update.save

  # increase counter for arrays
  i += 1
end

# +++++++ Adding Airline urls for the Airlines we are Using +++++++++ #
used_airlines = ['Ryanair', 'Lufthansa', 'KLM', 'EasyJet', 'Turkish Airlines', 'TAP Portugal', 'Air France', 'Aeroflot', 'Pegasus Airlines', 'Wizz Air', 'Eurowings', 'Virgin Atlantic', 'Norwegian Air']
used_airlines_urls = ['https://www.ryanair.com','https://www.lufthansa.com/online/portal/lh_com/de/homepage','https://www.klm.com/','https://www.easyjet.com/','https://www.turkishairlines.com/','https://www.flytap.com/','https://www.airfrance.com/','https://www.aeroflot.ru/xx-en?_preferredLocale=xx&_preferredLanguage=en','https://www.flypgs.com/','https://wizzair.com/','https://www.eurowings.com/','https://www.virginatlantic.com/','https://www.norwegian.com/']
counter = 0
used_airlines.each do |airline|
  airline_update = Airline.where(name: airline).first
  airline_update.url = used_airlines_urls[counter]
  airline_update.save
  counter += 1
end


# ++++ END OF SEED ++++ #
puts "You have just been seeded Duuuude."
