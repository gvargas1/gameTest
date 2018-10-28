# The program runs a short and simple game that allows
# the user (Player) to create a character and choose from
# 3 different classes. The core of the game is to fight
# enemies in a turn-base battle system. Elements of battle
# system include Attacking, using an Item, Defending,
# and Fleeing.
#
# Author:: George Vargas
# Copyright:: None
# License:: Distibutes under the same terms as Ruby

# This class holds the basics of the Player and Enemy, like
# attacking and the stats of the character.
class Fighter 
    #getter and setter
    attr_accessor :name, :type, :health, :power, :speed

    # Initial create character, must have the name, the type,
    # health, power, and speed.
    def self.my_new (*args, &block)
        instance = allocate
        instance.my_init(*args, &block)
        instance
    end
    # Class to create enemies ONLY
    def my_init (*args)
        @name = args[0]
        @type = args[1].downcase.capitalize
        @health = args[2]
        @power = args[3]
        @speed = args[4]
    end

    # Outputs the charcter's stats
    def stats
        puts "#{name}'s Stats"
        puts "-----------------"
        puts "Health: #{health}"
        puts "Type: #{type}"
        puts "Power: #{power}"
        puts "Speed: #{speed}"
    end

    # Basic attack system. Don't judge me, I'm not a game developer.
    def attack(thing)
        thing.health-=@power
    end
end


# This class holds methods that are only avaliable to the 
# player. 
class Player < Fighter
    # getter and setter, powerO is the original power before the battle
    # began. After the battle finishes the @power of the player will be
    # changed to @powerO(ld).
    attr_accessor :powerO, :item
    def self.my_new (*args, &block)
        super
    end
    # Class to create the player.
    def my_init (*args)
        @name = args[0]
        @type = args[1].downcase.capitalize
        @health = args[2]
        @power = args[3]
        @speed = args[4]
        @item = []
    end
    
    # Give the player more power depending on what the player's class is.
    # At the end of the fight the power will return to normal.
    def powerUp
        @powerO = power
        if @type == "A"
            @power+=(power*3)
        elsif @type == "D"
            @power+=(power*1)
        elsif @type == "S" 
            @power+=(power*2)
        end
    end

    # Displays all items the player has.
    def displayItems 
        longestWord = 0
        if item.length == 0
            puts "************************"
            puts "*  You have no items!  *"
            puts "************************"
        else
            for i in 0...item.length
                if item[i].length > longestWord
                    longestWord = item[i].length
                end
            end
            order = 1
            #First line of *
            for i in 0...longestWord+9
                print "*"
            end
            print "\n"
            for x in 0...item.length
                extraSpace = (longestWord-item[order-1].length) + 8
                for t in 0...extraSpace
                    #For now have spaces
                    if (t <= 2) 
                        if t == 0
                            print "*"
                        else
                            print " "
                        end
                    elsif t == 3
                        print "#{order}. "
                    elsif t == 4
                        print item[order-1]
                        order+=1
                    else
                        if t == extraSpace-1
                            print "*"
                            if x != item.length-1
                                print "\n"
                            end
                        else
                            print " "
                        end
                    end
                end
            end
            #Last line of *
            print "\n"
            for i in 0...longestWord+9
                print "*"
            end
            print "\n"
        end
    end

    # Change back original power.
    def revertBack
        @power = @powerO
    end
end

# This class holds method only available to the Enemy.
class Enemy < Fighter
end

# This class hold the framework for the battle system.
class Turn
    attr_accessor :first, :second, :end
    def initialize(p1, p2)
        @end = false
        if p1.speed >= p2.speed
            @first = p1
            @second = p2
        else
            @first = p2
            @second = p1
        end
    end

    #
    def menu(player, enemy) 
        while @end == false
            puts "******************"
            puts "*    1. Attack   *"
            puts "*    2. Item     *"
            puts "*    3. Heal     *"
            puts "*    4. Flee     *"
            puts "******************"
            action = 0
            loop do
                print "What action would you like to take? "
                action = gets.chomp.to_i
                if (action == 1) || (action == 2) || (action == 3) || (action == 4)
                    break
                end
            end
            if action == 1
                fight
                if enemy.health <= 0
                    @end == true
                end
            elsif action == 2
                player.displayItems
            elsif action == 3
                player.health+=5
                print "You've healed for 5 health points!\n"
            else #action == 4
                if Random.new.rand > 0.5
                    print "you have successfully flee.\n"
                else
                    print "You could not flee.\n"
                end
            end
            @end = true
        end
    end

    #
    def fight
        puts @first.name
        puts @second.name
        puts "------------------"
        while true
            puts "Second Health: #{@second.health}"
            @first.attack(@second)
            puts "Second Health: #{@second.health}"
            if @second.health <= 0
                puts "1 won!"
                break
            end
            puts "First Health: #{@first.health}"
            @second.attack(@first)
            puts "First Health: #{@first.health}"
            if @first.health <= 0
                puts "2 won!"
                break
            end
        end
    end
end   

line = Array.new(5) { Array.new(10) }

##############################################################################################################
##############################################################################################################

puts "Welcome!"
puts "Please create your character!"
print "Enter your player's name: "
name = gets.chomp
type = ""
loop do
    print "Are you a Warrior, Tank, or Rogue? "
    type = gets.chomp
    if (type.downcase.eql?("warrior")) || (type.downcase.eql?("tank")) || (type.downcase.eql?("rogue"))
        break
    end
end

puts".##......######..######...####............####...######...####...#####...######....##."
puts".##......##........##....##..............##........##....##..##..##..##....##......##."
puts".##......####......##.....####............####.....##....######..#####.....##......##."
puts".##......##........##........##..............##....##....##..##..##..##....##........."
puts".######..######....##.....####............####.....##....##..##..##..##....##......##."

player = Player.my_new(name, type, 100, 10, 10)
enemy = Enemy.my_new("Slime", "Enemy", 50, 1, 1)
player.stats
player.displayItems
Turn.new(player, enemy).menu(player, enemy)

