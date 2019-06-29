# SOFTWARE ENGINEERING ACADEMY
# COMPFEST - GOJEK
# Second Stage Assignment 

def welcome
    print "=========Hi, Welcome to GO-EAT APP========= \nLet me know your name (type your name below)\n-> "
    $name = gets.chomp
end

class Restaurant
    attr_accessor :name, :nick, :menu, :x_pos, :y_pos

    def initialize(name, nick, x_pos, y_pos)
        @name = name
        @nick = nick
        @menu = {}
        @x_pos = x_pos
        @y_pos = y_pos
    end

    #Define generate location method
    def generate_location(map)
        #Generate coordinate in map
        map[@x_pos][@y_pos] = @nick
        map
    end
end

class Map 
    attr_accessor :map, :map_row, :map_col

    #Define initialize map method
    def initialize(row=20, col=20)
        @map_row = row
        @map_col = col
        map = Array.new(row+2) { Array.new(col+2) {' . '} }
        for i in 0..(row+1)
            for j in 0..(col+1)
                if (j==0 || j==(col+1))
                    map[i][j] = '|'
                elsif(i==0 || i==(row+1)) 
                    map[i][j] = '---'
                end
            end
        end
        @map = map
        map
    end

    #Define show map method
    def show_map(map=@map)
        system('cls')
        puts "SATRIA VILLAGE MAP"
        puts "\n"
        for i in 0..(map.size-1)
            for j in 0..(map.size-1)
                print map[i][j]
            end
            print "\n"
        end
    end
end

class User
    attr_accessor :name, :x_pos, :y_pos, :user_cart, :user_history

    def initialize(name, x_pos, y_pos)
        @name = name
        @x_pos = x_pos
        @y_pos = y_pos
        @user_cart = []
        @user_history = []
    end

    #Generate user coordinate
    def generate_location(map)
        map[@x_pos][@y_pos] = "YOU"
        map
    end

    #Define User to Restaurant distance
    def resto_distance(resto)
        distance = (resto.x_pos - @x_pos).abs + (resto.y_pos - @y_pos).abs
        distance
    end
end

class Driver
    attr_accessor :name, :x_axis, :y_axis, :average_rating, :trip
    @@routes_taken = []

    #Define initialize
    def initialize(name,x_axis,y_axis)
        @name = name
        @x_axis = x_axis
        @y_axis = y_axis
        @average_rating = 0
        @trip = 0
        @rating = []
    end

    # #Define generate location method
    def generate_location(map)
        map[@x_axis][@y_axis] = @name
        map
    end

    #Routes_taken
    def self.routes_taken
        @@routes_taken
    end

    #Routes taken by driver
    def take_route(resto, user, map)

        #Create validation from the coordinate function
        def valid(a,v,r,c)
            output = r>=0 && r < a.size && c>=0 && c < a.size && a[r][c] && (v[r][c] == 0)
            output
        end

        #Initialize empty array for BFS Method
        routes = []

        #Initialize core map and size
        a = map[0..map.size-1][0..map.size-1]
        n = a.size
        m = a.size

        #Create r and c arrays which are used to access the adjacent elements
        r = [1,-1,0,0]
        c = [0,0,1,-1]

        #Create source and destination coordinate
        sx = @x_axis
        sy = @y_axis

        dx = resto.x_pos
        dy = resto.y_pos

        #To the resto
        #Create array as queue for BFS
        q = []

        #Create an matrix to store wheter the node is visited or not
        v = Array.new(n) { Array.new(m,0) }

        #Mark the starting point as visited
        v[sx][sy] = 1

        #Push the starting point to the queue with distance 0
        q.push([sx,sy,0])

        #Initialize min_dist variable to a maximum value
        min_dist = 1<<64

        #While queue q is not empty dequeue the starting node in the queue
        while (q != nil) do
            #Pop the node
            tq = q.shift

            #Insert the coordinate that taken to the array
            routes << [tq[0],tq[1],tq[2]]

            #If the current position same with the destination break
            if tq[0] == dx && tq[1] == dy
                min_dist = tq[2]
                break
            end

            #Push the adjacent elements into the queue and repeat the process
            for k in 0...4
                if valid(a,v,tq[0]+r[k],tq[1]+c[k])
                    v[tq[0]+r[k]][tq[1]+c[k]] = 1
                    q.push([tq[0]+r[k],tq[1]+c[k],tq[2]+1])
                end
            end
        end

        #Create all needed array
        routes_taken = []
        routes = routes.reverse
        parent = [dx,dy,min_dist]

        #Save the routes taken to the array
        for i in 0..routes.size-1
            if routes[i][2] == parent[2]-1 && (routes[i][0] == parent[0]-1 || routes[i][0] == parent[0]+1 || routes[i][0] == parent[0]) && (routes[i][1] == parent[1]-1 || routes[i][1] == parent[1]+1 || routes[i][1] == parent[1])
                routes_taken << [routes[i][0],routes[i][1]]
                parent = [routes[i][0],routes[i][1],routes[i][2]]
            end
        end

        #Print the information of the routes taken
        resto_taken_routes = []
        routes_taken.reverse.each do |route|
            if route[0] == sx && route[1] == sy
                puts "Driver is on the way to the restaurant, start at (#{route[0]},#{route[1]})"
            else
                puts "go to (#{route[0]},#{route[1]})"
            end
            resto_taken_routes << [route[0],route[1]]
        end
        puts "go to (#{dx},#{dy}), Driver arrived at the restaurant!"
        resto_taken_routes << [dx,dy]

        #To the user
        routes = []

        a = map[0..map.size-1][0..map.size-1]
        n = a.size
        m = a.size
        
        r = [1,-1,0,0]
        c = [0,0,1,-1]

        sx = resto.x_pos
        sy = resto.y_pos

        dx = user.x_pos
        dy = user.y_pos

        q = []

        v = Array.new(n) { Array.new(m,0) }
        v[sx][sy] = 1

        q.push([sx,sy,0])

        min_dist = 1<<64

        while (q != nil) do
            tq = q.shift

            routes << [tq[0],tq[1],tq[2]]

            if tq[0] == dx && tq[1] == dy
                min_dist = tq[2]
                break
            end

            for k in 0...4
                if valid(a,v,tq[0]+r[k],tq[1]+c[k])
                    v[tq[0]+r[k]][tq[1]+c[k]] = 1
                    q.push([tq[0]+r[k],tq[1]+c[k],tq[2]+1])
                end
            end
        end

        routes_taken = []
        routes = routes.reverse
        parent = [dx,dy,min_dist]

        for i in 0..routes.size-1
            if routes[i][2] == parent[2]-1 && (routes[i][0] == parent[0]-1 || routes[i][0] == parent[0]+1 || routes[i][0] == parent[0]) && (routes[i][1] == parent[1]-1 || routes[i][1] == parent[1]+1 || routes[i][1] == parent[1])
                routes_taken << [routes[i][0],routes[i][1]]
                parent = [routes[i][0],routes[i][1],routes[i][2]]
            end
        end

        user_taken_routes = []
        routes_taken.reverse.each do |route|
            if route[0] == sx && route[1] == sy
                puts "\nDriver has bought the item(s), start at (#{route[0]},#{route[1]})"
            else
                puts "go to (#{route[0]},#{route[1]})"
            end
            user_taken_routes << [route[0],route[1]]
        end
        puts "go to (#{dx},#{dy}), Driver arrived at your place!"
        user_taken_routes << [dx,dy]

        all_routes_taken = {"To Restaurant" => resto_taken_routes, "To user" => user_taken_routes}
        @@routes_taken << all_routes_taken
        @@routes_taken
    end

    #Get rating from user
    def get_rating(rate)
        @rating << rate
        @trip += 1
        @average_rating = @rating.sum / @rating.size
        puts "\n===Thank you==="
        puts "\n"
        @average_rating
    end  
end

#Enter Menu 2 (ORDER FOOD)
def choose_resto
    system("cls")

    #USER CHOOSE RESTAURANT
    puts "Where restaurant do you choose to buy some food? "
    print "(type the number of menu below)\n"
    puts "\n(1) #{$resto1.name} Restaurant"
    puts "\n(2) #{$resto2.name} Restaurant"
    puts "\n(3) #{$resto3.name} Restaurant"
    print "\nChoice : "
    $choice = gets.chomp.to_i
    if $choice == 1 
        $resto_choice = $resto1
    elsif $choice == 2
        $resto_choice = $resto2
    elsif $choice == 3
        $resto_choice = $resto3
    end
end

    #SHOW LIST OF MENU
def choose_food(resto_choice, distance)
    i=1
    print "\nYou choose #{resto_choice.name} Restaurant and the distance to your place is [#{distance}]\n"
    print "\nFood Menu, #{resto_choice.name} Restaurant \n(Menu => Price)\n"
    resto_choice.menu.each do |food, price|
       print "   (#{i}) #{food} => #{price}\n"
        i+=1
    end 

    #USER CHOOSE FOOD + AMOUNT of FOOD
    print "\nType the food that you want below, followed by '|' and the amount of food\n"
    print "(example : Nasi Pecel|2) or (type 0 to choose another restaurant)\n`-> "
    user_order = gets.chomp

    if user_order == "0"
        choose_resto
    else   
        order = user_order.split("|")
        $food = order[0]
    end

    if $resto_choice.menu.has_key?("#{$food}")
        $amount = order[1].to_i
        $price = resto_choice.menu.values_at("#{$food}")
        $est_price = $price[0] * $amount
    else
        system('cls')
        puts "Your choice not available on menu, choose the food on menu"
        choose_food(resto_choice, distance)
    end
    
end
    #Assign User Cart
def create_cart(distance)
    @user_cart = ["#{$food}", $amount, $est_price, 1000*distance]
    puts "\nUser Cart\n`-> Food (#{@user_cart[0]})| Amount (#{@user_cart[1]}) | Est. Price (#{@user_cart[2]}) | Delivery Fee (#{@user_cart[3]})"
    print "\n(1)Get the driver? \n(2)Add other food to cart \nChoose : "
    answer = gets.chomp.to_i
    if answer == 1
        order = []
        order << @user_cart
        puts "\nSearching the Driver..."
    else
        puts "\nAdd to cart option still un-available\n"
        puts "\nSearching the Driver..."
        order = []
        order << @user_cart
    end
    order
end

    #Get the Driver
def get_driver(drivers, resto)
    distance = []
    drivers.each do |driver|
        distance << (driver.x_axis - resto.x_pos).abs + (driver.y_axis - resto.y_pos).abs
    end
    nearest_driver = drivers[distance.index(distance.min)]
    print "Driver Found!\n\n"
    nearest_driver
end

    #Generate total cost of the user's order
def get_total_cost(orders)
        total_cost = 0
        orders.each do |order|
            total_cost += order[2] + order[3]
        end
        total_cost
end

    #Get Order Information
def get_order_information(user, resto, driver, distance, cart, total_cost)
    order = []
    order << driver.name << resto.name << cart << total_cost 
    puts "ORDER REVIEW: "
    puts "Your choosen resto is #{resto.name} and the location is [#{resto.x_pos}][#{resto.y_pos}]"
    puts "Your location is [#{user.x_pos}][#{user.y_pos}] and distance to the store is #{distance}"
    puts "Your driver name is #{driver.name} with rating #{'%.2f' %driver.average_rating} and the location is [#{driver.x_axis}][#{driver.y_axis}]"
    puts "Your order:"
    cart.each do |item|
        puts "`-> Food (#{item[0]}) |Amount (#{item[1]}) |Price (#{item[2]}) |Delivery Fee (#{item[3]})"
    end
    puts "\nTOTAL COST: Rp.#{total_cost},-"
    order
end

    #Ask user to finish order
def finish_order
        print "\nFinish the order? (type Y to finish order / type N to cancel order) \n`-> "
        answer = gets.chomp
        if answer.capitalize == "Y"
            output = true
        elsif answer.capitalize == "N"
            output = false
        end
        puts"\n"
        output
end

    #Give rating to the driver
def give_rating (cart)
     puts "\nPlease give rating to our driver: (0.0 - 5.0)"
     print "`-> "
    rating = gets.chomp.to_f
    while rating < 0 || rating > 5.0
        puts "Please give valid rating from 0.0 - 5.0"
        print "`-> "
        rating = gets.chomp.to_f
    end
    rating
end

#Enter Menu 3 (VIEW HISTORY)
def view_history(order_history)
    system("cls")
    index = 1
    if order_history == []
        puts "USER ORDER HISTORY is Empty \nYou never order something \n\nTry to order NOW!"
    else
        puts "USER ORDER HISTORY"
        puts "\n"
        order_history.each do |item|
            print "`-> [##{index}] Driver (#{item[0]}) |Restaurant (#{item[1]}) "
            item[2].each do |cart|
                print "|Food (#{cart[0]}) |Amount (#{cart[1]}) |Price (#{cart[2]}) |Delivery Fee (#{cart[3]})"
            end
            puts "\n    |TOTAL COST : Rp.#{item[3]},-"
            index += 1
        end
    end
end 

#Define Map
map = Map.new()
map_row = map.map_row
map_col = map.map_col
apps_map = map.map

#Define User
user = User.new($name, rand(1..map_row), rand(1..map_col))
apps_map = user.generate_location(apps_map)

#Define Restaurant
$resto1 = Restaurant.new("Javanese Food", "#JF", rand(1..map_row), rand(1..map_col))
$resto1.menu = {"Nasi Pecel" =>5000, "Nasi Gandul" =>8000, "Lontong Kari" =>10000}
$resto2 = Restaurant.new("Sundanese Food", "#SF", rand(1..map_row), rand(1..map_col))
$resto2.menu = {"Nasi Oncom" =>5000, "Nasi Liwet" =>8000, "Kupat Tahu" =>10000}
$resto3 = Restaurant.new("Balinese Food", "#BF", rand(1..map_row), rand(1..map_col))
$resto3.menu = {"Ayam Betutu" =>5000, "Nasi Jinggo" =>8000, "Nasi Tepeng" =>10000}
resto = [$resto1, $resto2, $resto3]

def generate_resto_location(resto, map)
    resto.each do |resto|
        map = resto.generate_location(map)
    end
    map
end
apps_map = generate_resto_location(resto, apps_map)

#Define Driver
$D1 = Driver.new("Agus", rand(1..map_row),rand(1..map_col))
$D2 = Driver.new("Bayu", rand(1..map_row),rand(1..map_col))
$D3 = Driver.new("Caka", rand(1..map_row),rand(1..map_col))
$D4 = Driver.new("Doni", rand(1..map_row),rand(1..map_col))
$D5 = Driver.new("Eman", rand(1..map_row),rand(1..map_col))
drivers = [$D1, $D2, $D3, $D4, $D5]

def generate_driver_location(drivers, map)
    drivers.each do |driver|
        map = driver.generate_location(map)
    end
    map
end
apps_map = generate_driver_location(drivers, apps_map)

#MAIN APPLICATION
welcome
$order_history = []
$idx = 0
puts "\n"

exit = false
while exit != true
    puts "Hello #{$name}, How can I help you? \n(type the number of menu below)"
    print "\n[1] SHOW YOUR LOCATION \n[2] ORDER FOOD \n[3] VIEW HISTORY \n[0] EXIT \n\nChoose : "
    choice = gets.to_f
    case (choice)
    #SHOW MAP
    when 1
        map.show_map
        print "(Press any key to continue...)"
        gets.chomp
        system('cls')
    #ORDER FOOD
    when 2
        choose_resto
        resto_choice = $resto_choice
        distance = user.resto_distance(resto_choice)
        choose_food(resto_choice, distance)
        cart = create_cart(distance)
        total_cost = get_total_cost(cart)
        driver_choice = get_driver(drivers, resto_choice)
        order_info = []
        order_info = get_order_information(user, resto_choice, driver_choice, distance, cart, total_cost)

        #CONFIRM ORDER
        confirm_order = finish_order
        if confirm_order == true 
            #DELIVER FOOD
            routes_taken = driver_choice.take_route(resto_choice,user,apps_map)
            given_rating = give_rating (cart)
            driver_rating = driver_choice.get_rating(given_rating)

            #INSERT TO HISTORY
            $order_history[$idx] = order_info
            $idx += 1
            print "(Press any key to continue)"
            gets.chomp
            system('cls')
        #CANCEL ORDER
        else
            cart.clear
            system('cls')
        end
    #VIEW HISTORY
    when 3
        view_history($order_history)
        print "\n(Press any key to continue...)"
        gets.chomp
        system('cls')
    #EXIT
    when 0
        exit = true
    end
end