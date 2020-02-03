require 'open-uri'
require 'pry'

class Scraper

    def api_request
        data = HTTParty.get("https://api.spoonacular.com/recipes/complexSearch?query=pasta&maxFat=25&number=2&apiKey=4e36a8e7ee7b4d6f9366efaf9374250a")
    end

    def self.scrape_page
        doc = Nokogiri::HTML(open("https://www.simplyrecipes.com/recipes/type/quick/dinner/"))
        details = doc.css("div.grd-tile-detail")
        recipes = []
        details.each do |detail|
            recipe_hash = {
                :title => detail.css("h2.grd-title-link a span").text,
                :author => detail.css("a.grd-author-link div.author-name").text,
                :prep_time => detail.css("div.grd-recipe-summary div.sum-recipe-summary div.sum-properties")[0].css("span.sum-cook-time").text,
                :info => detail.css("div.grd-recipe-excerpt").text 
            }
            if detail.css("div.grd-recipe-summary div.sum-recipe-summary div.sum-properties div.sum-property span.sum-food-type").text != ""
                recipe_hash[:food_type] = detail.css("div.grd-recipe-summary div.sum-recipe-summary div.sum-properties div.sum-property span.sum-food-type").text
            end
            recipes << recipe_hash
        end
        recipes 

    end


end