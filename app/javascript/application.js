// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "cocoon-js"


// added to support DELETE protocol for LOGOUT
import Rails from "@rails/ujs"

Rails.start() 