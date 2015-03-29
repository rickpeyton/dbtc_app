require "rails_helper"

describe Link do
  it { should belong_to(:chain) }
  it { should validate_presence_of(:link_day) }
  it { should validate_presence_of(:chain_id) }
  it { should validate_uniqueness_of(:link_day).scoped_to(:chain_id) }
end

