module Georgia
  class PagesController < ApplicationController

    include Georgia::Concerns::Notifying
    include Georgia::Concerns::Publishing
    include Georgia::Concerns::Searchable
    include Georgia::Concerns::Sorting

    before_filter :prepare_new_page, only: [:search, :find_by_tag]
    before_filter :prepare_page, only: [:show, :edit, :settings, :update, :copy, :preview, :destroy, :flush_cache]

    # FIXME: Still needed?
    def find_by_tag
      @pages = model.tagged_with(params[:tag]).page(params[:page])
      @pages = Georgia::PagesDecorator.decorate(@pages)
      render :index
    end

    def show
      redirect_to [:edit, @page]
    end

    # Edit current revision
    def edit
      redirect_to edit_page_revision_path(@page, @page.current_revision)
    end

    def settings
    end

    def create
      @page = model.new(slug: params[:title].try(:parameterize))
      if @page.save
        @page.revisions.create(template: Georgia.templates.first) do |rev|
          rev.contents << Georgia::Content.new(locale: I18n.default_locale, title: params[:title])
        end
        @page.update_attribute(:current_revision, @page.revisions.first)
      end
    end

    def update
      # FIXME: Throw an error if update_attributes returns false
      @page.update_attributes(params[:page])
      respond_to do |format|
        format.html { render :edit, notice: "#{decorate(@revision).title} was successfully updated." }
        format.js { render layout: false }
      end
    end

    def copy
      @copy = @page.copy
      redirect_to [:edit, @copy], notice: "Do not forget to change your url"
    end

    def preview
      redirect_to @page.url
    end

    def destroy
      @message = "#{@page.title} was successfully deleted."
      @page.destroy
      redirect_to [:search, model], notice: @message
    end

    def flush_cache
      if expire_action(@page.cache_key)
        redirect_to :back, notice: "Cache was successfully cleared for #{@page.url}"
      else
        redirect_to :back, alert: "Oups. Either there wasn't any cache to start with or something went wrong."
      end
    end

    private

    def prepare_new_page
      @page = model.new
    end

    def prepare_page
      @page = model.find(params[:id]).decorate
    end

  end
end
