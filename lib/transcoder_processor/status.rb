module TranscoderProcessor
  class Status

    STATES = {
      nothing:     '-',
      enqueued:    'enqueued',
      working:     'working',
      failed:      'failed',
      successful:  'successful'
    }

    STATES.each do |state_name, state_description|
      const_set(state_name.upcase, state_description.to_sym)
    end

    attr_reader :state

    def initialize state=:nothing
      raise 'Unknown state' unless STATES[state]
      @state = state
    end

    def description
      STATES[state]
    end

    def complete?
      state == FAILED || state == SUCCESSFUL
    end

    STATES.each do |state_name, state_description|
      define_method "#{state_name}?" do
        state == state_name
      end
    end
  end
end
