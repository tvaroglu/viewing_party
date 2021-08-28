require 'rails_helper'

RSpec.describe User do
  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
  end

  describe 'relationships' do
    it { should have_many(:attendees) }
    it { should have_many(:events).through(:attendees) }
    it { should have_many(:followed_users) }
    it { should have_many(:followees).through(:followed_users) }
    it { should have_many(:following_users) }
    it { should have_many(:followers).through(:following_users) }
  end

  describe 'methods' do
    before :each do
      @taylor = User.create!(email: 'foo@bar.com', password: 'test')
      @dane = User.create!(email: 'boo@far.com', password: 'nico')
      @admin = User.create!(email: 'admin@example.com', password: 'guest')
    end

    it 'can return following users' do
      expect(@admin.followers).to eq([])
      expect(@admin.has_friends?).to be false
      expect(@admin.already_friends_with?(@taylor.id)).to be false
      expect(@admin.already_friends_with?(@dane.id)).to be false

      @admin.followers << @taylor
      @admin.followers << @dane

      expect(@admin.followers).to eq([@taylor, @dane])
      expect(@admin.has_friends?).to be true
      expect(@admin.already_friends_with?(@taylor.id)).to be true
      expect(@admin.already_friends_with?(@dane.id)).to be true
    end
  end
end
