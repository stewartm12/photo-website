RSpec::Matchers.define :deliver_later do |expected_method|
  match do |mailer_class|
    mail = double(:mail)

    expect(mailer_class).to receive(expected_method).and_return(mail)
    expect(mail).to receive(:deliver_later)
  end
end
