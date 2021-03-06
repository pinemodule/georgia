require 'spec_helper'

describe Georgia::PagesController do
  include Devise::TestHelpers

  before :all do
    Georgia::Page.tire.index.delete
    Georgia::Page.tire.create_elasticsearch_index
    @page = create(:georgia_page)
  end

  before :each do
    @current_user = create(:georgia_admin_user)
    controller.class.skip_before_filter :authenticate_user!
    controller.stub current_user: @current_user
  end

  it "should retrieve the model name of the controller" do
    controller.model.name.should eq("Georgia::Page")
  end

  describe "GET search" do

    it "should have a status code of 200" do
      get :search, use_route: :admin
      response.should be_ok
    end

  end

  describe "GET index" do

    it "should redirect to search" do
      get :index, use_route: :admin, id: @page.id
      response.should be_redirect
    end

  end

  describe "GET show" do

    it "should redirect to edit" do
      get :show, use_route: :admin, id: @page.id
      response.should be_redirect
    end

  end

  describe "GET edit" do

    it "should redirect to revisions#edit" do
      get :edit, use_route: :admin, id: @page.id
      response.should be_redirect
    end

  end

  describe "GET settings" do

    it "should have a status code of 200" do
      get :settings, use_route: :admin, id: @page.id
      response.should be_ok
    end

    it "should render the page" do
      get :settings, use_route: :admin, id: @page.id
      assigns(:page).should eq @page
    end

  end

  describe "GET copy" do

    it "should redirect to revisions#edit" do
      get :copy, use_route: :admin, id: @page.id
      response.should be_redirect
    end

  end

  describe "GET flush_cache" do

    it "should redirect :back" do
      request.env["HTTP_REFERER"] = "where_i_came_from"
      get :flush_cache, use_route: :admin, id: @page.id
      response.should be_redirect
    end

  end

  describe "POST create" do

    it "should redirect to revisions#edit" do
      post :create, use_route: :admin, title: "New page"
      response.should be_redirect
    end

    it "should assign a current_revision with contents" do
      post :create, use_route: :admin, title: "New page"
      assigns(:page).should have(1).revision
      assigns(:page).current_revision.should be_a_kind_of Georgia::Revision
      assigns(:page).current_revision.should have(1).contents
    end

    it "should assign a revision with title" do
      post :create, use_route: :admin, title: "New page"
      assigns(:page).current_revision.contents.first.title.should match "New page"
    end

    it "should assign a revision with a locale" do
      post :create, use_route: :admin, title: "New page"
      assigns(:page).current_revision.contents.first.locale.should_not be_nil
    end

    it "should assign a revision with default template" do
      post :create, use_route: :admin, title: "New page"
      assigns(:page).current_revision.template.should match 'default'
    end

  end

  describe "PUT update" do

    it "should have a status code of 200" do
      put :update, use_route: :admin, id: @page.id
      response.should be_ok
    end

  end

end