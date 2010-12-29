autoload :YAML, 'yaml'

require 'stringio'

require 'ach/errors'
require 'ach/field'
require 'ach/record'
require 'ach/batch'

class ACH
  attr_accessor :header, :batchs, :control, :options

  def initialize(opts = {})
    @options = ACH.defaults.merge(opts)
    @batchs = []
  end

  def add_batch(batch = nil)
    if not batch
      batch = Batch.new
    elsif not batch.is_a? Batch
      batch = Batch.new(batch)
    end
    @batchs << batch
  end
    

  def [](index)
    if index == 0
      @header
    else
      index -= 1
      result = nil

      batchs.each do |batch|
        result = batch[index] if index < batch.length
        index -= batch.length
      end

      result = control if not result and index == 0

      result
    end
  end

  def last
    (control ? control : batchs.last.last)
  end

  def length
    batchs.reduce(0) { |s, b| s + b.length } + (@header?1:0) + (@control?1:0)
  end

  def dump
    header.dump +
    batchs.reduce('') { |subdump, batch| subdump + batch.dump } +
    control.dump
  end

  def generate!
    @header = FileHeader.new(ACH.template) unless @header

    batchs.each do |batch|
    if options[:offset]
      batch.add_offset(:name => 'offset',
        :account_number => header.immediate_origin.value,
        :routing_number => header.immediate_destination.value)
      end
      batch.generate!
    end

    @control ||= FileControl.new
    control.batch_count = batchs.length
    control.block_count = length
    control.entry_count = batchs.reduce(0) do |sub, batch|
        sub + batch.length
    end

    control.entry_hash = batchs.reduce(0) do |sub, batch|
        sub + batch.checksum
    end.to_s[0,10].to_i

    control.total_credit_entry_dollar_amount = batchs.reduce(0) do |sub, batch|
        sub + batch.total_credit_amount
    end

    control.total_debit_entry_dollar_amount = batchs.reduce(0) do |sub, batch|
        sub + batch.total_debit_amount
    end

    self
  end

  def parse(data, record_size = 94)
    data = StringIO.new(data) unless data.respond_to?(:read)

    ach = ACH.new
    record_number = 0
    last_record_type = nil
    while not data.eof?
      record = data.readline.chop #(record_size))
      record_number += 1

      break if last_record_type == :file_control and record =~ /^9+$/

      begin
        record = Record.parse(record)
      rescue InvalidBatchClass => e
        record = BatchEntry.parse(record, ach.batchs.last.header.standard_entry_class_code.value)
      rescue InvalidRecord => e
        raise ParserError.new(e.to_s)
      end

      raise ParserError.new("unexpected #{record.type} after" +
          " #{last_record_type} (record ##{record_number})") unless
      case record.type
      when :file_header
        if ach.header
          raise ParserError.new("file header duplicated" +
              " (record ##{record_number})")
        else
          ach.header = record
        end
      when :batch_header
        ach.add_batch Batch.new(record) if
        [ :file_header, :batch_control ].include? last_record_type
      when :batch_entry
        ach.batchs.last.add_entry record if
        [ :batch_header, :batch_entry, :addenda_entry ].include? last_record_type
      when :addenda_entry
        ach.batchs.last.add_addenda record if
        [ :batch_entry, :addenda_entry ].include? last_record_type
      when :batch_control
        ach.batchs.last.control = record if
        [ :batch_entry, :addenda_entry ].include? last_record_type
      when :file_control
        if :batch_control == ach.last.type
          raise ParserError.new("file control duplicated" +
              " (record ##{record_number}") if ach.control
          ach.control = record
        end
      end

      last_record_type = record.type

    end

    ach
  end

  def add_payment(acc_type, acc_route, acc_no, name, amount, trace)
    unless batchs.first
      bh = BatchHeader.new(ACH.template)
      bh.standard_entry_class_code = 'PPD'
      add_batch(Batch.new(bh))
    end

    e = BatchEntryPPD.new
    e.transaction_code.value =
      case acc_type
        when 'Savings': 32
        when 'Checking': 22
      end
    e.receiving_dfi_identification = acc_route
    e.dfi_account_number = acc_no
    e.amount = amount
    e.individual_name = name
    e.trace_number = trace
    e.addenda_record_indicator = 0
    e.check_digit = 1

    batchs.first.add_entry(e)
  end

  class << self

    def parse(data, *args)
      self.new.parse(data, *args)
    end
    alias load parse

    def template
      (@template ||= {})
    end

    def defaults
      (@defaults ||= {})
    end

    def load_config(options)
      template[:file_header] = {
        :priority_code => 1,
        :immediate_destination => options['immediate_destination']['id'],
        :immediate_origin => options['immediate_origin']['id'],
        :creation_date => Time.now,
        :creation_time => Time.now,
        :id_modifier => 'A',
        :record_size => 94,
        :blocking_factor => '10',
        :format_code => '1',
        :immediate_destination_name => options['immediate_destination']['name'],
        :immediate_origin_name => options['immediate_origin']['name'],
        :reference_code => '00000000' }

      template[:batch_header] = {
        :service_class_code => 200,
        :company_name => options['immediate_origin']['name'],
        :company_identification => options['immediate_origin']['id'],
        :company_entry_description => 'EPAY001',
        :company_descriptive_date => Time.now,
        :effective_entry_date => Time.now,
        :originator_status_code => '1',
        :originating_dfi_identification => options['immediate_destination']['id'].to_s[0,8].to_i,
        :batch_number => 0 }

      defaults[:offset] = options['offset'] || false
    end

  end
end
