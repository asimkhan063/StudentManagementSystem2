# School Management: upgrade notes

This folder is the updated copy of the project. The original folder on `D:` was left untouched because write access to that location was unavailable.

## Configuration

The application reads its database and mail settings from environment variables:

| Variable | Purpose | Local default |
| --- | --- | --- |
| `DB_URL` | JDBC connection URL | `jdbc:mysql://localhost:3306/schooldba12?createDatabaseIfNotExist=true` |
| `DB_USERNAME` | Database username | `root` |
| `DB_PASSWORD` | Database password | empty |
| `MAIL_USERNAME` | SMTP account | empty |
| `MAIL_PASSWORD` | SMTP app password | empty |
| `OPENAI_API_KEY` | Optional AI assistant key | empty |
| `RAZORPAY_KEY_ID` | Razorpay checkout key ID (test key for local testing) | empty |
| `RAZORPAY_KEY_SECRET` | Razorpay server secret; never put this in browser code | empty |
| `SCHOOL_TIME_ZONE` | Time zone used for overdue-fee alerts | `Asia/Kolkata` |
| `BOOTSTRAP_ADMIN_USERNAME` | Username for first admin | `admin` |
| `BOOTSTRAP_ADMIN_PASSWORD` | One-time first admin password | unset (no admin is created) |

For Docker Compose, set `DB_PASSWORD` before starting the services. Compose connects the app to MySQL using the `mysql-db` service name. You can use a local `.env` file for credentials; do not commit that file.

The admin bootstrap only creates a new user when `BOOTSTRAP_ADMIN_PASSWORD` is explicitly set and that username does not already exist. It never resets an existing user's password. The first-login password change remains enabled.

The floating assistant uses the OpenAI API when `OPENAI_API_KEY` is configured. Without a key, it stays available with its built-in school workflow guidance. The API key is read from the server environment and is never sent to the browser.

Parent portal setup: from **Admin → Create User**, create an account with the `PARENT` role. Then open **Admin → Parent Accounts** and link the parent email to the correct student. The parent logs in with the emailed credentials and is sent to `/parent/dashboard`; `/api/parent/children` only returns students linked to that signed-in parent.

## Attendance, academics, alerts, and online fee payment

- Admin attendance uses `/admin/student-attendance/**`; teacher attendance uses `/teacher/student-attendance/**`. Attendance values are stored as `Present`, `Absent`, and `Leave`.
- The parent dashboard shows only linked students' last 20 attendance records, invoices, quiz results, and assignment summaries.
- Absence email is sent after attendance is recorded. Overdue invoice email is checked daily at 09:00 in `SCHOOL_TIME_ZONE`. SMTP must be configured using `MAIL_USERNAME` and a provider app password. Notification logs prevent repeated messages for the same absence/date or overdue invoice.
- Teachers can open **Assignments & Quizzes** from their dashboard, create class assignments and MCQ quizzes, grade text submissions, and view class report summaries. Students submit work at `/student/academics`. Quizzes allow one attempt per student; answers are scored on the server.
- Parents can pay linked child invoices through Razorpay Checkout. Set Razorpay **test** keys first. The server creates the order from the invoice's remaining balance, verifies the checkout signature, fetches the gateway payment, and records only captured payments. Live keys should be used only after end-to-end test mode verification.

The payment gateway dependency follows Razorpay's official Java SDK. Order creation must happen on the server, and checkout signatures are verified server-side before the invoice is updated.

## Security changes and remaining work

- Admin, teacher, and student URL checks now run without a preceding broad public-access rule.
- Database/mail credentials were removed from the application defaults; SQL output is off by default and security logging is no longer debug-level.
- CSRF protection is still disabled because the existing JSP and JavaScript forms need CSRF tokens added first. Complete that migration and enable CSRF before exposing this application to the public internet.
- Rotate any database or mail credentials that were previously used with the original project, since those values were present in its configuration file.

## Build

Build the WAR with Maven from this folder:

```text
mvn -DskipTests package
```
