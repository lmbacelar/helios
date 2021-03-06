Given /^the "([^"]*)" with ([^"]*) "(.*?)" exists$/ do |resource, attribute, value|
  klass_from(resource).create attribute => value
end

Given /^the following "([^"]*)" exist:$/ do |resource, table|
  table.hashes.each do |hash|
    klass_from(resource).create hash
  end    
end

Given /^the following "([^"]*)" exist for "([^"]*)" with ([^"]*) "(.*?)":$/ do |child_resource, parent_resource, attribute, value, table|
  parent = klass_from(parent_resource).find_by(attribute => value)
  table.hashes.each do |hash|
    parent.send(table_name_from child_resource).create hash
  end    
end

Given /^I am on the new "(.*?)" page$/ do |resource|
  visit "/#{table_name_from(resource)}/new"
end

Given /^I am on the new "([^"]*)" page for "([^"]*)" with ([^"]*) "(.*?)"$/ do |child_resource, parent_resource, attribute, value|
  parent_id = klass_from(parent_resource).find_by(attribute => value).id
  visit "/#{table_name_from parent_resource}/#{parent_id}/#{table_name_from child_resource}/new"
end

Given /^I am on the page for the last "(.*?)"$/  do |resource|
  visit "/#{table_name_from resource}/#{last_id_from resource}"
end

Given /^I have no "([^"]*)"$/ do |resource|
  klass_from(resource).delete_all
end

Given /^I have no "([^"]*)" for "([^"]*)" with ([^"]*) "(.*?)"$/ do |child_resource, parent_resource, attribute, value|
  parent = klass_from(parent_resource).find_by(attribute => value)
  parent.send(table_name_from child_resource).delete_all
end


When /^(?:|I )fill in "([^"]*)" with "([^"]*)"$/ do |field, value|
  fill_in(field, with: value)
end

When /^(?:|I )press "([^"]*)"$/ do |button|
  click_button(button)
end

When /^I visit the "(.*?)" page$/ do |resource|
  visit "/#{table_name_from(resource)}"
end

When /^I visit the page of "(.*?)" with ([^"]*) "(.*?)"$/ do |resource, attribute, value|
  resource_id = klass_from(resource).find_by(attribute => value).id
  target_path = "/#{table_name_from resource}/#{resource_id}"
  visit target_path
end

When /^I visit the "([^"]*)" page for "([^"]*)" with ([^"]*) "(.*?)"$/ do |child_resource, parent_resource, attribute, value|
  parent_id = klass_from(parent_resource).find_by(attribute => value).id
  target_path = "/#{table_name_from parent_resource}/#{parent_id}/#{table_name_from child_resource}"
  visit target_path
end

When /^(?:|I )follow "([^"]*)"$/ do |link|
  click_link(link)
end

When /^(?:|I )follow the first "([^"]*)"$/ do |link|
  page.first(:link, link).click
end

Then /^(?:|I )should be on the "(.+)" page$/ do |resource|
  target_path = "/#{table_name_from(resource)}"
  expect(current_path).to eq target_path
end

Then /^I should be on the new "(.*?)" page$/  do |resource|
  target_path = "/#{table_name_from resource}/new"
  expect(current_path).to eq target_path
end

Then /^I should be on the "([^"]*)" page for "([^"]*)" with ([^"]*) "(.*?)"$/ do |child_resource, parent_resource, attribute, value|
  parent_id = klass_from(parent_resource).find_by(attribute => value).id
  target_path = "/#{table_name_from parent_resource}/#{parent_id}/#{table_name_from child_resource}"
  expect(current_path).to eq target_path
end

Then /^I should be on the new "([^"]*)" page for "([^"]*)" with ([^"]*) "(.*?)"$/ do |child_resource, parent_resource, attribute, value|
  parent_id = klass_from(parent_resource).find_by(attribute => value).id
  target_path = "/#{table_name_from parent_resource}/#{parent_id}/#{table_name_from child_resource}/new"
  expect(current_path).to eq target_path
end

Then /^(?:|I )should be on the page of the last "([^"]*)"$/ do |resource|
  target_path = "/#{table_name_from resource}/#{last_id_from resource}"
  expect(current_path).to eq target_path
end

Then /^(?:|I )should be on the page of the last "([^"]*)" for "([^"]*)" with ([^"]*) "(.*?)"$/ do |child_resource, parent_resource, attribute, value|
  parent_id = klass_from(parent_resource).find_by(attribute => value).id
  target_path = "/#{table_name_from parent_resource}/#{parent_id}/#{table_name_from child_resource}/#{last_id_from child_resource}"
  expect(current_path).to eq target_path
end


Then /^I should be on the page of "(.*?)" with ([^"]*) "(.*?)"$/ do |resource, attribute, value|
  resource_id = klass_from(resource).find_by(attribute => value).id
  target_path = "/#{table_name_from resource}/#{resource_id}"
  expect(current_path).to eq target_path
end

Then /^(?:|I )should see "([^"]*)"$/ do |text|
  expect(page).to have_content(text)
end

Then /^(?:|I )should see \/([^\/]*)\/$/ do |regexp|
  expect(page).to have_xpath('//*', text: Regexp.new(regexp)) 
end

Then /^(?:|I )should not see "([^"]*)"$/ do |text|
  expect(page).to have_no_content(text)
end

Then /^(?:|I )should not see \/([^\/]*)\/$/ do |regexp|
  expect(page).to have_no_xpath('//*', text: Regexp.new(regexp))
end

Then /^I should see "(.*?)" before "(.*?)"$/ do |text1, text2|
  expect(page.body).to match /#{Regexp.quote(text1)}.*#{Regexp.quote(text2)}/m
end

Then /^I should see one "(.*?)" link$/ do |link_text|
  expect(page.body).to have_css('a', text: link_text, count: 1)
end

Then /^I should see (\d+) "(.*?)" links$/ do |count, link_text|
  expect(page.body).to have_css('a', text: link_text, count: count)
end
