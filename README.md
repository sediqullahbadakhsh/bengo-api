# Bengo Backend

This is a simple backend application for Bengo, a real-time search box and analytics platform. The backend is built using Ruby on Rails and provides an API for searching and storing user queries.

- **Author:** Sediqullah Badakhsh
- **Contact** sediqullahbadakhsh@gmail.com

## Table of Contents

- Ruby version
- System dependencies
- Configuration
- How to run the test suite
- Deployment instructions
- API DocumentationThings you may want to cover:

## Ruby version

This application is build using ruby 3.1.3 and Rails 7.0.4

## System dependencies

- PostgreSQL as the database for Active Record.

## Configuration

- clone the project using: `https://github.com/sediqullahbadakhsh/bengo-api.git`.
- Before running the application, make sure to install the required dependencies using bundler: `bundle install`.
- To create the PostgreSQL database, run `rails db:create` command.
- To run database migrations to set up the schema: `rails db:migrate`.
- To run RSpec test Suite, execute: `bundle exec rspec` OR `rspec`.
- Start the application.

## Deployment instrutions (Optional)

To deploy the application, follow these steps:

1. Push your code to your preferred hosting platform (e.g., Heroku, AWS, DigitalOcean).
2. Set up the required environment variables and services for your hosting platform.
3. Run the database migrations and seed data (if necessary).
4. Start the application.

## API Documentation

The API documentation is available using Swagger. You can view it at the following URL when running the application locally:
`http://localhost:3000/api-docs/index.html`
