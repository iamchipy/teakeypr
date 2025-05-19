require "application_system_test_case"

class TimeEntriesTest < ApplicationSystemTestCase
  setup do
    @time_entry = time_entries(:one)
  end

  test "visiting the index" do
    visit time_entries_url
    assert_selector "h1", text: "Time entries"
  end

  test "should create time entry" do
    visit time_entries_url
    click_on "New time entry"

    fill_in "Description", with: @time_entry.description
    fill_in "End time", with: @time_entry.end_time
    fill_in "Notes", with: @time_entry.notes
    fill_in "Start time", with: @time_entry.start_time
    fill_in "Task", with: @time_entry.task
    click_on "Create Time entry"

    assert_text "Time entry was successfully created"
    click_on "Back"
  end

  test "should update Time entry" do
    visit time_entry_url(@time_entry)
    click_on "Edit this time entry", match: :first

    fill_in "Description", with: @time_entry.description
    fill_in "End time", with: @time_entry.end_time.to_s
    fill_in "Notes", with: @time_entry.notes
    fill_in "Start time", with: @time_entry.start_time.to_s
    fill_in "Task", with: @time_entry.task
    click_on "Update Time entry"

    assert_text "Time entry was successfully updated"
    click_on "Back"
  end

  test "should destroy Time entry" do
    visit time_entry_url(@time_entry)
    click_on "Destroy this time entry", match: :first

    assert_text "Time entry was successfully destroyed"
  end
end
