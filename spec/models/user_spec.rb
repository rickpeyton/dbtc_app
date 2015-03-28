require "rails_helper"

describe User do
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should have_secure_password }
  it { should validate_presence_of(:password).on(:create) }
  it { should validate_length_of(:password).is_at_least(8) }
  it { should allow_value(
       'john@doe.com', 'john-doe@example.com', 'john.doe@example.com')
       .for(:email) }
  it { should_not allow_value('fiz').for(:email) }
  it { should_not allow_value('r!ck@gmail.com').for(:email) }
  it { should_not allow_value('john@doecom').for(:email) }
  it { should_not allow_value('john2doe.com').for(:email) }
  it { should have_many(:chains) }
end

