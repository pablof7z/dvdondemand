class ACH
  class Field
    include ErrorsArray

    attr_accessor :name, :position, :inclusion, :length, :value

    def initialize(name, pos, inclusion, opts = {})
      pos = pos..pos unless pos.is_a? Range
      @name, @position, @inclusion = name, pos, inclusion
      @length = @position.count

      opts.each do |option, value|
        instance_variable_set("@#{option}", value) if
        options.include?(option)
      end
    end

    def dump
      nil
    end

    def parse(data)
      nil
    end

    def check_inclusion
      not ([ :mandatory, :required ].include? inclusion and not value)
    end

    def test_validity
      nil
    end

    def is_valid?
      errors.clear

      errors << "#{inclusion} field not included" unless check_inclusion

      test_validity if value

      errors.empty?
    end

    def validate
      raise InvalidField.new(errors.to_s) unless is_valid?
    end


    private

    def options
      (self.class.class_exec { @options } || [])
    end


    class << self

      def types
        @field_types ||= {}
      end

      def option(name, default = nil)
        (@options ||= {})[name] = default

        class_exec { attr_writer name }

        class_eval "
          def #{name}
            @#{name} ||= options[:#{name}]
          end"
      end

      def inherited(sub)
        klass_name = sub.name.split('::').last.
          gsub(/\B[A-Z]/, '_\&').
          squeeze('_').downcase.to_sym
        types[klass_name] = sub
      end

      def new_by_type(name, position, type, inclusion, opts = {})
        if klass = types[type.to_sym]
          klass.new(name, position, inclusion, opts)
        else
          raise NoFieldError.new("undefined field type '#{type}'")
        end
      end
    end



    class String < Field

      option :ignore_overflow, true

      def value
        @value.to_s
      end

      def parse(str)
        @value = str.strip
      end

      def dump
        validate

        data = value[0, length]
        data += (" " * (length - value.length)) if length > value.length

        data
      end

      private
      def test_validity
        if not ignore_overflow and value.length > length
          errors << "value is longer that field length " +
            "(value: #{value.length}, field: #{length})"
        end
      end
            
    end

    class Numeric < Field
      option :blanks

      def parse(num)
        raise ParserError.new("not a number '#{num}'") unless num =~ /\d*/
        @value = num.to_i
      end

      def dump
        validate

        "%#{@blanks?' ':0}#{length}d" % value
      end

      private
      def test_validity
        unless value.class.ancestors.include?(Numeric) or value !~ /\d*/
          errors << "'#{value}' is not a number"
        else
          errors << "numberic value '#{value}' " +
            "doesn't fit in field" if value.to_s.length > length
        end
      end
    end

    class Currency < Field
      attr_writer :dollars, :cents

      def parse(currency, check = true)
        raise ParserError.new("invalid currency amount '#{currency}'") unless
          currency =~ /\d*/

        if currency.length > 2
          @cents = currency[-2, 2]
          currency = currency[0..-3]
        end
        @dollars = currency

        validate if check
      end

      def dump
        validate

        ("%#{length}s" % pre_dump).gsub(/ /, '0')
      end

      def value
        if cents
          [ dollars, cents ]
        else
          dollars
        end
      end

      def value=(currency)
        @dollars, @cents =
          if currency.is_a? Array
            [ currency[0], currency[1] ]
          elsif currency.is_a? Float
            [ currency.floor, (currency.remainder(1) * 100).to_i ]          
          elsif currency.is_a? Integer
            [ currency, 0 ]
          else
            [ nil, nil ]
          end
      end

      def to_f
        dollars + cents / 100.0
      end

      def dollars
        @dollars.to_i if @dollars
      end

      def cents
        @cents.to_i if @cents
      end

      private
      def pre_dump
        ( "%d" % dollars + (cents ? "%02d" % cents : ""))
      end

      def test_validity
        if cents
          errors << "cents value out of range (#{cents})" unless
            cents.between?(0, 99)
        end
        errors << "currency value doen't fit in field" if
          pre_dump.length > length
      end
    end

    class Date < Field

      attr_accessor :year, :month, :day

      def value
        if year and month and day
          [ year, month, day ]
        else
          nil
        end
      end

      def value=(value)
        if value.is_a? Array
          @year, @month, @day = value
        elsif value.is_a? ::String
          parse(value, false)
        elsif value.is_a? ::Time
          parse(value.strftime('%y%m%d'), false)
        else
          @year = @month = @day = nil
        end
      end

      def parse(date, check = false)
        raise ParserError.new("invalid date '#{date}'") unless
        date =~ /\d{6}/

        @year, @month, @day = date.unpack('A2A2A2').map { |x| x.to_i }

        raise ParserError.new(errors.to_s) if check and not is_valid?
      end

      def dump
        validate

        "%02d%02d%02d" % [ year, month, day ]
      end

      private
      def test_validity
        errors << "year out of range ('#{year}')" unless year.between?(0, 99)
        errors << "month out of range ('#{month}')" unless month.between?(1, 12)
        if day.between?(1, 31)
          errors << "bad day number for the given month ('#{day}')" unless
          case month
          when 1, 3, 5, 7, 8, 10, 12
            day.between?(1, 31)
          when 4, 6, 9, 11
            day.between?(1, 30)
          else
            day.between?(1, 28)
          end
        else
          errors << "day out of range ('#{day}')"
        end
      end

    end

    class Time < Field

      attr_accessor :hour, :minutes

      def value
        if hour and minutes
          [ hour, minutes ]
        else
          nil
        end
      end

      def value=(value)
        if value.is_a? Array
          @hour, @minutes = value
        elsif value.is_a? ::String
          parse(value, false)
        elsif value.is_a? ::Time
          parse(value.strftime('%H%M'), false)
        else
          @hour = @minutes = nil
        end
      end

      def parse(time, check = true)
        raise ParserError.new("invalid time '#{time}'") unless
        time =~ /\d{4}/

        @hour, @minutes = time.unpack('A2A2').map { |x| x.to_i }

        raise ParserError.new(errors.to_s) if check and not is_valid?
      end

      def dump
        validate

        "%02d%02d" % [ hour, minutes ]
      end

      private
      def test_validity
        errors << "hour out of range ('#{hour}')" unless hour.between?(0, 23)
        errors << "minutes out of range ('#{minutes}')" unless minutes.between?(0, 60)
      end

    end

    class Reserved < Field
      def dump
        " " * length
      end
    end

  end

end
