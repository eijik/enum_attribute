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

#extend your method to model class
enum_attribute :test, ['a','b','c'] 

  ex.
      #class methods is defined.
      Aaa.tests         => ['a','b','c']
      Aaa.test_names    => [ t('activerecord.attributes.aaa.tests.a'),
                             t('activerecord.attributes.aaa.tests.b'),
                             t('activerecord.attributes.aaa.tests.c') ] 

      Aaa.test_name('a')  => t('activerecord.attributes.aaa.tests.a')

      Aaa.test_pairs    => [[t('activerecord.attributes.aaa.tests.a'),a],
                            [t('activerecord.attributes.aaa.tests.b'),b],
                            [t('activerecord.attributes.aaa.tests.c'),c]] 

      test_pairs method is useful for select_tag
       select @aaa, Aaa.test_pairs 

      #instance methods also is defined.
      @aaa = Aaa.new(:test=>'a')
      @aaa.test_name     => t('activerecord.attributes.aaa.tests.a')


#@params [Hash] options
#@options options [boolean] :number(false)
   if true, (name)_pairs method return number in 2nd array 
   and change column name :column => (name)_id automatically!
   It will be useful for select type
   ex.
     seting in a model
       enum_attribute :test, ['a','b','c']  :number => true
     you can get
       object.test_pairs => [[a,1],[b,2],[c,3]]


#@options options [string] :column_name(false) attached column name in table of DB

   ex. :column => 
   it will be set when name and column name is difference

#@options options [boolean] :i18n(true)
   if i18n == false ,just return raw data



Contributing
------------ 

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

Copyright
---------

Copyright (c) 2011 Eiji Kosaki. See LICENSE.txt for
further details.

