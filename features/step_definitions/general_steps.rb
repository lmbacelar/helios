Given /^the following "(.*?)" exist:$/ do |resource, table|
  table.hashes.each do |hash|
    klass_from(resource).create hash
  end    
end

Given /^I am on the new "(.*?)" page$/ do |resource|
  visit "/#{table_name_from(resource)}/new"
end

Given /^I am on the page for the last "(.*?)"$/  do |resource|
  visit "/#{table_name_from resource}/#{last_id_from resource}"
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

Then /^(?:|I )should be on the page of the last "(.+)"$/ do |resource|
  target_path = "/#{table_name_from resource}/#{last_id_from resource}"
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

Then /^"(.*?)" should appear before "(.*?)"$/ do |text1, text2|
  expect(page.body).to match /#{text1}.*#{text2}/m
end
