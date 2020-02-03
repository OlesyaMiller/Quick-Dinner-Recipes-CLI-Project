require_relative "../lib/scraper.rb"
require_relative "../lib/recipe.rb"
require 'nokogiri'
require 'pry'
require 'httparty'

class CommandLineInterface

    def run
        make_recipes
        greeting
        interaction_with_user
    end

    def make_recipes
        recipes_array = Scraper.scrape_page
        Recipe.create_from_collection(recipes_array)
    end

    def greeting
        puts "Welcome to Quick Dinner Recipes app!"
        puts "To exit the app at any time, type 'exit'"
        puts "To start over at any time, type 'start over'"
        puts "To see the list of recipes, enter 'recipes'"
        puts "To seach by food type, enter 'search by food type'"
        puts "To search by prep time, enter 'search by prep time'"
        puts ""
    end

    def display_recipes
        Recipe.all.each.with_index(1) {|recipe, index| puts "#{index}. #{recipe.title}"}
    end

    def interaction_with_user
        input = nil 
        while input != "exit"
            input = gets.chomp 
            if input == "recipes"
                puts ""
                puts "To see recipe info, type in recipe number"
                puts ""
                display_recipes
                find_recipe_by_number
            elsif input == "search by food type"
                list_recipes_by_food_type
            elsif input == "search by prep time"
                list_recipes_by_prep_time
            elsif input == "exit"
                exit
            elsif input == "start over"
                run 
            else
                puts "Enter correct input"
            end
        end
    end

    def go_back_to_recipes_list

    end

    def find_recipe_by_number
        input = nil 
        while input != "exit"
            input = gets.chomp 

            if (1..Recipe.all.length).include?(input.to_i)
                selected_recipe = Recipe.all[input.to_i - 1]
                puts "#{selected_recipe.info}"
                puts ""
                puts "Author: #{selected_recipe.author}"
                puts "Prep time: #{selected_recipe.prep_time}"
                if selected_recipe.food_type != nil 
                    puts "Food type: #{selected_recipe.food_type}"
                end
            elsif input == "exit"
                puts "Goodbye!"
                exit 
            elsif input == "start over"
                run 
            else
                puts "Enter a valid number"
            end
        end
    end

    def list_recipes_by_food_type
        puts "Please enter the name of a food type from the following: gluten-free, healthy, low carb, vegetarian, paleo"
        puts "To start over, type 'start over', to exit, type 'exit'"
        input = nil 
        while input != "exit"
            input = gets.chomp 
            Recipe.all.each do |recipe|
                if recipe.food_type != nil && recipe.food_type.downcase.include?(input)
                    puts "#{recipe.title}"
                    puts "Author: #{recipe.author}"
                    puts "Prep time: #{recipe.prep_time}"
                    puts "Food type: #{recipe.food_type}"
                    puts ""
                    puts "#{recipe.info}"
                    puts ""
                end
            end
            if input == "exit"
                exit 
            end
        end
    end

    def list_recipes_by_prep_time
        puts "All the recipes take under 45 minutes to cook. How much time do you have?(enter a number equal to or smaller than 45)"
        
        input = nil 
        while input != "exit"
            input = gets.chomp 
            if input.to_i.integer?
                Recipe.all.each do |recipe|
                    if recipe.prep_time.split(" ")[0].to_i <= input.to_i  
                        puts "#{recipe.title}"
                        puts "Author: #{recipe.author}"
                        puts "Prep time: #{recipe.prep_time}"
                        if recipe.food_type != nil 
                            puts "Food type: #{recipe.food_type}"
                        end
                        puts ""
                        puts "#{recipe.info}"
                        puts ""
                    end
                end
            elsif input == "exit"
                exit 
            else
                puts "Enter correct input"
            end
        end
    end

end