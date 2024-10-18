// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import * as bootstrap from "bootstrap"

// This is adding a custom stream action that performs a redirect.
Turbo.StreamActions.redirect = function () {
    window.location.href = this.getAttribute("href")
  }