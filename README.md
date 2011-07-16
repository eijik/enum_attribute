enum_attribute
--------------

* If you settin up enum_attribute to existed your method,
* add helpful method automatically.
* It's for good to input type(select,checkbox,radio)
* indication with I18n



Installing
----------
To install enum_attribute, use the following command:

    $ gem install enum_attribute
 
or write Gemfile and "bundle install"

    $ gem 'enum_attribute', :git=>'https://github.com/eijik/enum_attribute.git'


Usage
-----
 #add in your model
 include EnumAttribute

 #setting in a Aaa model
 #your_method is already defined.
 #ex.
 enum_attribute :(your_method), ['a','b','c'] 



== Contributing to enum_attribute
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

== Copyright

Copyright (c) 2011 Eiji Kosaki. See LICENSE.txt for
further details.

