module Liquid

  # Assign sets a variable in your template.
  #
  #   {% assign foo = 'monkey' %}
  #
  # You can then use the variable later in the page.
  #
  #  {{ foo }}
  #
  class Assign < Tag
    Syntax = /(#{VariableSignature}+)\s*=\s*(.*)\s*/o
  
    def initialize(tag_name, markup, tokens)          
      if markup =~ Syntax
        @to = $1
        @from = Variable.new($2)
      else
        raise SyntaxError.new("Syntax Error in 'assign' - Valid syntax: assign [var] = [source]")
      end
      
      super      
    end
  
    def render(context)
      val = @from.render(context)
      context.scopes.last[@to] = val
      context.resource_limits[:assign_score_current] += (val.respond_to?(:length) ? val.length : 1)
      ''
    end 
  
  end  
  
  Template.register_tag('assign', Assign)  
end
