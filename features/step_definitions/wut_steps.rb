Given /^an arbitrary string$/ do
  @string = 'WUT'

  assert \
    @string,
    'No string is presented to pass into the Wut engine'
end

When /^I invoke wut$/ do
  @result = Wut.generate @string

  assert \
    @result,
    "Wut can't generate the cod"
end

Then /^a ruby script should be generated$/ do
  pending # express the regexp above with the code you wish you had
end
