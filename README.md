# Coding Challenge

### Implementation of simple banking operations

Rails application `VisableBank` performs basic banking operations like money transfers and showing of current account balance.

run `rake db:setup & db:migrate & db:seed` to have the databse ready

you can run `rake` to run the tests

or

run `rails s` for the server to start up

then calling `/account/111-222-333/overview` would show the json results for the account overview API which shows the balance of the account and its 10 latest transactions.

posting to `transaction/transfer` with parameters `from`, `to`, and `amount` would transfer `amount` cents from `from` account number to `to` account number.

I did not implement the code in the order specified in the specs. I didn't create user and auth models and this is only according to the requirements.

here is the link to the git repository: https://github.com/maysam/VisableBank

Thanks
