class Recipe

    attr_accessor :title, :author, :prep_time, :info, :food_type 

    @@all = []
    
    def initialize(recipe_hash)
        recipe_hash.each do |key, value|
            self.send "#{key}=", value 
        end
        @@all << self
    end

    def self.create_from_collection(recipes_array)
        recipes_array.each do |recipe|
            self.new(recipe)
        end
    end

    # def initialize
    #     @@all << self
    # end

    # def self.add_attributes_from_array(recipes_array)
    #     recipes_array.each do |recipe|
    #         recipe.each do |key, value| 
    #             self.send "#{key}=", value 
    #         end
    #     end
    #     self
    # end

    def self.all 
        @@all 
    end

    def self.reset_all
        @@all.clear
    end

end