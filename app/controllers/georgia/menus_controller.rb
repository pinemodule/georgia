module Georgia
  class MenusController < ApplicationController

    load_and_authorize_resource class: Georgia::Menu

    def index
      @menus = Georgia::Menu.scoped.page(params[:page])
    end

    def new
      @menu = Georgia::Menu.new
    end

    def create
      @menu = Georgia::Menu.new(params[:menu])

      if @menu.save
        redirect_to [:edit, @menu], notice: "#{@menu.name} was successfully created."
      else
        render :new
      end
    end

    def show
      redirect_to edit_menu_path(params[:id])
    end

    def edit
      @menu = Georgia::Menu.find(params[:id])
      @links = @menu.links.roots
    end

    def update
      @menu = Georgia::Menu.find(params[:id])
      if @menu.update_attributes(params[:menu])
        head :ok
      end
    end

    def destroy
      @menu = Georgia::Menu.find(params[:id])
      @menu.destroy

      redirect_to menus_url
    end
  end
end