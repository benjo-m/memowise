# MemoWise
### Description
MemoWise is a learning app that utilizes learning techniques such as **active recall** and **spaced repetition** to help you learn more efficiently and to retain knowledge for longer. To achieve this, I used **SM-2** spaced repetition algorithm. You can read more about it here: [SM-2](https://www.supermemo.com/en/blog/application-of-a-computer-to-improve-the-results-obtained-in-working-with-the-supermemo-method).
### Differences between the prototype and final application
There are some differences between the prototype and final application worth mentioning:
- Question types: in the prototype, there is an option to choose a type of question when creating a new flashcard, like 'true/false', 'fill in the blanks' and 'regular'. However this feature was omitted as it would defeat the purpose of active recall because active recall relies on users fully engaging with the material by retrieving information from memory. With question types like 'true/false' and 'fill in the blanks' this is not possible and it encourages passive learning.
- AI generated decks difficulty: in the prototype, users could choose the difficulty of a generated deck. I deciced to keep this out because users should not rely on AI to generate anything more than a surface knowledge level questions as it could produce incorrect and misleading answers. The AI generated decks are meant to be used as a starting point to learn new things, quickly.
### Essential features
Description of all the **must have** features and how I implemented them:
- Authentication/Authorization: I used Basic authentication as demonstrated in classes. All endpoints are secured with the [Authorize] attribute to ensure that only authenticated users can access them.
- ML algorithm: since the last academic year, students are allowed to implement any algorithm from the field of machine learning, not just recommender. For this project I chose to implement a regression model. It is used to predict the study session duration for a given deck.
- Payment system: Stripe is integrated to allow users to upgrade to the premium version of the app through a one-time purchase, unlocking additional features and functionality.
- Reporting: administrators are able to generate reports through MemoWise Admin desktop application inside **Analytics** view and export them as .pdf files.
- RabbitMQ: upon registering, users receive a welcome email containing the link to this repository where they can contribute and raise issues. To test this feature you will have to register a new account. You can use something like [10 Minute Mail](https://10minutemail.com/).
### Running the application
The prerequisites for running the app are **Docker** and **Flutter**.

The repository size is around 200MB because I had to commit build files as a requirement for my university class. If you don’t want to download all 200MB, you can download it as a ZIP file instead.

- Clone this repository: `git clone https://github.com/benjo-m/memowise`
- Navigate to the cloned directory: `cd memowise`

Run the backend:
- Navigate to **backend** directory: `cd backend`
- Unzip the **.env.zip** file inside the same directory (memowise/backend). Password is "fit"
- Run `docker-compose up` from the **backend** directory (this will start SQL Server, RabbitMQ, API project on port 8080 and SubscriberEmail project)

Run the mobile app:
- Navigate to `memowise/mobile` directory: `cd ..` `cd mobile`
- Run `flutter run` (you can optionally pass in `BASE_URL` and `STRIPE_PK` environment variables using `--dart-define`)

Run the desktop app:
- Navigate to `memowise/desktop` directory: `cd ..` `cd desktop`
- Run `flutter run`

### Testing the application
To test the mobile application use the following credentials:
- Username: user
- Password: password

To test the desktop application as **Super Admin** use the following credentials:
- Username: super_admin
- Password: password

To test the desktop application as **Admin** use the following credentials:
- Username: admin
- Password: password

### Important Notice: Database Access and Management Functionality
Due to a misunderstanding of the project requirements, I implemented the desktop application in such way to provide full CRUD operations on **ALL** tables, rather than reference tables only. Because I don't even have any reference tables (Admin and Super Admin roles are just class properties IsAdmin and IsSuperAdmin), I decided to keep this feature but restrict it to **Super Admin** only.
