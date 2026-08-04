# Prakerin-ITS-BE

### Requirements
Before running this project, ensure you have the following installed on your local machine:
*   **PHP** (>= 8.1)
*   **Composer**
*   **Laravel Framework** (10.x)
*   **MySQL** or **PostgreSQL**

## How to Run This Project

1. Git Clone this repository by using:
   `git clone https://github.com/imeldaalexis/Prakerin-ITS.git`

2. Navigate into the cloned project directory:
   `cd Prakerin-ITS`

3. Install all necessary PHP dependencies (including Laravel Modules and Sanctum):
   `composer install`

4. Create your environment configuration file by copying the example file:
   *For Windows:* `copy .env.example .env`
   *For Mac/Linux:* `cp .env.example .env`

5. Generate the application key for security:
   `php artisan key:generate`

6. Open the newly created `.env` file in your code editor and configure your database connection. Example for MySQL:
   ```env
   DB_CONNECTION=mysql
   DB_HOST=127.0.0.1
   DB_PORT=3306
   DB_DATABASE=your_database_name
   DB_USERNAME=root
   DB_PASSWORD=

7. Run the database migrations to build the tables (this includes the tables for users and Sanctum tokens):
`php artisan migrate`

8. Start the local development server:
`php artisan serve --host=0.0.0.0 --port=8000`

9. The API will now be accessible at http://0.0.0.0:8000.



## How to Test the API (Using Postman)

Once the local server is up and running, you can test the authentication flow using [Postman](https://www.postman.com/) or any similar API client.

Example:
### Login Endpoint
To test the login functionality and retrieve your Sanctum access token:

*   **Method:** `POST`
*   **URL:** `http://0.0.0.0:8000/api/auth/login`
*   **Headers:**
    *   `Accept` : `application/json`
*   **Body (Raw -> JSON):**
    ```json
    {
        "email": "user_email@example.com",
        "password": "your_password"
    }
    ```
    *(Note: Ensure you have already inserted/seeded a user into your database before trying to log in).*

**Expected Response (Success):**
If the credentials match, the server will return a success message along with the token.
```json
{
    "message": "Login successful",
    "token": "1|random_generated_sanctum_token_string_here",
    "token_type": "Bearer"
}
