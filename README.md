# Photographer Portfolio & API Portal

This repository contains two services:

## 🖼️ Web (Frontend - Next.js)

Located in the `/web` directory, a beautiful website built with **Next.js** to showcase the work of a photographer. The site includes:

- 📷 **Galleries & Collections** — Displays curated sets of photos.
- 🧰 **Services Page** — Lists photography services offered.
- ✉️ **Appointment Page** — A form for users to get in touch or book sessions.

This site is the public-facing portfolio where clients can view the photographer’s work and get in contact.

### ⚡ Smart Caching & Revalidation

The frontend is **fully cached** using Next.js’ built-in data caching and tagging system.  
Each page and GraphQL query is cached automatically to deliver **instant load times** and **seamless navigation**.

When content is updated in the Rails admin portal (e.g., a gallery name changes, a new collection is added, or a photo is deleted), the Rails backend automatically sends a **revalidation request** to the Next.js API route.  
This triggers a **selective cache refresh** on the frontend, ensuring visitors always see the latest content — without rebuilding or redeploying the site.

This approach provides the best of both worlds:
- **Static-like performance** with cached responses.
- **Dynamic freshness** via real-time revalidation from the backend.

---

## 🛠️ API Portal (Backend - Rails)

Located in the `/api` directory, this is a full **Ruby on Rails** application that serves as a private admin portal. Key features include:

- 🗓️ **Appointment Management** — Create, update, and manage appointments.
- 🖼️ **Photo & Gallery Tools** — Upload and organize photos into collections and galleries.
- 🔐 **Merchant Access & Authentication** — Merchants are authenticated and receive API tokens.
- ⚙️ **GraphQL API Endpoint** — A robust API for integration with the frontend.
- 🔄 **Frontend Cache Revalidation** — Automatically notifies the Next.js frontend when data changes.

This backend is designed as a powerful content and appointment management tool for the photographer to run their business efficiently.

> **Note:** The API portal for developers is currently under active development.

Additional features and endpoints will be added progressively.

## 🔧 Tech Stack

| Service | Stack |
|--------|-------|
| Web | Next.js, React, Tailwind CSS, Typescript |
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

### 4. AWS S3 Configuration

AWS S3 is used for photo and asset storage on the **Rails backend**.
You’ll need to set up your own S3 bucket and credentials to enable uploads and image rendering.

#### 4.1 Create an S3 Bucket

1. Sign in to your [AWS Management Console](https://aws.amazon.com/console/).  
2. Navigate to **S3** → **Create bucket**.  
3. Choose a **unique bucket name** and your preferred **AWS region** (e.g., `us-east-1`).  
4. Leave default settings or adjust public access options as needed for your development setup.

#### 4.2 Retrieve Access Keys

1. Go to your [IAM Management Console](https://console.aws.amazon.com/iam/).  
2. Under **Users**, select or create a user with **AmazonS3FullAccess** (for local development only).  
3. Create a new **Access Key** and save the **Access Key ID** and **Secret Access Key**.

#### 4.3 Update Rails Environment

Add the AWS credentials and bucket info to your `rails.local.env` file:

```env
AWS_ACCESS_KEY=your_access_key_id
AWS_SECRET_ACCESS_KEY=your_secret_access_key
AWS_REGION=your_bucket_region
AWS_BUCKET=your_bucket_name
```

### 5. Build and Run Services with Docker

From the project root directory, run:

```bash
docker-compose up --build
```

### 6. Running Commands in Docker Containers

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
  - As part of this enhancement, each store will be issued its own unique API token.  
    This approach will replace the use of a global secret token, allowing for more secure and granular authentication.  
    Incoming requests can then be verified against their respective store tokens.
