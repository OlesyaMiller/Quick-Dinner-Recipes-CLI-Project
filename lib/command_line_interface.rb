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
        puts ""
        puts "WELCOME TO QUICK DINNER RECIPES APP!"
        puts ""
        puts "To exit the app at any time, type 'exit'"
        puts "To start over at any time, type 'start over'"
        puts "To see the list of recipes, enter 'recipes'"
        puts "To seach recipes by food type, enter 'search by food type'"
        puts "To search recipes by prep time, enter 'search by prep time'"
        puts ""
    end

    def display_recipes
        Recipe.all.each.with_index(1) {|recipe, index| puts "#{index}. #{recipe.title}"}
        puts ""
    end

    def interaction_with_user
        input = nil 
        while input != "exit"
            input = gets.chomp 
            if input.downcase == "recipes"
                puts ""
                puts "To see recipe info, type recipe number"
                puts ""
                display_recipes
                find_recipe_by_number
            elsif input.downcase == "search by food type"
                list_recipes_by_food_type
            elsif input.downcase == "search by prep time"
                list_recipes_by_prep_time
            elsif input.downcase == "exit"
                exit_app 
            else
                enter_correct_input
            end
        end
    end

    def start_over
        puts ""
        greeting
        interaction_with_user
        puts ""
    end

    def exit_app 
        puts "Goodbye!"
        sleep(1)
        exit
    end

    def enter_correct_input
        puts ""
        puts "Enter correct input"
        puts ""
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
                puts ""
            elsif input.downcase == "exit"
                exit_app 
            elsif input.downcase == "start over"
                start_over
            else
                enter_correct_input
            end
        end
    end

    def list_recipes_by_food_type
        puts ""
        puts "Please enter the name of a food type from the following: gluten-free, healthy, low carb, vegetarian, paleo"
        puts ""
        input = nil 
        while input != "exit"
            input = gets.chomp 
            if input.downcase == "healthy" || input.downcase == "gluten-free" || input.downcase == "low carb" || input.downcase == "paleo" || input.downcase == "vegetarian"
                Recipe.all.each do |recipe|
                    if recipe.food_type != nil && recipe.food_type.downcase.include?(input.downcase)
                        puts "#{recipe.title}"
                        puts "Author: #{recipe.author}"
                        puts "Prep time: #{recipe.prep_time}"
                        puts "Food type: #{recipe.food_type}"
                        puts ""
                        puts "#{recipe.info}"
                        puts ""
                    end
                end
            elsif input.downcase == "exit"
                exit_app
            elsif input.downcase == "start over"
                start_over
            else
                enter_correct_input
            end
        end
    end

    def list_recipes_by_prep_time
        prep_times = Recipe.all.map { |recipe| recipe.prep_time.split(" ")[0].to_i }
        puts "All the recipes take under #{prep_times.max} minutes to cook. The quickest recipes is #{prep_times.min} minutes. How much time do you have?"
        puts ""
        input = nil 
        while input != "exit"
            input = gets.chomp 
            if input.to_i >= prep_times.min  
                Recipe.all.each do |recipe|
                    if recipe.prep_time.split(" ")[0].to_i <= input.to_i  
                        puts ""
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
            elsif input.downcase == "start over"
                start_over
            elsif input.downcase == "exit"
                exit_app
            else
                enter_correct_input
            end
        end
    end
end