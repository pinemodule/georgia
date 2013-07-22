require 'spec_helper'

describe Georgia::MetaPage do

  specify {FactoryGirl.build(:georgia_meta_page).should be_valid}

  it { should validate_uniqueness_of(:slug).scoped_to(:ancestry) }

  it_behaves_like 'a revisionable model'

  describe 'uuid' do
    it 'creates a new uuid for each newly created page' do
      @page = FactoryGirl.create(:georgia_meta_page)
      expect(@page.uuid).to match /[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/
    end
  end

end