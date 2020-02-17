# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

run Rails.application

require 'rack/cors'
# Rack::Cors do
#     allow do
#       origins "*"
#       resource "*",
#                headers: :any,
#                methods: [:get, :patch, :put, :delete, :post, :options],
#                expose: ["X-Total-Count"]
#     end
#   end

  use Rack::Cors do

    # allow all origins in development
    allow do
      origins '*'
      resource '*', 
          :headers => :any, 
          :methods => [:get, :patch, :put, :delete, :post, :options]
          expose: ["X-Total-Count"]
    end
  end