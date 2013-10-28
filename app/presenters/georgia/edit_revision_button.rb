module Georgia
  class EditRevisionButton

    attr_accessor :view, :instance, :actions

    delegate :icon_tag, :content_tag, :link_to, :controller_name, :url_for, :can?, to: :view, prefix: false

    def initialize view, instance, actions={}
      @view = view
      @instance = (instance.decorated? ? instance.object : instance)
      @actions = actions
    end

    def to_s
      content_tag 'div', class: 'btn-group' do
        group_button + group_list
      end
    end

    private

    def page
      instance.revisionable
    end

    def group_button
      link_to(icon_tag('icon-cog'), [:edit, page, instance], class: 'btn btn-inverse') +
      link_to(content_tag('span', '', class: 'caret'), '#', group_button_options)
    end

    def group_list
      html = ""
      html << content_tag(:li, link_to_edit)
      html << EditRevisionActionList.new(view, instance)
      content_tag :ul, html.html_safe, class: 'dropdown-menu pull-right'
    end

    def link_to_edit
      link_to "#{icon_tag('icon-pencil')} Edit".html_safe, [:edit, page, instance] if can?(:edit, instance)
    end

    def group_button_options
      { class: 'btn btn-inverse dropdown-toggle', data: {toggle: "dropdown"} }
    end

  end
end