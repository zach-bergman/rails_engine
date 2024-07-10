---

# Rails Engine

Welcome to the Rails Engine repository! This project is a Rails application that serves as an API backend for a sales engine. It provides endpoints to retrieve data related to merchants, items, and their relationships.

## Table of Contents

- [Getting Started](#getting-started)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Running the Tests](#running-the-tests)
- [Usage](#usage)
- [Endpoints](#endpoints)
- [Contributing](#contributing)
- [License](#license)

## Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

Ensure you have the following installed on your machine:

- Ruby 3.0.0
- Rails 6.1.4
- PostgreSQL

### Installation

1. Clone the repository
   ```sh
   git clone https://github.com/zach-bergman/rails_engine.git
   ```
2. Navigate to the project directory
   ```sh
   cd rails_engine
   ```
3. Install dependencies
   ```sh
   bundle install
   ```
4. Set up the database
   ```sh
   rails db:create
   rails db:migrate
   rails db:seed
   ```

## Running the Tests

To run the test suite, execute the following command:

```sh
bundle exec rspec
```

This will run the full suite of tests to ensure the application is working correctly.

## Usage

To start the Rails server, run:

```sh
rails s
```

This will start the server at `http://localhost:3000`, and you can begin making API requests to the available endpoints.

## Endpoints

The Rails Engine API provides various endpoints to interact with the data. Here are some examples:

### Merchants

- `GET /api/v1/merchants`: Retrieve a list of all merchants
- `GET /api/v1/merchants/:id`: Retrieve a specific merchant by ID

### Items

- `GET /api/v1/items`: Retrieve a list of all items
- `GET /api/v1/items/:id`: Retrieve a specific item by ID
- `POST /api/v1/items`: Create a new item
- `PATCH /api/v1/items/:id`: Update an item
- `DELETE /api/v1/items/:id`: Delete an item

### Merchant Items

- `GET /api/v1/merchants/:merchant_id/items`: Retrieve all items for a specific merchant
- `GET /api/v1/items/:item_id/merchant`: Return the merchant associated with an item

### Search Endpoints

- `GET /api/v1/merchants/find`: Find a single merchant which matches a search term
- `GET /api/vi/items/find_all`: Find all items which match a search term

---
