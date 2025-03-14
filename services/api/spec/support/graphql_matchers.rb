RSpec::Matchers.define :have_field do |field_name|
  match do |subject|
    @field = subject.fields[field_name.to_s.camelize(:lower)]

    # Ensure the field exists
    @field.present? && @field.type.to_type_signature == @expected_type
  end

  # Specify the custom matcher behavior
  chain :of_type do |expected_type|
    @expected_type = expected_type
  end

  failure_message do
    if @field.nil?
      "Expected field #{field_name} to be defined"
    else
      "Expected field #{field_name} to be of type #{@expected_type}, but was #{@field.type.to_type_signature}"
    end
  end
end
