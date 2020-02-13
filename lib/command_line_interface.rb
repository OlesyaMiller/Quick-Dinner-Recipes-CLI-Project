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
        puts "To see the list of all recipes, enter 'recipes'"
        puts "To seach recipes by diet, enter 'search by diet'"
        puts "To search recipes by preparation time, enter 'search by prep time'"
        puts "To exit the app at any time, type 'exit'"
        puts "To start over at any time, type 'start over'"
        puts ""
    end

    def display_recipes
        Recipe.all.each.with_index(1) { |recipe, index| puts "#{index}. #{recipe.title}" }
        puts ""
    end

    def interaction_with_user
        input = nil 
        while input != "exit"
            input = gets.chomp 
            if input.downcase == "recipes"
                puts ""
                puts "To see recipe info, enter recipe number"
                puts ""
                display_recipes
                find_recipe_by_number
            elsif input.downcase == "search by diet"
                list_recipes_by_diet
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
                puts "** #{selected_recipe.title} **"
                puts "Author: #{selected_recipe.author}"
                puts "Prep time: #{selected_recipe.prep_time}"
                if selected_recipe.food_type != nil 
                    puts "Diet: #{selected_recipe.food_type}"
                    puts ""
                end
                puts ""
                puts "#{selected_recipe.info}"
            elsif input.downcase == "exit"
                exit_app 
            elsif input.downcase == "start over"
                start_over
            else
                enter_correct_input
            end
        end
    end

    def list_recipes_by_diet
        puts ""
        puts "Please enter the name of a diet from the following: gluten-free, healthy, low carb, vegetarian, paleo"
        puts ""
            input = gets.chomp 
            if input.downcase == "healthy" || input.downcase == "gluten-free" || input.downcase == "low carb" || input.downcase == "paleo" || input.downcase == "vegetarian"
                @selected_recipes = Recipe.all.select do |recipe|
                    recipe.food_type != nil && recipe.food_type.downcase.include?(input.downcase)
                end
                @selected_recipes.each.with_index(1) do |selected_recipe, index|
                    puts "" 
                    puts "#{index}. #{selected_recipe.title}"
                end
                # puts ""
                # puts "To see recipe info, enter recipe number"
                # puts "Enter a differnet diet name...."
                recipe_by_diet_info
           
            elsif input.downcase == "exit"
                exit_app
            elsif input.downcase == "start over"
                start_over
            else
                enter_correct_input
                list_recipes_by_diet
            end
    end

    def recipe_by_diet_info
        puts ""
        puts "To see recipe info, enter recipe number"
        puts "Enter a differnet diet name...."
        
            input = gets.chomp 
            
            if (1..@selected_recipes.length).include?(input.to_i)
                recipe = @selected_recipes[input.to_i - 1]
                puts ""
                puts "** #{recipe.title.upcase} **"
                puts "Author: #{recipe.author}"
                puts "Prep time: #{recipe.prep_time}"
                puts "Diet: #{recipe.food_type}"
                puts ""
                puts "#{recipe.info}"
                puts ""
                # puts "To exit the app, type 'exit'"
                # puts "To start over, type 'start over'"
                # puts ""
                recipe_by_diet_info
            elsif input.downcase == "exit"
                exit_app
            elsif input.downcase == "start over"
                start_over
            elsif input.downcase == "healthy" || input.downcase == "gluten-free" || input.downcase == "low carb" || input.downcase == "paleo" || input.downcase == "vegetarian"
                @selected_recipes = Recipe.all.select do |recipe|
                    recipe.food_type != nil && recipe.food_type.downcase.include?(input.downcase)
                end
                @selected_recipes.each.with_index(1) do |selected_recipe, index|
                    puts "" 
                    puts "#{index}. #{selected_recipe.title}"
                end
                recipe_by_diet_info
            else
                enter_correct_input
                recipe_by_diet_info
            end
    end

    def recipe_by_prep_time_info
        puts ""
        puts "To see recipe info, enter recipe number"
        
        input = nil 
        while input != "exit"
            input = gets.chomp 
            
            if (1..@selected_recipes_by_prep_time.length).include?(input.to_i)
                recipe = @selected_recipes_by_prep_time[input.to_i - 1]
                puts ""
                puts "** #{recipe.title.upcase} **"
                puts "Author: #{recipe.author}"
                puts "Prep time: #{recipe.prep_time}"
                if recipe.food_type != nil 
                    puts "Diet: #{recipe.food_type}"
                end
                puts ""
                puts "#{recipe.info}"
                puts ""
                puts "To exit the app, type 'exit'"
                puts "To start over, type 'start over'"
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

    def list_recipes_by_prep_time
        prep_times = Recipe.all.map { |recipe| recipe.prep_time.split(" ")[0].to_i }
        # NO MAGIC NUMBERS!!!
        puts "All the recipes take under #{prep_times.max} minutes to cook. The quickest recipe is #{prep_times.min} minutes. How much time do you have?"
        puts ""
        input = nil 
        while input != "exit"
            input = gets.chomp 
            if input.to_i >= prep_times.min  
                @selected_recipes_by_prep_time = Recipe.all.select { |recipe| recipe.prep_time.split(" ")[0].to_i <= input.to_i }
                @selected_recipes_by_prep_time.each.with_index(1) do |selected_recipe, index|
                    puts "#{index}. #{selected_recipe.title}"
                    puts ""
                end
                recipe_by_prep_time_info
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