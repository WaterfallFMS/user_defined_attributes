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
  helper 'user_defined_attributes/uda'
end
```

Then you need to add UDA to your form

```ruby users/_form.html.erb
<%= form_for @user do |f| %>

  <%= render_uda_in_form f %>

<% end %>
```

And add UDA to the show page

```ruby users/show.html.erb
<div>
  <%= render_uda_fields_for @user %>
</div>
```

Finally you need to provide the path to the UDA types controller so that UDA types can be added to the system

```ruby settings/index.html.erb
<%= link_to 'Manage User Defined Types', uda.field_types_path %>
```

## Strong parameters

In order to get a controller to accept the UDA fields you need to add them to the strong params list.  You can
use `uda_strong_params` which is mixed into the model.

```
def lead_params
  params.require(:lead).permit(:name, Lead.uda_strong_params)
end
```

It simply returns a hash `{field: [:array, :of, :uda, :type, :names]}`.  So you can fix in complex items via `merge`.

```
def lead_params
  params.require(:lead).permit(:name, :email, :other, Lead.uda_strong_params.merge(nested: :item))
end
```


## Assumptions

### Multitenacy

UDA will only work if there is a tenant.  We assume there is a class which respond to `current_tenant` returning an
 instance.  We assume the instances responds to `id`.

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
  helper_method :current_tenant

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

### Policy enforcement

The controllers and views will send messages to enforce permissions.

Controllers will send:

1. `policy_scope(class)` - returns an finder class objects that are scoped to the user.
1. `authorize(object,action=nil)` - expected to raise an error if the action is not allowed on the object.  The authorize object should pull the action from the param if not provided.

```ruby
class ApplicationController
  before_filter do
    # always check for tenant access
    authorize Tenant, :show?
  end

  private
  def authorize(object, action=nil)
    action ||= params[:action].to_s + '?'

    # delegate checking to the policy object
    unless Policy.find(object).public_send(action)
      raise 'You cannot do this'
    end
  end

  def policy_scope(object)
    # delegate scoping to the object itself
    object.for_user current_user
  end
end

class FieldTypesController < ::ApplicationController
  def index
    @field_types = policy_scope(FieldType)
  end

  def create
    @field_type = FieldType.new ...
    authorize @field_type
  end
end
```

Views will send:

1. `can?(action, object)` - returns true if the user can perform an action on the object.  Unlike `authorize` the action **should not** have '?' appended.
1. `can_set?(attribute, object)` - does the same for attributes of the object.

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
