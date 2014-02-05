# UserDefinedAttributes

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'user_defined_attributes'

And then execute:

    $ bundle

Then install the migrations

    $ rails g user_defined_attributes:install
    $ rake db:migrate

## Usage

To use UDA, first you need to mix-in UDA into a model

```ruby
class User < ActiveRecord::Base
  include MultiTenantModel # require `tenant_id` and `belongs_to :tenant`
  include UDA
end
```

Then you need to mount the UDA routes

```ruby routes.rb
Dummy::Application.routes.draw do
  mount UserDefinedAttributes::Engine, at: "uda"
end
```

Then you need to make the UDA helpers accessible to your views

```ruby users_controller.rb
class UsersController < ActionController::Base
  helper UserDefinedAttributes::UdaHelper
end
```

Then you need to add UDA to your form

```ruby users/_form.html.erb
<%= form_for @user do |f| %>

  <%= uda_fields(f) %>

<% end %>
```

Finally you need to provide the path to the UDA types path so that UDA types can be added to the system

```ruby settings/index.html.erb
<%= link_to 'Manage User Defined Types', user_defined_types_path %>
```

## Multitenacy

UDA will only work if there is a tenant.  We assume there is a class which responds to `id`, which we acquire through message passing.

```ruby
class Tenant < ActiveRecord::Base
  # used to cache the tenant in a thread safe way
  def self.current_id
    Thread.current[:tenant_id]
  end

  def self.current_id=(id)
    Thread.current[:tenant_id] = id
  end

  def self.current_tenant
    find(current_id)
  end
end
```

For the controllers and views we expect `current_tenant` to return the `Tenant` object.

```ruby
class ApplicationController < ActionController::Base
  before_filter :set_tenant
  helper        :current_tenant

  private
  def set_tenant
    Tenant.current_id = params[:tenant_id]
  end

  def current_tenant
    Tenant.current_tenant
  end
end
```

```erb users/show.html.erb
<%= current_tenant.name %>
```

For models we expect a belongs to relationship with tenant, which will add a `tenant` message.

```ruby user.rb
class User < ActiveRecord::Base
  default_scope { where tenant_id: Tenant.current_id }
  belongs_to :tenant
end
```

```irb
$ Tenant.create     #=> <Tenant @id=1>
$ User.create       #=> <User @id=1, @tenant_id=1>
$ User.first.tenant #=> <Tenant @id=1>
```

## Policy enforcement

The controllers and views will send messages to enforce permissions.

For the controller, `authorize(object,action=nil)`, is expected to raise an error if the action is not allowed on the object.  `action` must end with '?' or default to `params[:action]`.

```ruby
class ApplicationController
  private
  def authorize(object,action=nil)
    action = params[:action].to_s + '?'

    unless Policy.find(object).public_send(action)
      raise 'You cannot do this'
    end
  end
end

class UsersController < ApplicationController
  before_filter do
    # always check for tenant access
    authorize Tenant, :show?
  end

  def index
    # check if user can :index? User
    authorize User
  end
end
```

Views use the `can?(action, object)` and `can_set?(attribute, object)` messages.  `can?` returns if the user can perform an action on the object.  Unlike `authorize` the action **should not** have '?' appended.  `can_set?` does the same for attributes of the object.

```erb
<%= link_to 'Edit User', edit_users_path(@user) if can? :update, @user %>

<%= simple_form_for @user do |f| %>
  <% if can_set? :name, @user %>
    f.input :name
  <% end %>
<% end %>
```

## Contributing

1. Fork it ( http://github.com/waterfallfms/user_defined_attributes/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
