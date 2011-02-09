class ACH

  class Errors < Array
    def to_s
      join(', ')
    end
  end

  module ErrorsArray
    def errors
      @errors ||= Errors.new
    end
  end

  class Exception < ::Exception; end
  class ParserError < Exception; end
  class InvalidRecord < Exception; end
  class InvalidField < Exception; end
  class InvalidBatchClass < Exception; end
  class NoFieldError < Exception; end

end
