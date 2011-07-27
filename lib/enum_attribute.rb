
# usage
#   #add in your model
#    include EnumAttribute
#
#   #seting in a Aaa model
#    enum_attribute :test, ['a','b','c'] 
#
#   ex.
#     class methods is defined.
#       Aaa.tests         => ['a','b','c']
#       Aaa.test_names    => [ t('activerecord.attributes.aaa.tests.a'),
#                              t('activerecord.attributes.aaa.tests.b'),
#                              t('activerecord.attributes.aaa.tests.c') ] 
#
#       Aaa.test_name('a')  => t('activerecord.attributes.aaa.tests.a')
#
#       Aaa.test_pairs    => [[t('activerecord.attributes.aaa.tests.a'),a],
#                             [t('activerecord.attributes.aaa.tests.b'),b],
#                             [t('activerecord.attributes.aaa.tests.c'),c]] 
#
#       test_pairs method is useful for select_tag
#         select @aaa, Aaa.test_pairs 
#
#     instance methods also is defined.
#       @aaa = Aaa.new(:test=>'a')
#       @aaa.test_name     => t('activerecord.attributes.aaa.tests.a')
#
#
# @params [Hash] options
# @options options [boolean] :number(false)
#    if true, (name)_pairs method return number in 2nd array 
#    and change column name :column => (name)_id automatically!
#    It will be useful for select type
#    ex.
#      seting in a model
#        enum_attribute :test, ['a','b','c']  :number => true
#      you can get
#        object.test_pairs => [[a,1],[b,2],[c,3]]
#
#
# @options options [string] :column_name(false) attached column name in table of DB
#
#    ex. :column => 
#    it will be set when name and column name is difference
#
# @options options [boolean] :i18n(true)
#    if i18n == false ,just return raw data
#
module EnumAttribute
  def self.included target
    target.class_eval do
      extend EnumAttribute::ClassMethods
    end
  end
  
  module ClassMethods
    def enum_attribute name, values, opts={:number=>false,:colum_name=>false,:i18n=>true}
      raise "Values should be given as Enumerable" unless values.is_a?(Enumerable)
      values = values.map(&:to_s)
      #validates_inclusion_of __send__(name), :in=>values unless opts[:skip_validation]

      pluralized = name.to_s.pluralize

      extend Module.new{
        define_method pluralized do
          values
        end
        define_method "#{name}_names" do
          if opts[:i18n] == false
            values
          else
            values.map{|n|self.i18nt(n,pluralized)}
          end
        end
        define_method "#{name}_pairs" do
          if opts[:number]
            values.each_with_index.map{|n,i|[ self.i18nt(n,pluralized), i + 1]}
          else
            values.map{|n|[ self.i18nt(n,pluralized), n]}
          end
        end
        define_method "#{name}_name" do |col|
          return "" if col.blank?
          if col.to_i==0 #0 and char -> true
            return "" unless values.any?{|v| v == col.to_s}
            self.i18nt(col,pluralized)
          else
            return "" if values.size < col.to_i
            self.i18nt(values[col - 1],pluralized)
          end
        end
        def i18nt(value,pluralized) 
          return "" unless value
          #I18n.t("models.#{self.model_name.to_s.underscore}.#{pluralized}.#{value}")
          i18n_scope = "activerecord"
          i18n_scope = self.i18n_scope.to_s if defined?(self.i18n_scope) #rails2 support i18n_scope
          I18n.t("#{i18n_scope}.attributes.#{self.model_name.to_s.underscore}.#{pluralized}.#{value}")
        end
      }

      # foo.val_seed
      define_method "#{name}_seed" do
        column_name = name
        column_name = opts[:column_name] if opts[:column_name]
        if opts[:number]
          return "" if __send__(column_name).to_i - 1 < 0
          values[__send__(column_name).to_i - 1]
        else
          column_name
        end
      end

      # if locale is just variable,it'll cause to error
      # So array(*locale) can make parameter nothing.
      # ex. foo.val_name
      define_method "#{name}_name" do |*locale|
        column_name = name
        column_name = opts[:column_name] if opts[:column_name]

        return "" unless __send__(column_name) #reject nil in column

        if opts[:number]
          return "" if __send__(column_name).to_i - 1 < 0
          value = values[__send__(column_name).to_i - 1]
        else
          value = __send__(column_name) 
        end

        return value if opts[:i18n] == false

        l = :en
        l = I18n.locale if defined?(I18n.locale)
        l = locale[0] if locale

        i18n_scope = "activerecord"
        i18n_scope = self.i18n_scope.to_s if defined?(self.i18n_scope) #rails2 support i18n_scope
        I18n.t("#{i18n_scope}.attributes.#{self.model_name.to_s.underscore}.#{pluralized}.#{value}",:locale=>l)
      end

      # I want to use for checkbox type ,but indeed its hard to manage to store&read with Mysql
      # so,it'll be dupricated in near future.
      #
      # foo.val_names
      #
      # :assumption data is array
      #  ex @aaa.test_names => ['a','b','c']
      #
      #define_method "#{name}_names" do
        #array =[]
        #return false if self.send(name).blank?
        #if self.class.to_s.index("::")
          #self.send(name).map{|n|array << I18n.t("models.#{self.class.superclass.to_s.underscore}.#{pluralized}.#{n}")}
        #else
          #self.send(name).map{|n|array << I18n.t("models.#{self.class.to_s.underscore}.#{pluralized}.#{n}")}
        #end
        #return array.join("<br />")
      #end

    end
  end

end

