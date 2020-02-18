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
        Recipe.all.each.with_index(1) do |recipe, index| 
            puts "#{index}. #{recipe.title}" 
            puts ""
        end
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

    def find_recipe_by_number
        input = gets.chomp 
        if (1..Recipe.all.length).include?(input.to_i)
            recipe = Recipe.all[input.to_i - 1]
            recipe_information(recipe)
            puts ""
            puts "Enter recipe number to see another recipe"
            puts ""
            find_recipe_by_number
        elsif input.downcase == "exit"
            exit_app 
        elsif input.downcase == "start over"
            start_over
        else
            enter_correct_input
            find_recipe_by_number
        end
    end

# FILTERING BY DIET METHODS ------------------------------------------------------------------------

    def list_recipes_by_diet
        puts ""
        puts "Please enter the name of a diet from the following: gluten-free, healthy, low carb, vegetarian, paleo"
        puts ""

        input = gets.chomp 
        if input.downcase == "healthy" || input.downcase == "gluten-free" || input.downcase == "low carb" || input.downcase == "paleo" || input.downcase == "vegetarian"
            list_recipes_by_diet_helper_method(input)
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
        puts "To keep browsing, enter a different diet name"
        puts "To see recipe info, enter recipe number"
        puts ""
        
        input = gets.chomp 
        
        if (1..@selected_recipes.length).include?(input.to_i)
            recipe = @selected_recipes[input.to_i - 1]
            recipe_information(recipe)
            last_level_method_for_diet
        elsif input.downcase == "exit"
            exit_app
        elsif input.downcase == "start over"
            start_over
        elsif input.downcase == "healthy" || input.downcase == "gluten-free" || input.downcase == "low carb" || input.downcase == "paleo" || input.downcase == "vegetarian"
            list_recipes_by_diet_helper_method(input)
        else
            enter_correct_input
            recipe_by_diet_info
        end
    end

    def list_recipes_by_diet_helper_method(input)
        @selected_recipes = Recipe.all.select do |recipe|
            recipe.food_type != nil && recipe.food_type.downcase.include?(input.downcase)
        end
        @selected_recipes.each.with_index(1) do |selected_recipe, index|
            puts "" 
            puts "#{index}. #{selected_recipe.title}"
        end
        recipe_by_diet_info
    end

    def last_level_method_for_diet
        puts "To look up another recipe, enter recipe number" 
        puts ""
        input = gets.chomp 
            
        if (1..@selected_recipes.length).include?(input.to_i)
            recipe = @selected_recipes[input.to_i - 1]
            recipe_information(recipe)
            last_level_method_for_diet
        elsif input.downcase == "exit"
            exit_app
        elsif input.downcase == "start over"
            start_over    
        else
            enter_correct_input
            last_level_method_for_diet
        end    
    end

# FILTERING BY PREP TIME METHODS ---------------------------------------------------------------------    

    def list_recipes_by_prep_time
        @prep_times = Recipe.all.map { |recipe| recipe.prep_time.split(" ")[0].to_i }
        # NO MAGIC NUMBERS!!!
        puts ""
        puts "All the recipes take under #{@prep_times.max} minutes to cook. The quickest recipe is #{@prep_times.min} minutes. How much time do you have? (please enter a number followed by 'min' with a space in between, like this: 10 min)"
        puts ""
        input = gets.chomp 
        if input.split(" ")[0].to_i >= @prep_times.min && input.include?(" min")
            list_recipes_by_prep_time_helper_method(input)
            recipe_by_prep_time_info
        elsif input.downcase == "start over"
            start_over
        elsif input.downcase == "exit"
            exit_app
        else
            enter_correct_input
            list_recipes_by_prep_time
        end
    end

    def recipe_by_prep_time_info
        puts ""
        puts "To see recipe info, enter recipe number"
        puts "To keep browsing, enter how much time you have"
        puts ""
        
        input = gets.chomp 
        
        if (1..@selected_recipes_by_prep_time.length).include?(input.to_i) && !input.include?("min")
            recipe = @selected_recipes_by_prep_time[input.to_i - 1]
            recipe_information(recipe)
            last_level_method_for_prep_time
        elsif input.downcase == "exit"
            exit_app
        elsif input.downcase == "start over"
            start_over
        elsif input.split(" ")[0].to_i >= @prep_times.min && input.include?(" min") 
            list_recipes_by_prep_time_helper_method(input)
        else
            enter_correct_input
            recipe_by_prep_time_info
        end
    end

    def list_recipes_by_prep_time_helper_method(input)
        @selected_recipes_by_prep_time = Recipe.all.select { |recipe| recipe.prep_time.split(" ")[0].to_i <= input.split(" ")[0].to_i }
        @selected_recipes_by_prep_time.each.with_index(1) do |selected_recipe, index|
            puts "#{index}. #{selected_recipe.title}"
            puts ""
        end
        recipe_by_prep_time_info
    end

    def last_level_method_for_prep_time
        puts "To look up another recipe, enter recipe number" 
        puts ""
        input = gets.chomp 

        if (1..@selected_recipes_by_prep_time.length).include?(input.to_i) && !input.include?("min")
            recipe = @selected_recipes_by_prep_time[input.to_i - 1]
            recipe_information(recipe)
            last_level_method_for_prep_time
        elsif input.downcase == "exit"
            exit_app
        elsif input.downcase == "start over"
            start_over
        else
            enter_correct_input
            last_level_method_for_prep_time
        end
    end

# SHARED METHODS -------------------------------------------------------------------------------

    def start_over
        puts ""
        greeting
        interaction_with_user
        puts ""
    end

    def exit_app 
        puts ""
        puts "Goodbye!"
        sleep(1)
        exit
    end

    def enter_correct_input
        puts ""
        puts "Enter correct input"
    end

    def recipe_information(recipe)
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
    end
end

