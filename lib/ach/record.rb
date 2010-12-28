class ACH
  class Record
    include ErrorsArray

    def initialize(content = nil)
      load_hash(content) if content
    end

    def load_hash(content)
      content = content[type] if content.include? type
      content.each do |name, value|
        fields[name].value = value if fields[name]
      end
    end

    def load_yaml(yaml)
      load_hash YAML.load(yaml)
    end

    def dump_hash
      validate

      hash = {}
      fields.each do |name, field|
        hash[name] = field.value
      end
      { type => hash }
    end
    alias to_hash dump_hash

    def dump_yaml
      YAML.dump(dump_hash)
    end
    alias to_yaml dump_yaml

    def fields
      @fields ||= {}
      if @fields.empty?
        self.class.class_exec { @fields }.each do |field|
          @fields[field] = send(field)
        end
        class << @fields
          alias original_value_at []
          def [](index)
            if index.is_a? Numeric
              sort[index]
            else
              original_value_at(index)
            end
          end

          def sort
            (@fields_sort ||= [])
            if @fields_sort.empty?
              sort_by do |name, field|
                field.position.min
              end.each do |name, field|
                @fields_sort << field
              end
            end
            @fields_sort
          end
        end
      end
      @fields
    end

    def is_valid?
      errors.clear

      fields.each do |name, field|
        errors << "field #{name}: #{field.errors}" unless field.is_valid?
      end

      errors.empty?
    end

    def validate
      raise InvalidRecord.new("<#{self.class.name}> " + errors.to_s) unless is_valid?
    end

    def parse(data)
      fields.each_value { |field|  field.parse(data[field.position]) }

      validate

      self
    end

    def dump
      validate

      dumped = " " * 94
      dumped[0] = record_type_code.to_s
      fields.each_value do |field|
        dumped[field.position] = field.dump
      end

      dumped + "\n"
    end

    def [](index)
      fields[index]
    end

    def []=(index, value)
      fields[index].value = value
    end

    def inspect
      "#<#{self.class.name} " +
      (fields.map { |n, f| "@#{n}=#{f.value}" }).join(', ') +
      " >"
    end

    class << self

      alias original_new new
      def new(code = nil)
        if code
          begin
            record_classes[code].new
          rescue NoMethodError => e
            raise InvalidRecord.new("unknow record type code '#{code}'")
          end
        else
         super
        end
      end

      def parse(data)
        code = data[0,1]
        raise ParserError.new("bad type code '#{code}'") unless code =~ /\d/
        new(code.to_i).parse(data)
      end


      private

      def record_type_code(code)
        record_classes[code] = self

        class_eval "
          def record_type_code
            #{code}
          end"
      end

      def field(name, position, type = :string, inclusion = :mandatory, opts = {})
        inclusion = :reserved if type == :reserved
        (@fields ||= []) << name

        class_exec do
          define_method(name) do
            unless instance_variable_get("@#{name}")
              instance_variable_set("@#{name}", Field.new_by_type(name, position, type, inclusion, opts))
            end
            instance_variable_get("@#{name}")
          end
        end

        class_eval "
          def #{name}=(value)
            #{name}.value = value
          end"
      end

      def record_classes
        @@record_classes ||= {}
      end

      def inherited(sub)
        klass_name = sub.name.split('::').last.
          gsub(/\B[A-Z]/, '_\&').
          squeeze('_').downcase.to_sym

        sub.class_eval "
          def self.parse(data)
            self.new.parse(data)
          end"

        sub.class_eval "
          def type
            :#{klass_name}
          end"

        sub.class_eval "
          def self.new(*args)
            original_new(*args)
          end"
      end

    end

  end


  class FileHeader < Record
    record_type_code 1
    field :priority_code, 1..2, :numeric, :mandatory
    field :immediate_destination, 3..12, :numeric, :required, :blanks => true
    field :immediate_origin, 13..22, :numeric, :mandatory, :blanks => true
    field :creation_date, 23..28, :date, :mandatory
    field :creation_time, 29..32, :time, :optional
    field :id_modifier, 33, :string, :mandatory
    field :record_size, 34..36, :numeric, :mandatory
    field :blocking_factor, 37..38, :string, :mandatory
    field :format_code, 39, :string, :mandatory
    field :immediate_destination_name, 40..62, :string, :optional
    field :immediate_origin_name, 63.. 85, :string, :optional
    field :reference_code, 86..93, :string, :optional
  end

  class BatchHeader < Record
    record_type_code 5
    field :service_class_code, 1..3, :numeric, :mandatory
    field :company_name, 4..19, :string, :mandatory
    field :company_discretionary_data, 20..39, :string, :optional
    field :company_identification, 40..49, :string, :mandatory
    field :standard_entry_class_code, 50..52, :string, :mandatory
    field :company_entry_description, 53..62, :string, :mandatory
    field :company_descriptive_date, 63..68, :date, :optional
    field :effective_entry_date, 69..74, :date, :required
    field :settlement_date, 75..77, :string, :operator
    field :originator_status_code, 78, :string, :mandatory
    field :originating_dfi_identification, 79..86, :numeric, :mandatory
    field :batch_number, 87..93, :numeric, :mandatory
  end

      
  class BatchEntry < Record
    record_type_code 6

    def transaction_type_field
      fields[:transaction_code]
    end

    def transaction_type
      type = transaction_type_field.value
      if [ 22, 32 ].include? type
        :credit
      elsif [ 27, 37 ].include? type
        :debit
      else
        :unknown
      end
    end

    def debit?
      transaction_type == :debit
    end

    def credit?
      transaction_type == :credit
    end

    class << self

      def inherited(sub)
        sub.class_eval "
          def self.parse(data)
            new.parse(data)
          end"
      end

      def classes
        (@@batch_entry_classes ||= {})
      end
      
      def standard_entry_class(klass)
        classes[klass.to_sym] = self

        class_eval "
          def standard_entry_class
            :#{klass}
          end"
      end

      def parse(data, class_code = nil)
        if class_code
          new(class_code).parse(data)
        else
          raise InvalidBatchClass.new("missing batch entry class")
        end
      end

      def new(type = nil)
        if type
          raise InvalidBatchClass.new("unkown standard batch entry" +
              " class '#{type}") unless
          entry = @@batch_entry_classes[type.to_sym]
          entry.new
        elsif self == BatchEntry
          raise InvalidBatchClass.new('missing standard batch entry class')
        else
          super
        end
      end
    end
  end

  class BatchEntryCCD < BatchEntry
    standard_entry_class 'CCD'
    field :transaction_code, 1..2, :numeric, :mandatory
    field :receiving_dfi_identification, 3..10, :string, :mandatory
    field :check_digit, 11, :numeric, :mandatory
    field :dfi_account_number, 12..28, :string, :mandatory
    field :amount, 29..38, :currency, :mandatory
    field :individual_identification_number, 39..53, :string, :optional
    field :individual_name, 54..75, :string, :required
    field :discretionary_data, 76..77, :string, :optional
    field :addenda_record_indicator, 78, :numeric, :mandatory
    field :trace_number, 79..93, :numeric, :mandatory
  end
  
  class BatchEntryPPD < BatchEntry
    standard_entry_class 'PPD'
    field :transaction_code, 1..2, :numeric, :mandatory
    field :receiving_dfi_identification, 3..10, :string, :mandatory
    field :check_digit, 11, :numeric, :mandatory
    field :dfi_account_number, 12..28, :string, :mandatory
    field :amount, 29..38, :currency, :mandatory
    field :individual_identification_number, 39..53, :string, :optional
    field :individual_name, 54..75, :string, :required
    field :discretionary_data, 76..77, :string, :optional
    field :addenda_record_indicator, 78, :numeric, :mandatory
    field :trace_number, 79..93, :numeric, :mandatory
  end
  
  class BatchControl < Record
    record_type_code 8
    field :service_class_code, 1..3, :numeric, :mandatory
    field :entry_count, 4..9, :numeric, :mandatory
    field :entry_hash, 10..19, :numeric, :mandatory
    field :total_debit_entry_dollar_amount, 20..31, :currency, :mandatory
    field :total_credit_entry_dollar_amount, 32..43, :currency, :mandatory
    field :company_identification, 44..53, :string, :optional
    field :message_authentication_code, 54..72, :string, :optional
    field :reserved, 73..79, :reserved
    field :originating_dfi_identification, 79..86, :numeric, :mandatory
    field :batch_number, 87..93, :numeric, :mandatory
  end
  
  class FileControl < Record
    record_type_code 9
    field :batch_count, 1..6, :numeric, :mandatory
    field :block_count, 7..12, :numeric, :mandatory
    field :entry_count, 13..20, :numeric, :mandatory
    field :entry_hash, 21..30, :numeric, :mandatory
    field :total_debit_entry_dollar_amount, 31..42, :currency, :mandatory
    field :total_credit_entry_dollar_amount, 43..54, :currency, :mandatory
    field :reserved, 55..93, :reserved
  end

end
