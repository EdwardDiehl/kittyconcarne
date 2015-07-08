# kittyconcarne

# Contents

0. [Setting up your local environment](#setting-up-your-local-environment)

## Setting up your local environment

0. **Install depedencies from Homebrew**

    *Do not Use the postgres.app. There are occasionally gems that do not work
    correctly with postgres.app -- use the Homebrew version as shown here.*

    ```bash
    $ brew install redis postgres
    ```

    Load Redis and PostgreSQL on boot and start them now:

    ```bash
    $ for service in redis postgresql; do
    > plist_file="$(brew list ${service} | grep '\.plist$')"
    > ln -sv ${plist_file} ~/Library/LaunchAgents
    > launchctl load ~/Library/LaunchAgents/"$(basename ${plist_file})"
    > done
    ```

0. **Create PostgreSQL Superuser Role**

    ```bash
    $ createuser -s kitty
    ```

0. **Install gems**

    ```bash
    $ bundle install -j `sysctl -n hw.ncpu`
    ```

0. **Create database config file and databases**

    ```bash
    $ cp ./config/database.yml.sample ./config/database.yml
    $ RAILS_ENV=development rake db:create db:migrate
    ```

    Create your test database and setup:

    ```bash
    $ RAILS_ENV=test rake db:create db:migrate
    ```

0. **Add required environment variables**

    Copy required environment variables to a .env file in the project root.

    ```bash
    $ cp .env.sample .env
    ```
