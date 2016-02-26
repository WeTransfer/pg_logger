# pg_logger

Generates a Proc that can be fed to a "pg"-driven PostgreSQL adapter. The proc will convert the PostgreSQL
messages to the Ruby logger messages of a comparable warning level and send them to your logger.

For example, to use via Sequel:

    db = Sequel.connect('postgres://...', notice_receiver: PgLogger.notice_proc_for_logger(MyApp.logger))

## Contributing to pg_logger
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2016 WeTransfer. See LICENSE.txt for
further details.

