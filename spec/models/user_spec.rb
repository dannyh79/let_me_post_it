require 'rails_helper'

RSpec.describe User, type: :model do
  describe "data input" do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
  end
end
