class ACH
  class Batch
    attr_reader :entries, :header, :control

    def initialize(header = nil, control = nil)
      @header = header
      @entries = [ ]
      @control = control
      yield @entries if block_given?
    end

    def add_entry(entry)
      @entries << entry
    end

    def add_addenda(addenda)
      @entries << addenda
    end

    def header=(h)
      if h.is_a? BatchHeader
        @header = h
        @standard_class = h.standard_entry_class_code
      else
        raise InvalidRecord.new("#{h} is not an ACH::BatchHeader")
      end
    end

    def control=(c)
      if c.is_a? BatchControl
        @control = c
      else
        raise InvalidRecord.new("#{h} is not an ACH::BatchControl")
      end
    end

    def to_a
      [ header, entries, control ].flatten.compact
    end

    def [](index)
      to_a[index]
    end

    def first
      to_a.first
    end

    def last
      to_a.last
    end

    def length
      to_a.length
    end

    def delete_entry(index)
      @entries.delete(index)
    end

    def standard_class
      header.standard_entry_class_code.value
    end

    def dump
      header.dump +
        entries.reduce('') { |subdump, entry| subdump + entry.dump } +
        control.dump
    end

    def add_offset(o)
      offset = BatchEntryPPD.new
      offset.transaction_code = balance > 0 ? 27 : 22
      offset.receiving_dfi_identification = o[:routing_number]
      offset.check_digit = 0
      offset.dfi_account_number = o[:account_number]
      offset.amount = balance.abs
      offset.individual_name = o[:name]
      offset.addenda_record_indicator = 0
      offset.trace_number = 0
      add_entry offset
    end

    def generate!
      header.service_class_code =
      if entry_types.include? :credit
        if entry_types.include? :debit
          200
        else
          220
        end
      else
        225
      end      

      @control = BatchControl.new
      control[0] = header.service_class_code.value
      control[1] = entries.length
      control[2] = checksum
      control[3] = total_debit_amount
      control[4] = total_credit_amount
      control[5] = header.company_identification.value
      control[8] = header.originating_dfi_identification.value
      control[9] = header.batch_number.value
    end

    def checksum
      entries.reduce(0) do |subhash, entry|
        subhash + entry.dump[3..10].to_i
      end.to_s[0,10].to_i
    end

    def total_debit_amount
      entries.reduce(0.0) do |subtotal, entry|
        entry.debit? ? subtotal + entry.amount.to_f : subtotal
      end
    end

    def total_credit_amount
      entries.reduce(0.0) do |subtotal, entry|
        entry.credit? ? subtotal + entry.amount.to_f : subtotal
      end
    end

    def balance
      total_credit_amount - total_debit_amount
    end

    def entry_types
      entries.map { |entry| entry.transaction_type }.uniq
    end
  end
end
