module Georgia
  class AdminDecorator < ApplicationDecorator
    decorates :admin, class: Georgia::Admin

    def name
      [first_name, last_name].join(' ')
    end

    def roles
      model.roles.map(&:name).join(', ')
    end

  end
end