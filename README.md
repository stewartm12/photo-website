# Photographer Portfolio & API Portal

This repository contains two services:

## 🖼️ Web (Frontend - Next.js)

Located in the `/web` directory, a beautiful website built with **Next.js** to showcase the work of a photographer. The site includes:

- 📷 **Galleries & Collections** — Displays curated sets of photos.
- 🧰 **Services Page** — Lists photography services offered.
- ✉️ **Contact Page** — A form for users to get in touch or book sessions.

This site is the public-facing portfolio where clients can view the photographer’s work and get in contact.

---

## 🛠️ API Portal (Backend - Rails)

Located in the `/api` directory, this is a full **Ruby on Rails** application that serves as a private admin portal. Key features include:

- 🗓️ **Appointment Management** — Create, update, and manage appointments.
- 🖼️ **Photo & Gallery Tools** — Upload and organize photos into collections and galleries.
- 🔐 **Merchant Access & Authentication** — Merchants are authenticated and receive API tokens.
- ⚙️ **GraphQL API Endpoint** — A robust API for integration with the frontend.
- 📚 **Auto-generated API Documentation** — Makes it easy for collaborators to understand and use the API.

This backend is designed as a powerful content and appointment management tool for the photographer to run their business efficiently.

> **Note:** The API portal is currently under active development.  
> At this stage, it includes only the essential GraphQL endpoints to:
> - Fetch galleries
> - Create appointments

Additional features and endpoints will be added progressively. 

---

## 🔧 Tech Stack

| Service | Stack |
|--------|-------|
| Web | Next.js, React, Tailwind CSS |
| API | Ruby on Rails, PostgreSQL, GraphQL, Tailwind CSS |

---

## Installation Instructions

Follow these steps to get the application running locally:

### 1. Clone the Repository

Clone the repo to your local machine:
```bash
git pull git@github.com:stewartm12/photo-website.git
```

### 2. Create Local Environment Files

Create the following two files under the `config/environment` directory:

- `nextjs.local.env`
- `rails.local.env`

Copy the environment variables from `nextjs.env` and `rails.env` into their respective `.local.env` files.

### 3. Configure environment variables

Before running the application, you'll need to configure your environment-specific settings. This includes setting up keys for encryption, email services, and map rendering.

#### 3.1 Rails Encryption Keys

To enable Active Record encryption in Rails, generate a set of keys by running:

```bash
bin/rails db:encryption:init
```

This will output a set of keys like the following:

```yaml
active_record_encryption:
  primary_key: RAILS_ENCRYPTION_KEY
  deterministic_key: RAILS_ENCRYPTION_DETERMINISTIC_KEY
  key_derivation_salt: RAILS_ENCRYPTION_KEY_DERIVATION_SALT
```

Add the values to your `rails.local.env` file under `config/environment`:

```env
RAILS_ENCRYPTION_KEY=your_primary_key
RAILS_ENCRYPTION_DETERMINISTIC_KEY=your_deterministic_key
RAILS_ENCRYPTION_KEY_DERIVATION_SALT=your_salt
```

### 3.2 Mailgun Configuration

To enable email functionality using Mailgun:

1. Sign up for a free developer account at [Mailgun](https://www.mailgun.com/).
2. Once set up, copy your API key and domain.
3. Add them to your `rails.local.env` file:

```env
MAILGUN_API_KEY=your_mailgun_api_key
MAILGUN_DOMAIN=your_mailgun_domain
```

### 3.3 Mapbox Access Token

Mapbox is used for rendering maps in the application. To set it up:

1. Create a free account at [Mapbox](https://www.mapbox.com/).
2. Retrieve your access token.
3. Add it to your `rails.local.env` file:

```env
MAPBOX_ACCESS_TOKEN=your_mapbox_token
The Mapbox URL is already configured in the codebase and will use this token for authentication.
```

### 4. Build and Run Services with Docker

From the project root directory, run:

```bash
docker-compose up --build
```

### 5. Running Commands in Docker Containers

To interact with the Docker containers, you can use the following commands:

- **For Rails (API):**

  ```bash
  docker exec -it photo-website-api-1 bash
  ```
- **For Nextjs (WEB):**

  ```bash
  docker exec -it photo-website-web-1 sh
  ```

There is no need to run `rails db:setup` or `rails db:seed` manually, as these tasks are automatically handled by the `entrypoint.sh` script when you run `docker-compose up --build`.

### 🚀 Upcoming Features

Actively working on expanding the capabilities of the API and admin portal. Here are some of the planned enhancements:

- **User & Store Authentication**  
  We will integrate authentication using the Rails 8 built-in authentication generator.  
  This will enable users and stores to securely sign up and log in.

  - As part of this enhancement, each store will be issued its own unique API token.  
    This approach will replace the use of a global secret token, allowing for more secure and granular authentication.  
    Incoming requests can then be verified against their respective store tokens.

- **Rails Admin Portal for Users**  
  A dedicated portal will be developed for users to manage their content.  
  Features will include:
  - Uploading and organizing photos and galleries
  - Viewing and managing appointments