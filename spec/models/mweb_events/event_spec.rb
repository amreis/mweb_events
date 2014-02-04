require "spec_helper"

describe MwebEvents::Event do

  let(:event) { FactoryGirl.create(:event) }

  it "should not validate an event with wrong date range" do
    pending
    FactoryGirl.build(:event,
      :start_on => Date.today, :end_on => Date.today - 1).should_not be_valid
  end

  it "creates a new instance given valid attributes" do
    FactoryGirl.build(:event).should be_valid
  end

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:permalink) }
  it { should ensure_length_of(:summary).is_at_most(140) }

  it { should have_many(:participants).dependent(:destroy) }

  it { should belong_to(:owner) }

  it { should respond_to(:address) }
  it { should respond_to(:address=) }
  it { should respond_to(:start_on) }
  it { should respond_to(:start_on=) }
  it { should respond_to(:end_on) }
  it { should respond_to(:end_on=) }
  it { should respond_to(:description) }
  it { should respond_to(:description=) }
  it { should respond_to(:location) }
  it { should respond_to(:location=) }
  it { should respond_to(:name) }
  it { should respond_to(:name=) }
  it { should respond_to(:time_zone) }
  it { should respond_to(:time_zone=) }
  it { should respond_to(:social_networks) }
  it { should respond_to(:social_networks=) }
  it { should respond_to(:summary) }
  it { should respond_to(:summary=) }
  it { should respond_to(:owner_id) }
  it { should respond_to(:owner_id=) }
  it { should respond_to(:owner_type) }
  it { should respond_to(:owner_type=) }

  it { should respond_to(:owner_name) }
  it { should respond_to(:owner_name=) }

  describe ".within" do
    let(:today) { Time.now }

    before(:each) do
      e1 = FactoryGirl.create(:event, :start_on => today + 1.day, :end_on => today + 3.day)
      e2 = FactoryGirl.create(:event, :start_on => today, :end_on => today + 2.day)
    end

    it { MwebEvents::Event.within(today, today + 2.day).should_not be_empty }
    it { MwebEvents::Event.within(today + 1.day, today + 2.day).should_not be_empty }
    it { MwebEvents::Event.within(today + 4.day, today + 5.day).should be_empty }
  end

  describe "social_networks attribute tokenization" do

    context "valid social network names" do
      let(:target) { FactoryGirl.create(:event, :social_networks => ['Facebook', 'Twitter']) }

      it { target.social_networks.should_not be_empty }
      it { target.social_networks.should include('Facebook') }
      it { target.social_networks.should include('Twitter') }
    end

    context "one invalid social network name" do
      let(:target) { FactoryGirl.create(:event, :social_networks => ['Facistbook', 'Twitter']) }

      it { target.social_networks.should_not be_empty }
      pending { target.social_networks.should_not include('Facistbook') }
      it { target.social_networks.should include('Twitter') }
    end

  end

  describe "coordinates are geocoded by address", :geocoding => true do
    let(:target) { FactoryGirl.create(:event, :address => 'Porto Alegre, Brazil', :longitude => nil, :latitude => nil) }

    it { target.longitude.should_not be_nil }
    it { target.latitude.should_not be_nil }
  end

  describe "clear coordinates when address is set to blank" do
    let(:target) { FactoryGirl.create(:event, :address => 'Porto Alegre, Brazil', :longitude => nil, :latitude => nil) }
    before(:each) {
      target.address = ''
      target.save
    }

    it { target.longitude.should be_nil }
    it { target.latitude.should be_nil }
  end

  describe "don't clear coordinates when other data is set to blank" do
    let(:target) { FactoryGirl.create(:event, :address => 'Porto Alegre, Brazil', :location => 'My House',
      :longitude => nil, :latitude => nil) }

    before(:each) {
      target.location = ''
      target.save
    }

    it { target.longitude.should_not be_nil }
    it { target.latitude.should_not be_nil }
  end


  pending "#to_ics"

  describe "abilities", :abilities => true do
    subject { ability }
    let(:ability) { MwebEvents::Ability.new(owner) }
    let(:target) { FactoryGirl.create(:event) }

    context "when it's the event creator" do
      let(:owner) { target.owner }
      it { should be_able_to_do_anything_to(target).except([:register]) }
    end

    context "when it's not the event creator" do
      let(:owner) { FactoryGirl.create(:owner) }
      it { should_not be_able_to_do_anything_to(target).except([:read, :create]) }
    end

  end

end
